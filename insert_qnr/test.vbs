Dim xlApp, xlBook, xlSht
Dim filename
filename = "C:\Users\wb393438\LSMS-general\guidebook_formats\prototype_lsms_ebooks\insert_qnr\EHCVM2_UEMOA_MEN1_20210215.xlsx"
Set xlApp = CreateObject("Excel.Application")
xlApp.Visible = True
set xlBook = xlApp.WorkBooks.Open(filename)
set xlSht = xlApp.Worksheets("S01_Demo")
set rng = xlSht.Range("A1:L45")
rng.CopyPicture
Set oCht = xlApp.Charts
oCht.Add() 
Set oCht = oCht(1)
oCht.paste
oCht.Export "C:\Users\wb393438\LSMS-general\guidebook_formats\prototype_lsms_ebooks\insert_qnr\Test.jpg", "JPG"
