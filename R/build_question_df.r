## build_question_df.R

#' Build a question dataframe, with question, image, correct, incorrect, and 
#' explanation columns.
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

build_question_df <- function() {
    question_df <- matrix(ncol = 5, nrow = 0) %>%
        data.frame() %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    question_df
}
