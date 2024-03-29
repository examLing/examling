## csv2rmd.R

#' @title Import questions from a csv file.
#'
#' @description Convert a csv file of questions into r/exams-style Rmd files.
#'
#' @param x Filepath to csv file.
#' @param output_dir Directory to write Rmd files to.
#' @param ... Additional arguments for `read.csv`.
#'
#' @details # csv format
#' The csv file should have the following columns:
#' - Question: the question text
#' - Type: "schoice", "mchoice", or "string"
#' - Image: the image file's name
#' - Ans1: the answer text for the first answer
#' - Ans2: the answer text for the second answer
#' - Ans3: the answer text for the third answer
#' - Ans4: the answer text for the fourth answer
#' - Ans5: the answer text for the fifth answer
#' - Correct: the correct answer number (1-5)
#' - Category: the category of the question
#' - SubCat: the subcategory of the question
#'
#' @seealso [xlsx2rmd]
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

csv2rmd <- function(x, output_dir, ...) {
    ## read CSV data base
    question_df <- read.csv(x, colClasses = "character", ...)

    ## make column names lowercase
    names(question_df) <- tolower(names(question_df))

    ## build ids for each question
    if (!("id" %in% colnames(question_df))) {
        question_df$id <- examling::create_id(
            question_df$category,
            question_df$subcat
        )
    } else {
        question_df$id <- sprintf(
            "%s%s%s",
            question_df$category,
            question_df$subcat,
            question_df$id
        )
    }

    ## save using df2rmd
    examling::df2rmd(question_df, output_dir)
}