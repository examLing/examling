## df2rmd.R

#' Convert a dataframe of questions into r/exams-style Rmd files.
#'
#' @param df Dataframe of questions.
#' @param output_dir Directory to write Rmd files to.
#'
#' @details # Credits
#' Inspired by Achim's csv2rmd function.
#' Brighton Pauli, 2022.
#'
#' @export

df2rmd <- function(df, output_dir) {
    df <- rexamsll:::validate_df(df)

    # if this directory does not exist already, create it
    if (!file.exists(output_dir)) {
        dir.create(output_dir, recursive = TRUE)
    }

    ## find answer columns
    ans_cols <- rexamsll:::find_answer_columns(df)
    df$answers <- df[ans_cols] %>%
        apply(1, as.list) %>%
        lapply(function(x) x[!is.na(x)])

    ## reformat image, answer, and correct columns
    df$imagemd <- sapply(df$image, include_image_)
    df$correct <- apply(df, 1, correct2choices_)
    
    df <- build_dynamic_(df, ans_cols)

    df$answers[!df$is_dynamic] <- lapply(
        df$answers[!df$is_dynamic],
        rexamsll::bulleted_list
    )
    df$answers[df$type == "string"] <- ""

    ## grab the correct template for each question
    rmd <- df$type %>%
        lapply(function(x) rexamsll:::templates[[x]]) %>%
        unlist()

    ## create an "exsection" metadata parameter based on the cat and subcat
    exsection <- sprintf("%s/%s", df$category, df$subcat)
    exsection[df$subcat == ""] <- df$category[df$subcat == ""]

    ## add the "Solution" header
    df$explanation <- sapply(df$explanation, include_explanation_)

    ## insert data base into template
    rmd <- sprintf(
        rmd,
        df$question,
        df$imagemd,
        df$answers,
        df$explanation,
        df$id,
        df$correct,
        exsection
    )

    ## add yaml headers to the top, and metadata footers to the bottom
    # rmd <- paste0(metadata_yaml_(df), df$rcode, rmd)
    rmd <- paste0(
        sprintf(rexamsll:::yaml_header, df$id, ""),
        df$rcode,
        rmd,
        metadata_footer_(df)
    )

    ## write Rmd files
    for (i in seq_len(nrow(df))) {
        writeLines(rmd[i], paste0(output_dir, "/", df$id[i], ".Rmd"))
    }
    invisible(rmd)
}

## DYNAMIC QUESTIONS
## ===========================================================

#' Fix strings for use in dynamic R code chunks
#' 
#' @param s String to be reformatted
#' @returns String that can be used in a R code

reformat_string_ <- function(s) {
    reformatted <- s %>%
        gsub("\\", "\\\\", ., fixed = TRUE) %>%
        gsub('"', '\\\\"', .)
    reformatted
}

instructions_code_block_ <- function(s) {
    # s <- s  %>%
    #     reformat_string_() %>%
    #     gsub("\n", "\\\\n", .)

    instructions <- paste0(c(
        "`r if (instructions) \"",
        s,
        "\" else \"\"`\n"
    ), collapse = "")

    instructions
}

## find all dynamic questions and, for each one, create a prefix and replace
## cells with R code blocks
build_dynamic_ <- function(df, ans_cols) {
    ## fill in the basic information, assuming the questions are not dynamic
    df$rcode <- ""
    df$is_dynamic <- FALSE

    ## keep only the first row that contains each unique ID
    res_row <- df[!duplicated(df$id), ]

    ## all rows with repeated IDs are dynamic, so save their ids
    dynamic_ids <- df$id[duplicated(df$id)] %>%
        unique()

    ## furthermore, all rows with a value for nchoices or ncorrect are dynamic
    if ("nchoices" %in% colnames(df)) {
        dynamic_ids <- df$id[!is.na(df$nchoices)] %>%
            c(dynamic_ids) %>%
            unique()
    }
    if ("ncorrect" %in% colnames(df)) {
        dynamic_ids <- df$id[!is.na(df$ncorrect)] %>%
            c(dynamic_ids) %>%
            unique()
    }

    ## apply the dynamic function to all dynamic question ids
    res_row[res_row$id %in% dynamic_ids, ] <- dynamic_ids %>%
        lapply(dyna_, df = df, ans_cols = ans_cols) %>%
        do.call(rbind, .) %>%
        as.data.frame()

    res_row
}

