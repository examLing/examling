## get_metadata.R

#' Retrieve all r/exams-specific metadata from a question's .Rmd file.
#'
#' @param filename Name of the .Rmd file. Any extensions are ignored.
#' @param directory Optional. Folder this file can be found in.
#'
#' @return Tibble of metadata values, named appropriately, with `filename` and
#' `qvariation` columns.
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

    metadefault <- get_default_metadata_(text)
    metadefault$filename <- filename
    metadefault$qvariation <- 0

    metadata <- tibble()
    cut_text <- text

    for (i in seq_len(1000)) {
        match <- regexpr("(add(_string)?_question)|(add_from_pool)", cut_text)
        if (match == -1) break

        vari_text <- substring(cut_text, 1, match)
        cut_text <- substring(cut_text, match + attr(match, "match.length"))

        next_row <- metadefault %>%
            get_dynamic_metadata_(vari_text, i)

        too_long <- which(lapply(next_row, length) > 1)
        next_row[too_long] <- next_row[too_long] %>%
            lapply(paste0, collapse = "\n")

        metadata[which(!names(next_row) %in% names(metadata))] <- NA
        metadata <- rbind(metadata, next_row)
    }

    # if no dynamic variations are found, just use the default metadata
    if (nrow(metadata) == 0) {
        metadata <- metadefault %>%
            data.frame()
    }

    metadata <- relocate(metadata, "filename", "qvariation")

    metadata
}

get_default_metadata_ <- function(text) {
    metadata_title <- regexpr("Meta-information\r?\n=+", text)
    cut_text <- substring(text, metadata_title)

    metadefault <- list()

    for (i in seq_len(1000)) {
        match <- regexpr("exextra\\[[^\r\n]+\\]", cut_text)
        if (match == -1) break

        name <- substring(
            cut_text,
            match + 8,
            match + attr(match, "match.length") - 2
        )
        cut_text <- substring(cut_text, match + 8)

        val_match <- cut_text %>%
            substring(1, regexpr("\r?\n", cut_text)) %>%
            regexpr(": [^\r\n]+", .)

        value <- substring(
            cut_text,
            val_match + 2,
            val_match + attr(val_match, "match.length") - 1
        )

        metadefault[[name]] <- c(metadefault[[name]], value)
    }

    metadefault
}

get_dynamic_metadata_ <- function(metadefault, text, i) {
    match <- regexpr(r"(# VARIATION ?\d*)", text)
    if (match == -1) return(metadefault)

    res <- metadefault
    res$qvariation <- i
    cut_text <- substring(text, match)

    for (j in seq_len(1000)) {
        match <- regexpr("# [^\r\n]+: [^\r\n]+", cut_text)
        if (match[[1]] == -1) break

        data <- cut_text %>%
            substring(
                match + 2,
                match + attr(match, "match.length") - 1
            ) %>%
            strsplit(": ") %>%
            unlist()

        res[[data[[1]]]] <- data[[2]]
    }

    res
}