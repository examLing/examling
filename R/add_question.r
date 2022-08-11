## add_question.r

#' Add a question to a dataframe, validating and/or transforming inputs.
#'
#' @param question Question text.
#' @param image Image filename (optional).
#' @param correct_ids Numeric vector of correct answer indices.
#' @param choices Tibble of answer choices, with id and text columns.
#' @param correct Vector of possible correct answers.
#' @param incorrect Vector of possible incorrect answers.
#' @param df Dataframe to add question to.
#'
#' If a dataframe is not provided, a new one is created.
#'
#' ONLY correct_ids+choices OR correct+incorrect should be provided.
#'
#' If you use the first pair, "correct" and "incorrect" vectors will be
#' generated automatically from the choices using the given indices.
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

add_question <- function(question, image = NA, explanation = NA,
    correct_ids = NA, choices = NA, correct = NA, incorrect = NA, df = NA) {
    ## correct_ids+choices OR correct+incorrect must be given, but not both
    if (is.na(correct_ids) != is.na(choices)) {
        stop("correct_ids and choices must be given together")
    }
    if (is.na(correct) != is.na(incorrect)) {
        stop("correct and incorrect must be given together")
    }
    if (is.na(correct_ids) == is.na(correct)) {
        stop("either correct_ids or correct must be used, but not both")
    }

    ## if correct_ids and choices are given, generate correct and incorrect
    if (!is.na(correct_ids) && !is.na(choices)) {
        indices <- choices$id %in% correct_ids
        correct <- choices$text[indices]
        incorrect <- choices$text[!indices]
    }

    ## build dataframe
    ndf <- data.frame(question = question, image = image,
        correct = I(list(correct)), incorrect = I(list(incorrect)),
        explanation = explanation)

    ## if no dataframe is provided, create a new one
    if (is.na(df)) {
        df <- ndf
    } else {
        df <- rbind(df, ndf)
    }

    ## return dataframe
    df
}
