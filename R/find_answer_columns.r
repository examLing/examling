## find_answer_columns.r

#' Find all answer columns in a dataframe.
#'
#' @param df Dataframe to search.
#'
#' @details
#' An answer column is any column where the header starts with "ans" or "Ans".
#'
#' @details # Credits
#' Brighton Pauli, 2022.

find_answer_columns <- function(df) {
    colnames(df) %>%
        grep("^(A|a)ns", .) %>%
        unlist
}