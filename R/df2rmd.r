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

    ## convert a number x (e.g. "1", "2") to a string of 1s and 0s, where the
    ## xth digit is 1.
    correct2schoice <- function(x) {
        ind <- as.numeric(gsub("Ans", "", x))
        if (is.na(ind)) return(x)
        paste(append(rep(0, 4), 1, after = ind - 1), collapse = "")
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

    ## insert data base into template
    rmd <- sprintf(rmd,
        df$Question,
        sapply(df$Image, include_image),
        bulletedlist(df[c("Ans1", "Ans2", "Ans3", "Ans4", "Ans5")]),
        df$ID,
        sapply(df$Correct, correct2schoice),
        df$Category, df$SubCat)

    ## write Rmd files
    for (i in seq_len(nrow(df))) writeLines(rmd[i],
        paste0(output_dir, "/", df$ID[i], ".Rmd"))
    invisible(rmd)
}