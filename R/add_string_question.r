## add_string_question.r

#' Add a string-type question to a dataframe compatible with schoice, etc.
#'
#' @param question Question text.
#' @param image Image filename (optional)
#' @param explanation Explanation for the correct answer (optional).
#' @param correct Correct answer, string.
#' @param keywords Vector of strings to insert into the question text.
#' @param df Dataframe to add question to.
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @seealso Wrapper for `add_question()`.
#'
#' @export

add_string_question <- function(question,
                                image = NA,
                                explanation = NA,
                                correct = NA,
                                keywords = NA,
                                df = NA) {
    df_res <- rexamsll::add_question(
        question,
        image,
        explanation,
        correct,
        c(),
        keywords,
        df
    )

    df_res
}