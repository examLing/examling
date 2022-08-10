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
#' > bulleted_list(c("a", "b", "c"))
#' [1] "* a\n* b\n* c\n"


bulleted_list <- function(x) {
    ## if there are no answers, return an empty string
    if (length(x) == 0) return("")
    x %>%
        lapply(add_bullet) %>%
        paste0(collapse = "")
}

## create a single element of a bulleted list
add_bullet <- function(x) {
    if (is.na(x) || x == "") {
        return("")
    } else {
        return(sprintf("* %s\n", x))
    }
}