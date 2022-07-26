## xlsx2rmd.R

#' Convert an xlsx spreadsheet of questions into r/exams-style Rmd files.
#'
#' @param x Filepath to xlsx file.
#' @param output_dir Directory to write Rmd files to.
#' @param ... Additional arguments for openxlsx::loadWorkbook.
#'
#' @details # xlsx format
#' The xlsx file should have the following columns:
#'  - Question: the question text
#'  - Image: the image file
#'  - Ans1: the answer text for the first answer
#'  - Ans2: the answer text for the second answer
#'  - Ans3: the answer text for the third answer
#'  - Ans4: the answer text for the fourth answer
#'  - Ans5: the answer text for the fifth answer
#'  - Correct: the correct answer number (1-5)
#'  - Category: the category of the question
#'  - SubCat: the subcategory of the question
#'
#' @details
#' The image is imported from the xlsx file and saved in the 'img' directory
#' with the same name as the question's generated ID.
#'
#' Inspired by Achim's csv2rmd function.
#' Brighton Pauli, 2022.

xlsx2rmd <- function(x, output_dir, ...) {
    ## Rmd exercise template
    rmd <- "
Question
========

%s
%s

Answerlist
----------

%s

Meta-information
================
exname: %s
extype: schoice
exsolution: %s
exsection: %s/%s
exshuffle: TRUE
"

    ## TODO: This code is copied from csv2rmd.r. Refactor to create a common
    ## df2rmd function.
    ## create an ID with format "[category][subcat][random number]"
    create_id <- function(category, subcat) {
        ## get random number
        random <- as.character(sample(1:10000000, 1))
        ## create ID
        sprintf("%s%s%s", category, subcat, random)
    }

    ## add a section to import an image, if there is one
    include_image <- function(x) {
        if (x == "0") return("")
        rmd <- '```{r, echo = FALSE, results = "hide"}
    include_supplement("%s")
    ```
    \\
    ![](%s)'
        sprintf(rmd, x, x)
    }

    correct2schoice <- function(x) {
        x <- as.numeric(gsub("Ans", "", x))
        paste(append(rep(0, 4), 1, after = x - 1), collapse = "")
    }

    ## create a single element of a bulleted list
    addbullet <- function(x) {
        if (is.na(x) || x == "") {
        return("")
        } else {
        return(sprintf("* %s\n", x))
        }
    }

    ## concatenate bullets of a list
    ## df should be set up so that each row is a separate list and columns
    ## make up the list elements.
    ## empty elements are ignored.
    bulletedlist <- function(df) {
        apply(df, c(1, 2), addbullet) %>%
        apply(1, paste, collapse = "")
    }

    ## load the xlsx file
    wb <- openxlsx::loadWorkbook(x, ...)

    ## save all images from the xlsx file to the 'img' directory by iterating
    ## over all rows and saving images where the "Image" column is empty
    img_id <- 0
    df <- openxlsx::readWorkbook(wb)
    for (i in 1:nrow(df)) {
        df$ID[i] <- create_id(df$Category[i], df$SubCat[i])
        if (is.na(df$Image[i])) {
            img_id <- img_id + 1
            img_name <- sprintf("img/%s.png", df$ID[i])
            file.copy(wb@.xData$media[img_id], img_name)
            df$Image[i] <- img_name
        }
    }

    ## insert data base into template
    rmd <- sprintf(rmd,
        df$Question,
        sapply(df$Image, include_image),
        bulletedlist(df[c("Ans1", "Ans2", "Ans3", "Ans4", "Ans5")]),
        df$ID,
        # apply(df[c("Category", "SubCat")], 1, create_id),
        sapply(df$Correct, correct2schoice),
        df$Category, df$SubCat)


    ## write Rmd files
    for (i in 1L:nrow(df)) writeLines(rmd[i], paste0(df$ID[i], ".Rmd"))
    invisible(rmd)
}
