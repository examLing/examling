## create_id.r

#' create an ID with format "[category][subcat][random number]"
#'
#' @param category The category of the question.
#' @param subcat The subcategory of the question.
#' @returns A string of the form "[category][subcat][random number]".
#'
#' @details #Credits
#' Brighton Pauli, 2022.
#'
#' @export

create_id <- function(category, subcat) {
    ## get random number
    random <- as.character(sample(1:10000000, 1))
    ## create ID
    sprintf("%s%s%s", category, subcat, random)
}