dyna_ <- function(id, df, ans_cols) {
    ## extract only the rows that match the desired id
    df <- df[df$id == id, ]

    ## format all questions and explanations for use in Rmd code blocks
    df$question <- df$question %>%
        reformat_string_() %>%
        gsub("\n", r"(\\n)", .)
    df$explanation <- df$explanation %>%
        reformat_string_() %>%
        gsub("\n", r"(\\n)", .)

    ## if there is a "part 0", treat it like instructions for all other parts
    if ("part" %in% colnames(df) && any(df$part == 0)) {
        instructions <- df[df$part == 0, ]$question[[1]]
        res_row <- df[df$part != 0, ][1, ]
    } else {
        df$part <- 1
        instructions <- ""
        res_row <- df[1, ]
    }

    ## if there are such instructions, format them for Rmd, and add the
    ## `instructions` variable to the `expar`-able codeblock at the top
    dyna_start <- rexamsll:::dyna_start
    if (instructions != "") {
        instructions <- instructions_code_block_(instructions)
        dyna_start <- rexamsll:::dyna_start_instructions
    }

    ## mchoice and schoice questions need a list of options, which string
    ## questions do not
    if (res_row$type == "string") {
        res_row <- dyna_string_question_(res_row, df, dyna_start)
    } else {
        res_row <- dyna_question_(res_row, df, ans_cols, dyna_start)
    }

    ## all dynamic questions are dynamic and pull question text from the
    ## question row `qrow`
    res_row$question <- "`r qrow$question`"
    res_row$is_dynamic <- TRUE
    res_row$image <- "`r if (is.na(qrow$image)) \"\" else sprintf(\"![](%s)\", qrow$image)`"

    ## if there are instructions, add them before the question text
    if (instructions != "") {
        res_row$question <- paste0(c(
            instructions,
            res_row$question
        ), collapse = "\n")
    }

    res_row
}

dyna_string_question_ <- function(row, df, dyna_start) {
    ## string questions are simple. just make all the segments, concatenate
    ## them together, and sandwich between the code block start and end.
    row$rcode <- df[df$part != 0, ] %>%
        apply(1, dyna_string_question_segment_) %>%
        paste0(collapse="") %>%
        c(dyna_start, ., rexamsll:::dyna_end, "```\n") %>%
        paste0(collapse="")

    ## the "correct" metadata is just the string solution itself
    row$correct <- "`r qrow$correct`"

    row
}

dyna_question_ <- function(row, df, ans_cols, dyna_start) {
    ## how many choices, and how many are correct?
    ## also, both of these lines are ugly.
    dyna_ncho <- "length(unlist(qrow$correct)) + length(unlist(qrow$incorrect))"
    dyna_ncorr <- "1"

    ## overwrite those numbers if the author provided them already
    if ("nchoices" %in% colnames(df)) {
        valid_ncho <- !is.na(df$nchoices)
        if (any(valid_ncho)) {
            dyna_ncho <- df$nchoices[valid_ncho][[1]]
        }
    }

    if ("ncorrect" %in% colnames(df)) {
        valid_ncorr <- !is.na(df$ncorrect)
        if (any(valid_ncorr)) {
            dyna_ncorr <- df$ncorrect[valid_ncorr][[1]]
        }
    }

    ## concatenate the dataframe creator, the many "add..." functions, the
    ## qvariation picker, the nchoice and ncorrect numbers, and the
    ## answer-list selector
    if (any(is.na(df$image))) {
        browser()
    }
    row$rcode <- df[df$part != 0, ] %>%
        apply(1, dyna_question_segment_) %>%
        paste0(collapse = "\n") %>%
        c(
            dyna_start,
            .,
            rexamsll:::dyna_end,
            "\nnchoices <- ",
            dyna_ncho,
            "\nncorrect <- ",
            dyna_ncorr,
            rexamsll:::dyna_make_choices
        ) %>%
        paste0(collapse = "")

    ## the answers are a bulleted list, and the choices are a binary string
    row$answers <- "`r choices$answerlist`"
    row$correct <- "`r choices$exsolution`"

    row
}


#' Generate a single `add_string_question` call for this row
#' 
#' @param row "string" row from a validated rexamsll dataframe
#' @returns String that calls `add_string_question`
#' 
#' @seealso `add_string_question.R`

dyna_string_question_segment_ <- function(row) {
    if (!("image" %in% colnames(row)) || is.na(row$image) || row$image == "") {
        image <- "NA"
    } else {
        image <- sprintf("\"%s\"", row$image)
    }

    # row$question <- reformat_string_(row$question)
    # row$correct <- reformat_string_(row$correct)

    res <- sprintf(
        rexamsll:::dyna_add_string,
        row$question,
        image,
        row$explanation,
        row$correct
    )

    res
}


#' Generate a single `add_from_pool` call for this row
#' 
#' @param row "schoice" or "mchoice" row from a validated rexamsll dataframe
#' @returns String that calls `add_from_pool`
#' 
#' @seealso `add_from_pool.R`

