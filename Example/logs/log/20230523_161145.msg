Error in if (nrow(df) == 0) stop("Dataframe has no values. Did you select the
wrong sheet?") : argument is of length zero
Traceback:
5: rexamsll:::validate_df(df)
4: rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, log_file = log_file)
3: tryCatchList(expr, classes, parentenv, handlers)
2: tryCatch(rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, 
       log_file = log_file), finally = {
       unlink(xlsx_file)
       end_logs()
   })
1: google2rmd("https://docs.google.com/spreadsheets/d/1NCWf1bGPA5TzUtXjM4PmfT-lhJC2FF5cRHxtD5Rczk0/edit#gid=1715968873", 
       "Example", sheet = 2)

Warning message:
No data found on worksheet.

