# load necessary libraries
library(pdftools)

# set folders
proj_dir <- "C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/insert_qnr/"
input_dir <- paste0(proj_dir, "inputs/")
output_dir <- paste0(proj_dir, "output/")

pdf1 <- "IHS5 Community Questionnaire FINAL.pdf"
pdf2 < "IHS5 Fishery Questionnaire FINAL.pdf"

pdftools::pdf_combine(
    input = c(
        paste0(input_dir, pdf1), 
        paste0(input_dir, pdf2)
    ), 
    output = paste0(output_dir, "test_combine.pdf")
)