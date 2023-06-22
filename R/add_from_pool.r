## add_from_pool.R

#' Add a question to a dataframe from a pool of answers.
#'
#' @param question Question text.
#' @param image Image filename (optional).
#' @param explanation Explanation for the correct answer (optional).
#' @param answer_pool Tibble of answer choices, with id and text columns.
#' @param correct_ids Numeric vector of correct answer ids, as in answer_pool.
#' @param df Dataframe to add question to.
#'
#' If a dataframe is not provided, a new one is created.
#'
#' @details #Credits
#' Brighton Pauli, 2022.
#'
#' @export

add_from_pool <- function(question,
                          image = NA,
                          explanation = NA,
                          answer_pool = NA,
                          correct_ids = NA,
                          keywords = NA,
                          df = NA
) {
    ## generate correct and incorrect
    indices <- answer_pool$id %in% correct_ids
    correct <- answer_pool$text[indices]
    incorrect <- answer_pool$text[!indices]

    ## wrap around the other add_question function
    rexamsll::add_question(
        question,
        image = image,
        explanation = explanation,
        correct = correct,
        incorrect = incorrect,
        keywords = keywords,
        df = df
    )
}