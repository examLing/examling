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

    ## reformat image, explanation, answer, and correct columns
    df$imagemd <- sapply(df$image, include_image)
    df$explanation <- sapply(df$explanation, include_explanation)
    df$correct <- apply(df, 1, correct2choices)
    df <- build_dynamic(df, ans_cols)
    df$answers[!df$is_dynamic] <- lapply(df$answers[!df$is_dynamic],
        rexamsll::bulleted_list)
    df$answers[df$type == "string"] <- ""

    ## grab the correct template for each question
    rmd <- df$type %>%
        lapply(function(x) rexamsll:::templates[[x]]) %>%
        unlist

    ## create an "exsection" metadata parameter based on the cat and subcat
    exsection <- sprintf("%s/%s", df$category, df$subcat)
    exsection[df$subcat == ""] <- df$category[df$subcat == ""]

    ## insert data base into template
    rmd <- sprintf(rmd,
        df$question,
        df$imagemd,
        df$answers,
        df$explanation,
        df$id,
        df$correct,
        exsection)

    ## add yaml headers to the top
    rmd <- paste0(metadata_yaml(df), df$rcode, rmd)

    ## write Rmd files
    for (i in seq_len(nrow(df))) writeLines(rmd[i],
        paste0(output_dir, "/", df$id[i], ".Rmd"))
    invisible(rmd)
}

## DYNAMIC QUESTIONS
## ===========================================================

reformat_string <- function(s) {
    s %>%
        gsub("\\", "\\\\", ., fixed = TRUE) %>%
        gsub('"', '\\\\"', .)
}

## find all dynamic questions and, for each one, create a prefix and replace
## cells with R code blocks
build_dynamic <- function(df, ans_cols) {
    ## fill in the basic information, assuming the questions are not dynamic
    df$rcode <- ""
    df$is_dynamic <- FALSE

    ## keep only the first row that contains each unique ID
    res <- df[!duplicated(df$id), ]

    ## all rows with repeated IDs are dynamic, so save their ids
    dynamic <- df$id[duplicated(df$id)] %>%
        unique()

    ## furthermore, all rows with a value for nchoices or ncorrect are dynamic
    if ("nchoices" %in% colnames(df)) {
        dynamic <- df$id[!is.na(df$nchoices)] %>%
            c(dynamic) %>%
            unique()
    }
    if ("ncorrect" %in% colnames(df)) {
        dynamic <- df$id[!is.na(df$ncorrect)] %>%
            c(dynamic) %>%
            unique()
    }
    
    ## apply the dynamic function to all dynamic question ids
    res[res$id %in% dynamic, ] <- dynamic %>%
        lapply(dyna, df = df, ans_cols = ans_cols) %>%
        do.call(rbind, .) %>%
        as.data.frame

    res
}

dyna <- function(id, df, ans_cols) {
    ## extract only the rows that match the desired id
    df <- df[df$id == id, ]

    ## if there is a "part 0", treat it like instructions for all other parts
    if ("part" %in% colnames(df) && any(df$part == 0)) {
        instructions <- df[df$part == 0, ]$question[[1]]
        res <- df[df$part != 0, ][1, ]
    }
    else {
        df$part <- 1
        instructions <- ""
        res <- df[1, ]
    }

    ## if there are such instructions, format them for Rmd, and add the
    ## `instructions` variable to the `expar`-able codeblock at the top
    dyna_start <- rexamsll:::dyna_start
    if (instructions != "") {
        instructions <- paste0(c(
            "`r if (instructions) \"",
            reformat_string(instructions),
            "\" else \"\"`\n\n"
        ), collapse = "")
        dyna_start <- rexamsll:::dyna_start_instructions
    }

    ## mchoice and schoice questions need a list of options, which string
    ## questions do not
    if (res$type == "string") {
        res <- dyna_string_question(res, df, dyna_start)
    }
    else {
        res <- dyna_question(res, df, ans_cols, dyna_start)
    }

    ## all dynamic questions are dynamic and pull question text from the
    ## question row `qrow`
    res$question <- "`r qrow$question`"
    res$is_dynamic <- TRUE
    res$image <- "`r if (is.na(qrow$image)) \"\" else sprintf(\"![](%s)\", qrow$image)`"

    ## if there are instructions, add them before the question text
    if (instructions != "") {
        res$question <- paste0(c(
            instructions,
            res$question
        ), collapse = "\n\n")
    }

    res
}

dyna_string_question <- function(row, df, dyna_start) {
    ## string questions are simple. just make all the segments, concatenate
    ## them together, and sandwich between the code block start and end.
    row$rcode <- df[df$part != 0, ] %>%
        apply(1, dyna_string_question_segment) %>%
        paste0(collapse="\n") %>%
        c(dyna_start, ., rexamsll:::dyna_end, "```") %>%
        paste0(collapse="")

    ## the "correct" metadata is just the string solution itself
    row$correct <- "`r qrow$correct`"

    row
}

