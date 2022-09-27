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
#' @seealso [csv2rmd]
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

xlsx2rmd <- function(x, output_dir, ..., sheet = 1) {

    ## load the xlsx file
    wb <- openxlsx::loadWorkbook(x, ...)

    ## grab the dataframe and validate it
    ## unfortunately, this means the dataframe is validated twice, which is
    ## inefficent time-wise. but negligibly so for normal use.
    df <- openxlsx::readWorkbook(wb, sheet = sheet)
    df <- rexamsll:::validate_df(df)

    ## make column names lowercase
    names(df) <- tolower(names(df))

    ## build ids for each question
    if (!("id" %in% colnames(df))) {
        df$id <- rexamsll::create_id(df$category, df$subcat)
    } else {
        df$id <- sprintf("%s%s%s", df$category, df$subcat, df$id)
    }

    browser()

    ## save all images from the xlsx file to the 'img' directory by iterating
    ## over all rows and saving images where the "Image" column is empty
    img_dir <- paste0(output_dir, "/img")
    if (!dir.exists(img_dir)) dir.create(img_dir)
    img_id <- 0
    num_images <- length(wb@.xData$media)
    for (i in seq_len(nrow(df))) {
        # df$id[i] <- rexamsll::create_id(df$category[i], df$subcat[i])
        if (is.na(df$image[i]) && img_id < num_images) {
            img_id <- img_id + 1
            img_name <- sprintf("%s/%s.png", img_dir, df$id[i])
            file.copy(wb@.xData$media[img_id], img_name)
            df$image[i] <- img_name
        } else if (is.na(df$image[i])) {
            df$image[i] <- "0"
        }
    }

    ## save using df2rmd
    rexamsll::df2rmd(df, output_dir)
}
