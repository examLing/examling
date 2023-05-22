## validate_df.r

#' Ensure that a dataframe conforms to rexamsll standards, stopping otherwise.
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
#' - SubCat
#'
#' Previously, the Image column was also required. Now, if there is no Image
#' column, one is added consisting only of "0" values.
#'
#' All columns must be plain text.
#'
#' There must be at least one answer column.
#'
#' @details # Credits
#' Brighton Pauli, 2022.

validate_df <- function(df) {
    ## ensure that the dataframe has at least one row
    if (nrow(df) == 0) stop(
        "Dataframe has no values. Did you select the wrong sheet?"
    )

    ## set column names to lowercase
    names(df) <- tolower(names(df))

    ## if there is no Image column, add one
    if (!("image" %in% colnames(df))) {
        df$image <- "0"
    }

    ## check that all required columns are present
    req_cols <- rexamsll:::req_cols
    if (!all(req_cols %in% colnames(df))) {
        stop(sprintf("Missing columns: %s",
            paste0(req_cols[!req_cols %in% colnames(df)], collapse = ", ")))
    }

    ## check for any decimal points in the "Correct" column, indicating they
    ## are not plain text
    if (any(grepl("\\.", df$correct) & (df$type != "string"))) {
        stop("The Correct column must be plain text.")
    }

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
    df <- repeat_duplicates(df)

    ## if there are any values in an answer column for a row with type
    ## "string", throw a warning
    na_rows <- apply(df, 1, function(x) all(is.na(x[ans_cols])))
    sr_rows <- df$type == "string"
    if (any(!na_rows & sr_rows)) {
        msg <- "'string' rows %s have values in answer columns."
        if (length(which(!na_rows & sr_rows)) == 1) {
            msg <- "'string' row %s has values in answer columns."
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
        msg <- "Rows %s have no values in answer columns."
        if (length(which(na_rows & !sr_rows)) == 1) {
            msg <- "Row %s has no values in answer columns."
        }

        which(na_rows & !sr_rows) %>%
            paste0(collapse = ", ") %>%
            sprintf(msg, .) %>%
            stop()
    }

    df
}

repeat_duplicates <- function(df) {
    for (row in seq_len(nrow(df))) {
        if (df$id[row] %in% df$id[1:row - 1]) {
            parent <- which(df$id == df$id[row])[[1]]
            isna <- is.na(df[row, ])
            df[row, isna] <- df[parent, isna]
        }
    }

    df
}