dyna_question_segment_ <- function(row) {
    image <- if (row$image == "") "NA" else sprintf("\"%s\"", row$image)

    if (length(row$answers) > 0 && all(!is.na(row$answers))) {
        answer_pool <- row$answers %>%
            paste0(collapse = "\", \"") %>%
            sprintf(
                "data.frame(text = c(\"%s\"), id = seq_len(%s))",
                .,
                length(row$answers)
            )
    } else {
        answer_pool <- "setNames(data.frame(matrix(ncol = 2, nrow = 0)), c(\"text\", \"id\"))"
    }

    correct_ids <- row$correct %>%
        gregexpr("1", .) %>%
        unlist() %>%
        paste0(collapse = ", ") %>%
        sprintf("c(%s)", .)

    # row$question <- row$question %>%
    #     reformat_string_()

    res <- sprintf(
        rexamsll:::dyna_add,
        row$question,
        image,
        answer_pool,
        row$explanation,
        correct_ids
    )

    res
}

## IMAGE
## ===========================================================

## add a section to import an image, if there is one
include_image_ <- function(x) {
    if (is.na(x) || x == "" || x == "0") return("")

    rmd <- '\`\`\`{r, echo = FALSE, results = "hide"}
include_supplement("%s", dir = "%s")
\`\`\`
\\
![](%s)'
    image_markdown <- sprintf(
        rmd,
        basename(x),
        dirname(x),
        basename(x)
    )

    image_markdown
}

## CORRECT ANSWER(S)
## ===========================================================


## add a "Solution" section with the answer's explanation, if there is one
include_explanation_ <- function(x) {
    if (is.na(x) | x == "") return("")

    explanation <- paste(c(
        "\n",
        "Solution",
        "========",
        x,
        ""
    ), collapse = "\n")
    explanation
}

## convert a string referring to an answer to choice to that answer's index
get_answer_ind_ <- function(x) {
    ## ignore any occurences of "Ans", "ans", "Answer", "answer", etc.
    x <- gsub("ans(wer)?s?", "", x, ignore.case = TRUE)

    ## case 1: x is a number, e.g. "1"
    ind <- suppressWarnings(as.numeric(x))
    if (!is.na(ind)) {
        return(ind)
    }

    ## case 2: x is a letter, e.g. "A", "a"
    x <- gsub(" ", "", x)
    ind <- match(tolower(x), letters[1:26])
    ind
}

## convert a number of list of numbers to a string of 1s and 0s, where 1s
## indicate correct answers
correct2choices_ <- function(row) {
    correct_str <- row$correct
    num_ans <- length(row$answers)

    ## case 0:
    ## numanswers is 0 or type is 'string'. return correct_str.
    if (num_ans == 0 || row$type == "string") {
        return(correct_str)
    }

    ## case 1:
    ## correct_str is a single number, e.g. "1"
    ind <- get_answer_ind_(correct_str)
    if (!is.na(ind)) {
        res_binary <- append(rep(0, num_ans - 1), 1, after = ind - 1) %>%
            paste(collapse = "")
        return(res_binary)
    }

    ## case 2:
    ## correct_str is a list of comma-separated numbers, e.g. "1,2,3"
    inds <- strsplit(correct_str, ",|(,? *and)") %>%
        unlist() %>%
        lapply(get_answer_ind_) %>%
        unlist()
    if (!any(is.na(inds))) {
        binary_vec <- rep(0, num_ans)
        binary_vec[inds] <- 1
        res_binary <- paste(binary_vec, collapse = "")
        return(res_binary)
    }

    ## case 3:
    ## behavior is undefined. assume string question and return x.
    correct_str
}

## EXTRA METADATA
## ===========================================================

## find any columns that don't match the expected column names
find_metadata_cols_ <- function(df) {
    cols <- colnames(df)
    cols <- cols[-rexamsll:::find_answer_columns(df)]
    cols <- cols[!(cols %in% rexamsll:::req_cols)]
    cols <- cols[!(cols %in% rexamsll:::ignore_cols)]
    return(cols)
}

## build a yaml header that includes any extra metadata
## format:
## ---
## column_name: value
## ...
metadata_yaml_ <- function(df) {
    yaml <- rexamsll:::yaml_header
    cols <- find_metadata_cols_(df)
    metadata <- vector(mode = "character", length = nrow(df))

    for (i in cols) {
        for (j in which(df[i] != "")) {
            metadata[j] <- paste0(
                metadata[j],
                sprintf("%s: %s\n", tolower(i), df[j, i]),
                collapse = ""
            )
        }
    }

    res_string <- sprintf(yaml, df$id, metadata)
    res_string
}

## build a footer of metadata that follows r/exams conventions
## stackoverflow.com/questions/73713203/possible-meta-informations-in-r-exams
metadata_footer_ <- function(df) {
    cols <- find_metadata_cols_(df)
    metadata <- vector(mode = "character", length = nrow(df))

    for (i in cols) {
        for (j in which(df[i] != "")) {
            metadata[j] <- paste0(
                metadata[j],
                sprintf("exextra[%s]: %s\n", tolower(i), df[j, i]),
                collapse = ""
            )
        }
    }

    metadata
}
