## add_question.r

#' Add a question to a dataframe, validating and/or transforming inputs.
#'
#' @param question Question text.
#' @param image Image filename (optional).
#' @param explanation Explanation for the correct answer (optional).
#' @param correct Vector of possible correct answers.
#' @param incorrect Vector of possible incorrect answers.
#' @param df Dataframe to add question to.
#'
#' If you use the first pair, "correct" and "incorrect" vectors will be
#' generated automatically from the choices using the given indices.
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

add_question <- function(question, image = NA, explanation = NA, correct = NA,
    incorrect = NA, df = NA) {
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
