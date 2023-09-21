## xlsx2rmd.R

#' Convert an xlsx spreadsheet of questions into r/exams-style Rmd files.
#'
#' @param x Filepath to xlsx file.
#' @param output_dir Directory to write Rmd files to.
#' @param ... Additional arguments for openxlsx::loadWorkbook.
#'
#' @details # xlsx format
#' The xlsx file should have the following columns:
#'  - Question: the question text
#'  - Image: the image file
#'  - Ans1: the answer text for the first answer
#'  - Ans2: the answer text for the second answer
#'  - Ans3: the answer text for the third answer
#'  - Ans4: the answer text for the fourth answer
#'  - Ans5: the answer text for the fifth answer
#'  - Correct: the correct answer number (1-5)
#'  - Category: the category of the question
#'  - SubCat: the subcategory of the question
#'
#' @details
#' The image is imported from the xlsx file and saved in the 'img' directory
#' with the same name as the question's generated ID.
#'
#' @seealso [csv2rmd]
#'
#' @details # Credits
#' Brighton Pauli, 2022.
#'
#' @export

xlsx2rmd <- function(x, output_dir, ..., sheet = 1, log_file = NA, url = NA) {
    rexamsll::start_logs(log_file)
    logr::sep("Loading question data from .xlsx file.")

    ## load the xlsx file
    wb <- openxlsx::loadWorkbook(x, ...)

    ## --                                LOG                                --
    sprintf("Loaded data from '%s'.", x) %>%
        logr::put()

    sheet_names <- openxlsx::getSheetNames(x)
    sprintf("Found %d sheets in this file:", length(sheet_names)) %>%
        logr::put(blank_after = FALSE)
    for (sheet_name in sheet_names) {
        sprintf(" - %s", sheet_name) %>%
            logr::put(blank_after = FALSE)
    }
    ## --                                ---                                --

    ## if a string is supplied, check if it matches a sheet name
    if (is.character(sheet)) {
        if (!(sheet %in% sheet_names)) {
            stop("This sheet name was not found.")
        }
        sheet_name <- sheet
        sheet <- which(sheet_names == sheet)
    }

    ## if more than one style is detected, the user may have attempted to
    ## format text without using markdown-specific syntax.
    ## throw a warning
    if (length(wb$styleObjects) > 1) {
        warning(
            paste0(
                "Spreadsheet formatting cannot be read; use markdown-style ",
                "formatting instead."
            )
        )
    }

    ## grab the dataframe and validate it
    ## unfortunately, this means the dataframe is validated twice, which is
    ## inefficent time-wise. but negligibly so for normal use.
    df <- openxlsx::readWorkbook(x, sheet = sheet)
    df <- rexamsll:::validate_df(df)

    ## --                                LOG                                --
    sprintf("Loaded sheet %d, %s.", sheet, sheet_name) %>%
        logr::put()
    ## --                                ---                                --

    ## build ids for each question
    if (!("id" %in% colnames(df))) {
        df$id <- rexamsll::create_id(df$category, df$subcat)
    } else {
        # df$id <- sprintf("%s%s%s", df$category, df$subcat, df$id)
        df$id <- sprintf("%s%s", df$category, df$id)
    }

    ## add "sheet" metadata, and "url" if it's given
    if (!is.na(url)) df$url <- url
    df$sheet <- sheet_name

    df <- find_images_(df, wb, sheet, output_dir)

    ## save using df2rmd
    rexamsll::df2rmd(df, output_dir)
}

find_images_ <- function(df, wb, sheet, output_dir) {
    ## save all images from the xlsx file to the 'img' directory by iterating
    ## over all rows and saving images where the "Image" column is empty
    img_dir <- paste0(output_dir, "/img")
    if (!dir.exists(img_dir)) dir.create(img_dir)

    drawing_parent <- wb$drawings[[sheet]]
    drawings <- drawing_parent %>%
        str_extract_all("<xdr:oneCellAnchor>.*?</xdr:oneCellAnchor>", TRUE)

    ## --                                LOG                                --
    if (length(drawings) > 0) {
        sprintf("Found %d images.", length(drawings)) %>%
            logr::put(blank_after = FALSE)
    }
    ## --                                ---                                --

    ## Todo: use cols to ensure that this is in the Image column

    cols <- drawings %>%
        lapply(str_extract, "<xdr:col>(.*?)</xdr:col>", 1) %>%
        lapply(strtoi)
    valid_indices <- colnames(df)[unlist(cols) + 1] == "image"

    rows <- drawings %>%
        lapply(str_extract, "<xdr:row>(.*?)</xdr:row>", 1) %>%
        lapply(strtoi)
    names <- drawings %>%
        lapply(str_extract, "<xdr:cNvPr.*?name=\"(.*?)\"/>", 1)

    rows <- rows[valid_indices]
    names <- names[valid_indices]

    for (i in seq_len(length(drawings))) {
        media_path <- wb$media[[names[[i]]]]
        img_name <- sprintf("%s/%s", img_dir, names[[i]])
        file.copy(media_path, img_name)
        df$image[rows[[i]]] <- img_name

        ## --                            LOG                            --
        sprintf(" - %s <-- %s", df$id[i], img_name) %>%
            logr::put(blank_after = FALSE)
        if (rexamsll:::log_images) {
            for (line in str_split(img2txt(img_name), "\n")) {
                line %>%
                    sprintf(
                        "%-*s%s",
                        pmax((80 - nchar(.)) / 2, 0),
                        "",
                        .
                    ) %>%
                    logr::put(blank_after = FALSE)
            }
        }
        ## --                            ---                            --
    }

    df
}
