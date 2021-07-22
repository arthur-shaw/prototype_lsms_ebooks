# load necessary libraries
library(officer)
library(tidyr)
library(dplyr)
library(flextable)

# input folder
input_dir <- "C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/handle_tables/inputs/"
ag_doc <- "Agricultural Survey Design_5_5.docx"
land_doc <- "LandGuidebook_16Jun16_AV_SG_v2.docx"

# create docx object
ag_survey_design <- read_docx(path = paste0(input_dir, ag_doc))
# create summary
ag_summary <- docx_summary(ag_survey_design)
# extract table via the `doc_index`
table104 <- dplyr::filter(ag_summary, doc_index == 104)

my_table <- table104 %>% 
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(
        names_from = cell_id, 
        names_prefix = "col_", 
        values_from = text, 
        id_cols = row_id
    ) %>% 
    # remove the title row and final row with footer
    dplyr::filter(row_id > 1 & row_id < 8) %>% 
    # rename variables to match headers
    rename(
        `Survey design choice` = col_1, 
        Considerations = col_2, 
        `Key knowledge gaps` = col_3, 
        `References` = col_4
    ) %>% 
    # remove row ID, which is no longer needed
    dplyr::select(-row_id)


# tables with text content


# tables with text content and merged cells in first column
table2_df <- dplyr::filter(ag_summary, doc_index == 150) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(
        names_from = cell_id, 
        names_prefix = "col_", 
        values_from = text, 
        id_cols = row_id
    ) %>%
    select(-row_id)
    # dplyr::filter(row_id %in% c(2, 17))
    # remove the title row and final row with footer
    # dplyr::filter(row_id > 1 & row_id < 8) %>% 
    # rename variables to match headers
    # rename(`Survey design choice` = col_1, Considerations = col_2, `Key knowledge gaps` = col_3, `References` = col_4) %>% 
    # remove row ID, which is no longer needed
    # dplyr::select(-row_id)    

table2_tbl <- flextable::flextable(data = table2_df) %>% 
    # delete header
    delete_part(part = "header") %>%
    # inner and outer borders
    border_outer() %>% 
    border_inner() %>% 
    # post-harvest heading
    flextable::merge_at(i = 1, j = c(1, 2, 3)) %>% 
    align(i = 1, j = 1, align = 'center') %>% 
    bold(i = 1, j = c(1, 2, 3)) %>% 
    italic(i = 1, j = c(1, 2, 3)) %>% 
    # column labels
    bold(i = 2, j = c(1, 2, 3)) %>% 
    # PP 1 - Parcel Roster
    merge_at(i = c(3, 4), j = 1) %>% 
    valign(i = c(3, 4), j = 1) %>% 
    # PP 2 - Parcel Details
    merge_at(i = c(5, 6), j = 1) %>% 
    valign(i = c(5, 6), j = 1) %>% 
    # PP 3 - Plot Roster
    merge_at(i = c(7:9), j = 1) %>% 
    valign(i = c(7:9), j = 1) %>% 
    # PP 4 - Plot Details
    merge_at(i = c(10:11), j = 1) %>% 
    valign(i = c(10:11), j = 1) %>% 
    # PP 6 - Crop Roster
    merge_at(i = c(12:15), j = 1) %>% 
    valign(i = c(12:15), j = 1) %>%
    # Post-Harvest Questionnaire heading
    flextable::merge_at(i = 16, j = c(1, 2, 3)) %>% 
    align(i = 16, j = 1, align = 'center') %>% 
    bold(i = 16, j = c(1, 2, 3)) %>% 
    italic(i = 16, j = c(1, 2, 3)) %>%
    # column labels
    bold(i = 17, j = c(1, 2, 3)) %>% 
    # PH 7 - Field Crop Production
    merge_at(i = c(18:21), j = 1) %>% 
    valign(i = c(18:21), j = 1) %>% 
    # PH 8 - Field Crop Disposition
    merge_at(i = c(22:26), j = 1) %>% 
    valign(i = c(22:26), j = 1) %>%
    # bold first column
    bold(j = 1) %>%
    # expand third column
    width(j = 3, width = 3)


table3 <- dplyr::filter(ag_summary, doc_index == 169) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# shortcoming:
# - links in column 3
# - bullets and carriage return in column 4

# try {pander}
# see here: https://stackoverflow.com/questions/31049691/how-to-write-multi-level-bullet-lists-in-a-table-using-rmarkdown-and-pandoc
# or here: https://stackoverflow.com/questions/52962411/table-with-long-text-bullet-points-and-specific-table-width

table_iii_df <- dplyr::filter(ag_summary, doc_index == 495) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(
        names_from = cell_id, 
        names_prefix = "col_", 
        values_from = text, 
        id_cols = row_id
    ) %>%
    select(-row_id) %>%
    slice(-1) %>%
    rename(
        Term = col_1,
        Description = col_2
    )

table_iii_tbl <- flextable::flextable(data = table_iii_df) %>%
    theme_zebra(
        odd_body = "#E7CBBF"
    ) %>%
    theme_zebra(
        odd_body = "#E7CBBF"
    ) %>% bg(bg = "#B1422F", part = 'header')

# create docx object
land <- read_docx(path = paste0(input_dir, land_doc))
# create summary
land_summary <- docx_summary(land)

land_table1 <- dplyr::filter(land_summary, doc_index == 85) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# need vertical merge for first 2 rows


land_table2 <- dplyr::filter(land_summary, doc_index == 94) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# looks good; vertical merge for first column


land_table3 <- dplyr::filter(land_summary, doc_index == 121) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# looks good; vertical merge for first column



land_table8 <- dplyr::filter(land_summary, doc_index == 330) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# actually looks good; stars are no worse than in Word



land_table10 <- dplyr::filter(land_summary, doc_index == 374) %>%
    # convert from long to wide, bringing content into columns
    tidyr::pivot_wider(names_from = cell_id, names_prefix = "col_", values_from = text, id_cols = row_id) %>%
    select(-row_id)

# lose indentation in first column, but migth be able to regain it through [padding](https://davidgohel.github.io/flextable/reference/padding.html)
