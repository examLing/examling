## find_answer_columns.R

#' Find all answer columns in a dataframe.
#'
#' @param df Dataframe to search.
#' @returns Vector of column indices
#'
#' @details
#' An answer column is any column where the header starts with "ans" or "Ans".
#'
#' @details # Credits
#' Brighton Pauli, 2022.

find_answer_columns <- function(df) {
    answer_columns <- colnames(df) %>%
        grep("^(A|a)ns((wer(([^s].*$)|$))|([^w].*$)|$)", .) %>%
        unlist()

    if (length(answer_columns) == 0) {
        return(c())
    }

    ## if the columns are not consecutive, throw a warning
    range <- max(answer_columns) - min(answer_columns) + 1
    if (range != length(answer_columns)) {
        warning(
            sprintf(
                "Answer columns %s are not consecutive",
                paste0(colnames(df)[answer_columns], collapse = ", ")
            )
        )
    }

    answer_columns
}