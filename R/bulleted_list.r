## bulleted_list.R

#' @title Form a bulleted list from strings.
#'
#' @description Concatenate string items to form a bulleted list.
#'
#' @param x vector of strings
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @examples
#' bulleted_list(c("a", "b", "c"))
#'
#' @export


bulleted_list <- function(x) {
    if (is.list(x)) {
        x <- unlist(x)
    }

    ## if there are no answers, return an empty string
    if (length(x) == 0) return("")

    res_string <- x %>%
        lapply(add_bullet_) %>%
        paste0(collapse = "")
    res_string
}

## create a single element of a bulleted list
add_bullet_ <- function(x) {
    ## if there is no text, return an empty string
    if (is.na(x) || x == "") return("")

    res_string <- sprintf("* %s\n", x)
    res_string
}