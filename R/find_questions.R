## find_questions.R

#' Locate all exercise files that match the metadata filters.
#'
#' @param dir Directory containing exercise .Rmd files to search through.
#' @param pattern Optional regular expression to filter file names
#' @param ... Expressions that return a logical value. See `filter`.
#'
#' @return Dataframe with columns `filename` and `qvariation`.
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @export

find_questions <- function(dir, ..., pattern = ".*") {
    res <- data.frame()

    filenames <- list.files(dir, pattern)
    for (file in filenames) {
        ex <- rexamsll::get_metadata(file, dir)

        if (nrow(res) > 0) {
            res[names(ex)[!names(ex) %in% names(res)]] <- NA
            ex[names(res)[!names(res) %in% names(ex)]] <- NA
        }

        res <- ex %>%
            relocate(names(res)) %>%
            rbind(res, .)
    }

    res <- filter(res, ...)

    res
}