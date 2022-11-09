## google2rmd.R

#' Download a Google Sheet of questions and convert it to Rmd files.
#'
#' @param url URL to the Google Sheet.
#' @param output_dir Directory to write Rmd files to.
#'
#' @details # sheet format
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
#' The image is imported from the Sheet and saved in the 'img' directory
#' with the same name as the question's generated ID.
#'
#' @seealso [xlsx2rmd]
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

google2rmd <- function(url, output_dir, sheet = 1) {
    xlsx_file <- paste0(output_dir, "/temp.xlsx")

    # if this directory does not exist already, create it
    if (!file.exists(output_dir)) {
        dir.create(output_dir, recursive = TRUE)
    }

    while (file.exists(xlsx_file)) {
        xlsx_file <- paste0(output_dir, "/temp_",
            as.character(sample(1:10000000, 1)), ".xlsx")
    }

    googledrive::drive_download(
        googledrive::as_id(url),
        xlsx_file,
        type = "xlsx"
    )

    tryCatch(
        rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet),
        finally = {
            unlink(xlsx_file)
        }
    )
}