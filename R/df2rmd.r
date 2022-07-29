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
    ## Rmd exercise template
    rmd <- rexamsll:::schoice

    ## grab the correct template for each question
    rmd <- df$Type %>%
        lapply(function(x) rexamsll:::templates[[x]]) %>%
        unlist

    ## find answer columns
    ans_cols <- find_answer_columns(df)
    df$answers <- df[ans_cols] %>%
        apply(1, as.list) %>%
        lapply(function(x) x[!is.na(x)])

    ## insert data base into template
    rmd <- sprintf(rmd,
        df$Question,
        sapply(df$Image, include_image),
        lapply(df$answers, bulleted_list),
        df$ID,
        apply(df, 1, correct2choices),
        df$Category, df$SubCat)

    ## write Rmd files
    for (i in seq_len(nrow(df))) writeLines(rmd[i],
        paste0(output_dir, "/", df$ID[i], ".Rmd"))
    invisible(rmd)
}

## IMAGE
## ===========================================================

## add a section to import an image, if there is one
include_image <- function(x) {
    if (x == "0") return("")
    rmd <- '```{r, echo = FALSE, results = "hide"}
include_supplement("%s")
```
\\
![](%s)'
    sprintf(rmd, x, x)
}

## BULLETED ANSWERS
## ===========================================================

## use regex to find all columns that start with "Ans"
find_answer_columns <- function(df) {
    colnames(df) %>%
        grep("^(A|a)ns", .) %>%
        unlist
}

## create a single element of a bulleted list
add_bullet <- function(x) {
    if (is.na(x) || x == "") {
    return("")
    } else {
    return(sprintf("* %s\n", x))
    }
}

## concatenate bullets of a list
## x should be a list of strings.
## empty elements are ignored.
bulleted_list <- function(x) {
    ## if there are no answers, return an empty string
    if (length(x) == 0) return("")
    x %>%
        lapply(add_bullet) %>%
        paste0(collapse = "")
}

## CORRECT ANSWER(S)
## ===========================================================

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
    x <- row$Correct
    num_ans <- length(row$answers)

    ## case 0:
    ## numanswers is 0 or type is 'string'. return x.
    if (num_ans == 0 || row$Type == "string") {
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
        for (i in inds) {
            res[i] <- 1
        }
        return(paste(res, collapse = ""))
    }

    ## case 3:
    ## behavior is undefined. assume string question and return x.
    return(x)
}