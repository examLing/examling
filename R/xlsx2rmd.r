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

xlsx2rmd <- function(x, output_dir, ..., sheet = 1, log_file = NA) {

    start_logs(log_file)
    logr::sep("Loading question data from .xlsx file.")

    ## load the xlsx file
    wb <- openxlsx::loadWorkbook(x, ...)

    ## --                                LOG                                --
    sprintf("Loaded data from '%s'.", x) %>%
        logr::put()

    sheet_names <- openxlsx::getSheetNames(x)
    sprintf("Found %d sheets in this file:", length(sheet_names)) %>%
        logr::put(blank_after = FALSE)
    for (sheet_name in sheet_names) {
        sprintf(" - %s", sheet_name) %>%
            logr::put(blank_after = FALSE)
    }
    ## --                                ---                                --

    ## grab the dataframe and validate it
    ## unfortunately, this means the dataframe is validated twice, which is
    ## inefficent time-wise. but negligibly so for normal use.
    df <- openxlsx::readWorkbook(wb, sheet = sheet)
    df <- rexamsll:::validate_df(df)

    ## --                                LOG                                --
    sprintf("Loaded sheet %d, %s.", sheet, sheet_names[[sheet]]) %>%
        logr::put()
    ## --                                ---                                --

    ## build ids for each question
    if (!("id" %in% colnames(df))) {
        df$id <- rexamsll::create_id(df$category, df$subcat)
    } else {
        df$id <- sprintf("%s%s%s", df$category, df$subcat, df$id)
    }

    ## save all images from the xlsx file to the 'img' directory by iterating
    ## over all rows and saving images where the "Image" column is empty
    img_dir <- paste0(output_dir, "/img")
    if (!dir.exists(img_dir)) dir.create(img_dir)
    img_id <- 0
    num_images <- length(wb@.xData$media)

    ## --                                LOG                                --
    if (num_images > 0) {
        sprintf("Found %d images.", num_images) %>%
            logr::put(blank_after = FALSE)
    }
    ## --                                ---                                --

    for (i in seq_len(nrow(df))) {

        if (is.na(df$image[i]) && img_id < num_images) {
            img_id <- img_id + 1
            img_name <- sprintf("%s/%s.png", img_dir, df$id[i])
            file.copy(wb@.xData$media[img_id], img_name)
            df$image[i] <- img_name

            ## --                            LOG                            --
            sprintf(" - %s <-- %s", df$id[i], img_name) %>%
                logr::put(blank_after = FALSE)
            if (rexamsll:::log_images) {
                for (line in str_split(img2txt(img_name), "\n")) {
                    line %>%
                        sprintf(
                            "%-*s%s",
                            pmax((80 - nchar(.)) / 2, 0),
                            "", .) %>%
                        logr::put(blank_after = FALSE)
                }
            }
            ## --                            ---                            --
        }

        else if (is.na(df$image[i])) {
            df$image[i] <- "0"

            ## --                            LOG                            --
            sprintf(" ! No image found for %s.", df$id[i]) %>%
                logr::put(blank_after = FALSE)
            ## --                            ---                            --
        }
    }

    ## --                                LOG                                --
    if (img_id < num_images) {
        sprintf("%d image(s) not used.", num_images - img_id) %>%
            logr::put()
    }
    ## --                                ---                                --

    ## save using df2rmd
    rexamsll::df2rmd(df, output_dir)
}
