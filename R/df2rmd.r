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

    ## create an ID with format "[category][subcat][random number]"
    create_id <- function(category, subcat) {
        ## get random number
        random <- as.character(sample(1:10000000, 1))
        ## create ID
        sprintf("%s%s%s", category, subcat, random)
    }

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

    ## convert a string referring to an answer to choice to that answer's index
    getanswernum <- function(x) {
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
    correct2choices <- function(x, numanswers) {
        ## case 0:
        ## numanswers is 0. assume string question and return x.
        if (numanswers == 0) {
            return(x)
        }

        ## case 1:
        ## x is a single number, e.g. "1"
        ind <- getanswernum(x)
        if (!is.na(ind)) {
            res <- append(rep(0, numanswers - 1), 1, after = ind - 1) %>%
                paste(collapse = "")
            return(res)
        }

        ## case 2:
        ## x is a list of comma-separated numbers, e.g. "1,2,3"
        inds <- strsplit(x, ",|(,? *and)") %>%
            unlist %>%
            lapply(getanswernum) %>%
            unlist
        if (!any(is.na(inds))) {
            res <- rep(0, numanswers)
            for (i in inds) {
                res[i] <- 1
            }
            return(paste(res, collapse = ""))
        }

        ## case 3:
        ## behavior is undefined. assume string question and return x.
        return(x)
    }

    ## create a single element of a bulleted list
    addbullet <- function(x) {
        if (is.na(x) || x == "") {
        return("")
        } else {
        return(sprintf("* %s\n", x))
        }
    }

    ## concatenate bullets of a list
    ## df should be set up so that each row is a separate list and columns
    ## make up the list elements.
    ## empty elements are ignored.
    bulletedlist <- function(df) {
        apply(df, c(1, 2), addbullet) %>%
        apply(1, paste, collapse = "")
    }

    ## grab the correct template for each question
    rmd <- df$Type %>%
        lapply(function(x) rexamsll:::templates[[x]]) %>%
        unlist

    ## insert data base into template
    rmd <- sprintf(rmd,
        df$Question,
        sapply(df$Image, include_image),
        bulletedlist(df[c("Ans1", "Ans2", "Ans3", "Ans4", "Ans5")]),
        df$ID,
        sapply(df$Correct, correct2choices, numanswers = 5),
        df$Category, df$SubCat)

    ## write Rmd files
    for (i in seq_len(nrow(df))) writeLines(rmd[i],
        paste0(output_dir, "/", df$ID[i], ".Rmd"))
    invisible(rmd)
}