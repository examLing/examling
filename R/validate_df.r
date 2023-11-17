## validate_df.R

#' @title Check a dataframe for issues.
#'
#' @description Ensure that a dataframe conforms to rexamsll standards,
#'  stopping otherwise.
#'
#' @param df Dataframe to validate.
#'
#' @details # Requirements
#'
#' The dataframe must have the following columns:
#' - Question
#' - Type
#' - Correct
#' - Category
#'
#' Previously, the Image column was also required. Now, if there is no Image
#' column, an empty one is added.
#'
#' All columns must be plain text.
#'
#' There must be at least one answer column.
#'
#' For common errors, see the following vignette:
#'
#' \code{vignette("spreadsheet-validation", package = "rexamsll")}
#'
#' @details # Credits
#' Brighton Pauli, 2022.

validate_df <- function(df) {
    ## ensure that the dataframe has at least one row
    if (nrow(df) == 0) {
        stop("Dataframe has no values. Did you select the wrong sheet?")
    }

    ## set column names to lowercase
    names(df) <- tolower(names(df))

    ## if there is no Image column, add one
    if (!("image" %in% colnames(df))) {
        df$image <- ""
    }

    ## if there is no Explanation column, add one
    if (!("explanation" %in% colnames(df))) {
        df$explanation <- ""
    }

    ## if there are any absent Subcats (or no Subcat column at all), use
    ## empty strings
    if (!("subcat" %in% colnames(df))) {
        df$subcat <- ""
    }
    df$subcat[is.na(df$subcat)] <- ""

    ## check that all required columns are present
    req_cols <- rexamsll:::req_cols
    if (!all(req_cols %in% colnames(df))) {
        stop(
            sprintf("Missing column(s): %s",
            paste0(req_cols[!req_cols %in% colnames(df)], collapse = ", "))
        )
    }

    ## check for any decimal points in the "Correct" column, indicating they
    ## are not plain text
    if (any(grepl("\\.", df$correct) & (df$type != "string"))) {
        stop("The Correct column must be plain text")
    }

    ## check for any code blocks in the "Question" column
    code_block_issue <- grepl("```", df$question)
    df[code_block_issue, ]$issue <- df[code_block_issue, ]$issue %>%
        sapply(collate_issues_, "Code block in string.")

    ## check that there is at least one answer column
    ans_cols <- rexamsll:::find_answer_columns(df)
    if (length(ans_cols) == 0) {
        stop("No answer columns found")
    }

    ## reformat category and subcat columns
    df$category <- gsub(" ", "", df$category)
    df$subcat <- gsub(" ", "", df$subcat)

    ## if any rows have duplicated ids (meaning they're dynamic variations),
    ## fill in the missing information
    df <- repeat_duplicates_(df)

    ## if there are any values in an answer column for a row with type
    ## "string", throw a warning
    na_rows <- apply(df, 1, function(x) all(is.na(x[ans_cols])))
    sr_rows <- df$type == "string"
    if (any(!na_rows & sr_rows)) {
        msg <- "'string' rows %s have values in answer columns"
        if (length(which(!na_rows & sr_rows)) == 1) {
            msg <- "'string' row %s has values in answer columns"
        }

        msg <- paste0(msg, "\n These values will be ignored.")

        which(!na_rows & sr_rows) %>%
            paste0(collapse = ", ") %>%
            sprintf(msg, .) %>%
            warning()

        df[df$type == "string", ans_cols] <- NA
    }

    ## if there aren't any values in an answer column for a row with type
    ## other than "string", throw an error
    if (any(na_rows & !sr_rows)) {
        msg <- "Rows %s have no values in answer columns"
        if (length(which(na_rows & !sr_rows)) == 1) {
            msg <- "Row %s has no values in answer columns"
        }

        which(na_rows & !sr_rows) %>%
            paste0(collapse = ", ") %>%
            sprintf(msg, .) %>%
            stop()
    }

    df
}

repeat_duplicates_ <- function(df) {
    is_instructions <- FALSE
    if ("part" %in% colnames(df)) {
        is_instructions <- !is.na(df$part) & df$part == 0
    }

    for (row in seq_len(nrow(df))) {
        if (df$id[row] %in% df$id[1:row - 1]) {
            parent <- which(df$id == df$id[row] & !is_instructions)[[1]]
            isna <- is.na(df[row, ])
            df[row, isna] <- df[parent, isna]
        }
    }

    df
}

collate_issues_ <- function(s, issue) {
    if (is.na(s) || s == "") {
        res <- issue
    } else {
        old_issues <- strsplit(s, "\n")[[1]]
        new_issues <- strsplit(issue, "\n")[[1]]
        res <- c(old_issues, new_issues) %>%
            unique() %>%
            paste0(collapse = "\n")
    }

    res
}