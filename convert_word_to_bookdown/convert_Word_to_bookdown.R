# =============================================================================
# Setup
# =============================================================================

# load necessary libraries
library(rmarkdown)

# setup folders
root_dir        <- "C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/"
proj_dir        <- paste0(root_dir, "convert_word_to_bookdown/")
pagedown_dir    <- paste0(root_dir, "convert_md_to_pagedown/")
input_dir       <- paste0(proj_dir, "input/")
temp_dir        <- paste0(proj_dir, "temp/") 
output_dir      <- paste0(proj_dir, "output/")
input_doc_name  <- "Agricultural Survey Design_5_5.docx"

# =============================================================================
# Convert Word doc to Markdown
# =============================================================================

# convert docx to md with Pandoc
rmarkdown::pandoc_convert(
    input = paste0(input_dir, input_doc_name),      # Word doc
    output = paste0(temp_dir, "pandoc_output.md"),  # Markdown doc
    options = "--wrap=none" # Pandoc wraps line breaks after 80 characters; opt for no wrapping instead
)

# =============================================================================
# Create multiple {bookdown} "chapters" from single Markdown file
# =============================================================================

# -----------------------------------------------------------------------------
# Manipulate Markdown file: change headings
# -----------------------------------------------------------------------------

# why: 
# - document has no h1 headings, but {bookdown} requires each "chapter" begin with an h1 heading
# - all headings need to be "upgraded": h2, the biggest, becomes h1; h3 becomes h2
# ingest md file
my_md_file <- readLines(con = paste0(temp_dir, "pandoc_output.md"))
# change h2 to h1
my_md_file <- gsub(pattern = "##", replacement = "#", x = my_md_file)
# change h3 to h2
my_md_file <- gsub(pattern = "###", replacement = "##", x = my_md_file)

# to check operations, write as new file
# ... to this project
writeLines(my_md_file, con = paste0(temp_dir, "md_with_h1.md"))
# ... and as input to {pagedown} project
writeLines(my_md_file, con = paste0(pagedown_dir, "md_from_Word.md"))

# -----------------------------------------------------------------------------
# Find where h1 headings appear in the document
# -----------------------------------------------------------------------------

# transform single md into {bookdown} format: one file per h1 heading
h1_indices <- grep(pattern = "^# ", x = my_md_file)
# NOTE: here are the results
#  [1]   19  107  111  135  157  292  524  624  703  783  817  819 1089 1095
# [15] 1101

# remove several h1 headings from indices
# - sections to be put in front matter: 19, 107, 111
# - row 817, which is a heading that has no associated text
h1_indices <- h1_indices[!h1_indices %in% c(19, 107, 111, 817)] 

# -----------------------------------------------------------------------------
# Create one Markdown document for each h1 heading
# -----------------------------------------------------------------------------

#' Extract title from h1 heading
#' 
#' Extract the textual part of the title. Remove "Chapter N:" and "Appendix Roman N" prefixes
#' 
#' @param md_chr Character vector. Contents of Markdown file as character vector.
#' @param md_line_num Numeric. Line number in Markdown file containing the h1 heading title to extract.
extract_title <- function(
    md_chr,
    md_line_num
) {

    # extract line that contains the title
    line_w_title <- md_chr[md_line_num]
    # remove h1 prefix
    title <- gsub(
        pattern = "# ",
        replacement = "",
        x = md_chr[md_line_num]
    )
    # remove "Chapter N:" prefix, if present
    title <- gsub(title, pattern = "Chapter [0-9]+[: ]*", replacement = "")
    # remove "Appendix Roman N:" prefix, if present
    title <- gsub(title, pattern = "Appendix [I]+[: ]*", replacement = "")

    return(title)

}

#' Write chapter associated with h1 heading
#' 
#' Write to file a Markdown file that spans from the target h1 heading to the line before the next h1 heading. For the last h1 heading, write until the end.
#' 
#' @param md_chr Character vector. Contents of Markdown file as character vector.
#' @param h1_indices Numeric vector. Contains the line numbers of all h1 headings in the master Markdown file
#' @param index_num Numeric. Positional index in vector of h1 headings to handle. Facilitates iteration.
#' @param path. Character. Path to the folder where Mardown chapter chunks should be saved.
write_chapter <- function(
    md_chr,
    h1_indices,
    index_num,
    path
) {

    num_indices <- length(h1_indices)

    # from 1st to N-1th chapter
    if (index_num < num_indices) {

        # extract line numbers of current and next chapter title
        index_n <- h1_indices[index_num]
        index_n_plus_1 <- h1_indices[index_num+1]

        # extract chapter title
        chapter_title <- extract_title(md_chr = md_chr, md_line_num = index_n)

        # compose file name
        # - start with zero-padded number
        # - takes title with _ word separators
        # - adds .md extension
        file_name <- paste0(
            sprintf("%02d", index_num), "_",
            gsub(x = chapter_title, pattern = " ", replacement = "_"),
            ".md"
        )

        # write chapter chunk
        writeLines(
            text = md_chr[index_n:(index_n_plus_1-1)], 
            con = paste(path, file_name)
        )

    # for Nth chapter
    } else if (index_num == num_indices) {

        index_n <- h1_indices[index_num]

        chapter_title <- extract_title(md_chr = md_chr, md_line_num = index_n)

        file_name <- paste0(
            sprintf("%02d", index_num), "_",
            gsub(x = chapter_title, pattern = " ", replacement = "_"),
            ".md"
        )

        writeLines(
            text = md_chr[index_n:length(md_chr)],
            con = paste(path, file_name)
        )

    }


}

purrr::walk(
    .x = seq(from = 1, to = length(h1_indices), by = 1),
    .f = ~ write_chapter(
        md_chr = my_md_file,
        h1_indices = h1_indices,
        index_num = .x,
        path = output_dir
    )
)

