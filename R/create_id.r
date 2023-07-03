## create_id.R

#' create an ID with format "[category][subcat][random number]"
#'
#' @param category The category of the question.
#' @param subcat The subcategory of the question (optional).
#' @returns A string of the form "[category][subcat][random number]".
#'
#' @details #Credits
#' Brighton Pauli, 2022.
#'
#' @export

create_id <- function(category, subcat = NA) {
    ## get random number
    random <- format(Sys.time(), "%Y%m%d%H%M%S")

    ## remove spaces
    category <- gsub(" ", "", category)
    if (is.na(subcat)) {
        subcat <- ""
    } else {
        subcat <- gsub(" ", "", subcat)
    }

    ## create ID
    id_string <- sprintf("%s%s%s", category, subcat, random)

    id_string
}