## get_metadata.R

#' Retrieve all r/exams-specific metadata from a question's .Rmd file.
#'
#' @param filename Name of the .Rmd file. Any extensions are ignored.
#' @param directory Optional. Folder this file can be found in.
#'
#' @return List of metadata values, named appropriately.
#'
#' @details
#' If `filename` is left blank, a file explorer window is opened.
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @export

get_metadata <- function(filename = "", directory = "") {
    if (filename == "") {
        filename <- file.choose()
        directory <- ""
    }

    if (directory != "") {
        filename <- paste0(c(directory, filename), collapse = "/")
    }

    filename <- gsub("(\\.[^.]*)?$", ".Rmd", filename)

    text <- read_file(filename)
    metadata_title <- regexpr("Meta-information\r?\n=+", text)
    text <- substring(text, metadata_title)

    metadata <- list()

    for (i in seq_len(1000)) {
        match <- regexpr("exextra\\[[^\r\n]+\\]", text)
        if (match == -1) break

        name <- substring(
            text,
            match + 8,
            match + attr(match, "match.length") - 2
        )
        text <- substring(text, match + 8)

        val_match <- text %>%
            substring(1, regexpr("\r?\n", text)) %>%
            regexpr(": [^\r\n]+", .)

        value <- substring(
            text,
            val_match + 2,
            val_match + attr(val_match, "match.length") - 1
        )

        metadata[name] <- value
    }

    metadata
}