## add_question.R

#' @title Add a question to a dataframe.
#'
#' @description Add a multiple-choice or single-choice question to a dataframe,
#'  validating and/or transforming inputs.
#'
#' @param question Question text
#' @param image Image filename (optional)
#' @param explanation Explanation for the correct answer (optional)
#' @param correct Vector of possible correct answers
#' @param incorrect Vector of possible incorrect answers
#' @param keywords Vector of strings to insert into the question text
#' @param df Dataframe to add question to
#'
#' @returns The provided dataframe `df`, with an additional row. If a dataframe
#' is not provided, a new one is created.
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

add_question <- function(question,
                         image = NA,
                         explanation = NA,
                         correct = NA,
                         incorrect = NA,
                         keywords = NA,
                         df = NA
) {
    ## if keywords are given, fill them into the question
    question <- substitute_keywords_(question, keywords)

    ## make correct and incorrect lists
    if (length(correct) == 0) {
        correct <- NA
    } else if (length(correct) > 1 | any(!is.na(correct))) {
        correct <- I(list(correct))
    }

    if (length(incorrect) == 0) {
        incorrect <- NA
    } else if (length(incorrect) > 1 | any(!is.na(incorrect))) {
        incorrect <- I(list(incorrect))
    }

    ## build dataframe
    df_new <- data.frame(
        question = question,
        image = image,
        correct = correct,
        incorrect = incorrect,
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

substitute_keywords_ <- function(s, keywords) {
    if (all(!is.na(keywords))) {
        for (i in rev(seq_along(keywords))) {
            s <- i %>%
                c("%", .) %>%
                paste0(collapse = "") %>%
                gsub(keywords[[i]], s)
        }
    }

    s
}
