
#

library(RDCOMClient)

xlApp <- COMCreate("Excel.Application")
xlWbk <- xlApp$Workbooks()$Open("C:\\Users\\wb393438\\LSMS-general\\guidebook_formats\\prototype_lsms_ebooks\\insert_qnr\\EHCVM2_UEMOA_MEN1_20210215.xlsx") # STUDIO CRASHES HERE
xlScreen = 1
xlBitmap = 2

xlWbk$Worksheets("deletedFields")$Range("A1:L45")$CopyPicture(xlScreen, xlBitmap)

xlApp[['DisplayAlerts']] <- FALSE

oCht <- xlApp[['Charts']]$Add()
oCht$Paste()
oCht$Export("C:\\Users\\wb393438\\LSMS-general\\guidebook_formats\\prototype_lsms_ebooks\\insert_qnr\\Test.jpg", "JPG")
oCht$Delete()

# CLOSE WORKBOOK AND APP
xlWbk$Close(FALSE)
xlApp$Quit()

# RELEASE RESOURCES
oCht <- xlWbk <- xlApp <- NULL    
rm(oCht, xlWbk, xlApp)
gc()

# Write and execute Visual Basic Script

fileConn <- file("C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/insert_qnr/test.vbs")
writeLines(c("Dim xlApp, xlBook, xlSht",
    "Dim filename",
    "filename = \"C:\\Users\\wb393438\\LSMS-general\\guidebook_formats\\prototype_lsms_ebooks\\insert_qnr\\EHCVM2_UEMOA_MEN1_20210215.xlsx\"",
    "Set xlApp = CreateObject(\"Excel.Application\")",
    "xlApp.Visible = True",
    "set xlBook = xlApp.WorkBooks.Open(filename)",
    "set xlSht = xlApp.Worksheets(\"S01_Demo\")",
    "set rng = xlSht.Range(\"A1:L45\")",
    "rng.CopyPicture",
    "Set oCht = xlApp.Charts",
    "oCht.Add() ",
    "Set oCht = oCht(1)",
    "oCht.paste",
    "oCht.Export \"C:\\Users\\wb393438\\LSMS-general\\guidebook_formats\\prototype_lsms_ebooks\\insert_qnr\\Test.jpg\", \"JPG\""), 
    fileConn)

close(fileConn)

# blocked by WB policy
shell.exec("C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/insert_qnr/test.vbs")


# print PDF
# R crashes when try to open Excel file

library(RDCOMClient)
library(R.utils)

ex <- COMCreate("Excel.Application")  # create COM object
file <- "C:/Users/wb393438/LSMS-general/guidebook_formats/prototype_lsms_ebooks/insert_qnr/inputs/EHCVM2_UEMOA_MEN1_20210215.xlsx"
book <- ex$workbooks()$Open(file)     # open Excel file
sheet <- book$Worksheets()$Item(1)    # pointer to first worksheet
sheet$Select()                        # select first worksheet
ex[["ActiveSheet"]]$ExportAsFixedFormat(Type=0,    # export as PDF
                                        Filename="my.pdf", 
                                        IgnorePrintAreas=FALSE)
ex[["ActiveWorkbook"]]$Save()         # save workbook
ex$Quit()                             # close Excel