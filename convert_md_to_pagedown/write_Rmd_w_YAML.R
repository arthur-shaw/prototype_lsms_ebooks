# load necessary libraries
library(ymlthis)    # compose YAML
library(dplyr)      # use `magrittr` pipe; do basic manipulation

# load files and folders
pagedown_dir    <- "C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/convert_md_to_pagedown/"
markdown_doc    <- "md_from_Word.md"

# ingest
my_md_file <- readLines(con = paste0(pagedown_dir, markdown_doc))

# compose the YAML for the {pagedown} document
my_yaml <- ymlthis::yml() %>%
    ymlthis::yml_title("Agricultural Survey Design") %>%
    ymlthis::yml_subtitle("Lessons from the LSMS-ISA and Beyond") %>%
    ymlthis::yml_author(
        name = c(
            "Andrew Dillon","Gero Carletto","Sydney Gourlay","Philip Wollburg",
            "Alberto Zezza"
        ),
        affiliation = c(
            "Michigan State University", "World Bank", "World Bank", 
            "World Bank", "World Bank"
        )
    ) %>%
    ymlthis::yml_pagedown_opts(
        toc_title = "Table of Contents",
        lot_title = "List of Tables"
    ) %>%
    yml_output(
        pagedown::html_paged(
            toc = TRUE,
            lot = TRUE,
            self_contained = TRUE,
            css = c("default-fonts", "default-page", "default", "assets/my_styles.css"))
            # csl = The path of the Citation Style Language (CSL) file used to format citations and references
            # front_cover =  Paths or urls to image files to be used as front or back covers. Theses images are available through CSS variables (see Details).
            # back_cover = 
    )

# compose front cover div for document body
front_cover_div <- c(
    ":::front-cover",
    "```{r, out.height='100%', echo=FALSE}",
    'knitr::include_graphics(path = "assets/food-data-collection-cover.png")',
    "```",
    ":::"
)

# combine front cover to document body
my_body <- c(front_cover_div, my_md_file)

# create an Rmd file with the YAML and content above
ymlthis::use_rmarkdown(.yml = my_yaml, body = my_body, path = paste0(pagedown_dir, "index.Rmd"))