dyna_question <- function(row, df, ans_cols, dyna_start) {
    ## how many choices, and how many are correct?
    ## also, both of these lines are ugly.
    dyna_ncho <- "length(qrow$correct %>% unlist) + length(qrow$incorrect %>% unlist)"
    dyna_ncorr <- "sample(1:length(qrow$correct %>% unlist), 1)"

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
    row$rcode <- df[df$part != 0, ] %>%
        apply(1, dyna_question_segment) %>%
        paste0(collapse="\n") %>%
        c(dyna_start,
          .,
          rexamsll:::dyna_end,
          "\nnchoices <- ",
          dyna_ncho,
          "\nncorrect <- ",
          dyna_ncorr,
          rexamsll:::dyna_make_choices) %>%
        paste0(collapse="")

    ## the answers are a bulleted list, and the choices are a binary string
    row$answers <- "`r rexamsll::bulleted_list(choices)`"
    row$correct <- "`r paste0(c(rep(1, ncorrect), rep(0, nchoices - ncorrect)), collapse = \"\")`"

    row
}

dyna_string_question_segment <- function(row) {
    image <- if (row$image == "") "NA" else sprintf("\"%s\"", row$image)

    row$question <- row$question %>%
        reformat_string
    
    row$correct <- row$correct %>%
        reformat_string
    
    res <- sprintf(
        rexamsll:::dyna_add_string,
        row$question,
        image,
        row$correct
    )

    res
}

dyna_question_segment <- function(row) {
    image <- if (row$image == "") "NA" else sprintf("\"%s\"", row$image)
    
    if (length(row$answers) > 0) {
        answer_pool <- row$answers %>%
            paste0(collapse = "\", \"") %>%
            sprintf("data.frame(text = c(\"%s\"), id = seq_len(%s))", .,
                length(row$answers))
    }
    else {
        answer_pool <- "setNames(data.frame(matrix(ncol = 2, nrow = 0)), c(\"text\", \"id\"))"
    }

    correct_ids <- row$correct %>%
        gregexpr("1", .) %>%
        unlist %>%
        paste0(collapse = ", ") %>%
        sprintf("c(%s)", .)

    row$question <- row$question %>%
        reformat_string
    
    res <- sprintf(
        rexamsll:::dyna_add,
        row$question,
        image,
        answer_pool,
        correct_ids
    )

    res
}

## IMAGE
## ===========================================================

## add a section to import an image, if there is one
include_image <- function(x) {
    if (x == "0") return("")
    rmd <- '\`\`\`{r, echo = FALSE, results = "hide"}
include_supplement("%s", dir = "%s")
\`\`\`
\\
![](%s)'
    sprintf(rmd, basename(x), dirname(x), basename(x))
}

## CORRECT ANSWER(S)
## ===========================================================


## add a "Solution" section with the answer's explanation, if there is one
include_explanation <- function(x) {
    if (is.na(x) | x == "") return("")
    paste(c("\n", "Solution", "========", x, "\n"), collapse = "\n")
}

## convert a string referring to an answer to choice to that answer's index
get_answer_ind <- function(x) {
    ## ignore any occurences of "Ans", "ans", "Answer", "answer", etc.
    x <- gsub("ans(wer)?s?", "", x, ignore.case = TRUE)

    ## case 1: x is a number, e.g. "1"
    ind <- suppressWarnings(as.numeric(x))
    if (!is.na(ind)) {
        return(ind)
    }

    ## case 2: x is a letter, e.g. "A", "a"
    x <- gsub(" ", "", x)
    return(match(tolower(x), letters[1:26]))
}

## convert a number of list of numbers to a string of 1s and 0s, where 1s
## indicate correct answers
correct2choices <- function(row) {
    x <- row$correct
    num_ans <- length(row$answers)

    ## case 0:
    ## numanswers is 0 or type is 'string'. return x.
    if (num_ans == 0 || row$type == "string") {
        return(x)
    }

    ## case 1:
    ## x is a single number, e.g. "1"
    ind <- get_answer_ind(x)
    if (!is.na(ind)) {
        res <- append(rep(0, num_ans - 1), 1, after = ind - 1) %>%
            paste(collapse = "")
        return(res)
    }

    ## case 2:
    ## x is a list of comma-separated numbers, e.g. "1,2,3"
    inds <- strsplit(x, ",|(,? *and)") %>%
        unlist %>%
        lapply(get_answer_ind) %>%
        unlist
    if (!any(is.na(inds))) {
        res <- rep(0, num_ans)
        res[inds] <- 1
        return(paste(res, collapse = ""))
    }

    ## case 3:
    ## behavior is undefined. assume string question and return x.
    return(x)
}

## EXTRA METADATA
## ===========================================================

## find any columns that don't match the expected column names
find_metadata_cols <- function(df) {
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
metadata_yaml <- function(df) {
    yaml <- rexamsll:::yaml_header
    cols <- find_metadata_cols(df)
    metadata <- vector(mode = "character", length = nrow(df))
    for (i in cols) {
        for (j in seq_len(nrow(df))) {
            metadata[j] <- paste0(metadata[j],
                sprintf("%s: %s\n", tolower(i), df[j, i]), collapse = "")
        }
    }
    sprintf(yaml, df$id, metadata)
}
