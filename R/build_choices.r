## build_choices.R

#' @title Choose correct and incorrect answers.
#'
#' @description Choose correct and incorrect answers and format them for
#'  `r/exams` files.
#'
#' @param question_row Single row of data. See `build_question_df()`.
#' @param nchoices Total number of choices to give students.
#' @param ncorrect Number of choices that are correct (default: 1).
#'  0 <= `ncorrect` <= `nchoices`
#'
#' @returns Named list with two string values:
#'  1. `answerlist`: Bulleted list with all possible choices.
#'  2. `exsolution`: Binary representation of the correct answer(s).
#'
#' @seealso [build_question_df]
#'
#' @details # N Correct
#' By default, `ncorrect` is set to 1. A warning will be thrown if `ncorrect`
#' is greater than `nchoices`.
#'
#' To have a random number of correct answers, set `ncorrect` to `NA`,
#' `"random"`, or a vector of two numbers. `NA` and `random` will set
#' `ncorrect` to a random number between 1 and `ncorrect`, inclusively.
#' Providing a vector of two numbers will set `ncorrect` to a random number
#' between those two numbers, inclusively.
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @export

build_choices <- function(question_row, nchoices, ncorrect = 1) {
    ## find the total number of choices supplied
    total_choices <- length(unlist(question_row$correct))
    total_choices <- total_choices + length(unlist(question_row$incorrect))

    ## if nchoices is greater than |correct| + |incorrect|, fix and warn
    if (nchoices > total_choices) {
        warning(
            paste("Provided number of choices", nchoices,
                "greater than total number of choices", total_choices
            )
        )
        nchoices <- total_choices
        ncorrect <- length(unlist(question_row$correct))
    }

    ## if ncorrect is NA or "random", set it to a random number
    if (length(ncorrect) == 2) {
        if (ncorrect[[2]] < ncorrect[[1]]) ncorrect <- rev(ncorrect)
        if (ncorrect[[1]] > nchoices) ncorrect[[1]] <- nchoices
        if (ncorrect[[2]] > nchoices) {
            warning(
                paste("Upper bound on number of correct answers",
                    ncorrect[[2]], "greater than number of choices", nchoices
                )
            )
            ncorrect[[2]] <- nchoices
        }

        ncorrect <- sample(seq(from = ncorrect[[1]], to = ncorrect[[2]]), 1)
    } else if (length(ncorrect) != 1) {
        stop("Invalid length for ncorrect: expected vector of length 1 or 2")
    } else if (is.na(ncorrect) | ncorrect == "random") {
        ncorrect <- question_row$correct %>%
            unlist() %>%
            length() %>%
            min(nchoices) %>%
            seq_len() %>%
            sample(1)
    }

    ## if ncorrect is greater than the number of correct choices, fix and warn
    if (ncorrect > length(unlist(question_row$correct))) {
        warning(
            paste("Expected number of correct choices", ncorrect,
                "greater than actual amount of correct choices",
                length(unlist(question_row$correct))
            )
        )
        ncorrect <- length(unlist(question_row$correct))
    }

    ## if ncorrect is too SMALL, then there won't be enough incorrect choices.
    ## fix and warn
    if (nchoices - ncorrect > length(unlist(question_row$incorrect))) {
        warning(
            paste(length(unlist(question_row$incorrect)),
                "incorrect answers not enough for question with", nchoices,
                "choices and", ncorrect, "correct answers."
            )
        )
        ncorrect <- nchoices - length(unlist(question_row$correct))
    }

    ## if ncorrect is greater than nchoices, fix and warn
    if (ncorrect > nchoices) {
        warning(
            paste("Provided number of correct choices", ncorrect,
                "greater than total number of choices", nchoices
            )
        )
        ncorrect <- nchoices
    }

    ## sample correct and incorrect answers from question
    correct <- sample(unlist(question_row$correct), size = ncorrect)
    incorrect <- sample(
        unlist(question_row$incorrect),
        size = nchoices - ncorrect
    )

    ## created bulleted list from both samples
    answerlist <- examling::bulleted_list(c(correct, incorrect))

    ## create binary representation
    exsolution <- paste0(
        c(rep(1, ncorrect), rep(0, nchoices - ncorrect)),
        collapse = ""
    )

    ## return named list
    res <- list(answerlist = answerlist, exsolution = exsolution)

    res
}
