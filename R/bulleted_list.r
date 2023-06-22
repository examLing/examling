## bulleted_list.r

#' Concatenate string items to form a bulleted list.
#'
#' @param x list of strings
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export
#'
#' @examples
#' bulleted_list(c("a", "b", "c"))


bulleted_list <- function(x) {
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