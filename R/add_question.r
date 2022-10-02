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
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

add_question <- function(question, image = NA, explanation = NA, correct = NA,
    incorrect = NA, keywords = NA, df = NA) {
    ## if keywords are given, fill them into the question
    if (!is.na(keywords)) {
        for (i in seq_along(keywords)) {
            question <- question %>%
                gsub(paste0(c("%", i), collapse = ""), keywords[[i]], .)
        }
    }

    ## build dataframe
    ndf <- data.frame(question = question, image = image,
        correct = I(list(correct)), incorrect = I(list(incorrect)),
        explanation = explanation)

    ## if no dataframe is provided, create a new one
    if (is.null(nrow(df))) {
        df <- ndf
    } else {
        df <- rbind(df, ndf)
    }

    ## return dataframe
    df
}
