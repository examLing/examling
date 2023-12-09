## add_string_question.R

#' @title Add a string question to a dataframe.
#'
#' @description Add a string-type question to a dataframe, validating and/or
#'  transforming inputs.
#'
#' @param question Question text
#' @param image Image filename (optional)
#' @param explanation Explanation for the correct answer (optional)
#' @param correct Correct answer, string
#' @param keywords Vector of strings to insert into the question text
#' @param df Dataframe to add question to
#'
#' @returns The provided dataframe `df`, with an additional row. If a dataframe
#' is not provided, a new one is created.
#'
#' @seealso `add_question()`
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @export

add_string_question <- function(question,
                                image = NA,
                                explanation = NA,
                                correct = NA,
                                keywords = NA,
                                df = NA
) {
    ## if keywords are given, fill them into the question
    question <- examling:::substitute_keywords_(question, keywords)

    ## build dataframe
    df_new <- data.frame(
        question = question,
        image = image,
        correct = correct,
        incorrect = NA,
        explanation = explanation
    )

    ## if no dataframe is provided, create a new one
    if (is.null(nrow(df))) {
        df <- df_new
    } else {
        df <- rbind(df, df_new)
    }

    df
}