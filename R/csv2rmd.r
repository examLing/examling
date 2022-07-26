csv2rmd <- function(x, ...) {
  ## read CSV data base
  x <- read.csv(x, colClasses = "character", ...)

  ## Rmd exercise template
  rmd <- "
Question
========

%s
%s

Answerlist
----------

%s

Meta-information
================
exname: %s
extype: schoice
exsolution: %s
exsection: %s/%s
exshuffle: TRUE
"

  ## convenience functions
  include_image <- function(x) {
    if (x == "0") return("")
    rmd <- '```{r, echo = FALSE, results = "hide"}
include_supplement("%s")
```
\\
![](%s)'
    sprintf(rmd, x, x)
  }

  ## create an ID with format "[category][subcat][random number]"
  create_id <- function(x) {
    ## get category
    category <- x[1]
    ## get subcategory
    subcat <- x[2]
    ## get random number
    random <- as.character(sample(1:10000000, 1))
    ## create ID
    sprintf("%s%s%s", category, subcat, random)
  }

  correct2schoice <- function(x) {
    x <- as.numeric(gsub("Ans", "", x))
    paste(append(rep(0, 4), 1, after = x - 1), collapse = "")
  }

  ## create a single element of a bulleted list
  addbullet <- function(x) {
    if (x == "") {
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
    x$Question,
    sapply(x$Image, include_image),
    bulletedlist(x[c("Ans1", "Ans2", "Ans3", "Ans4", "Ans5")]),
    # x$ID,
    apply(x[c("Category", "SubCat")], 1, create_id),
    sapply(x$Correct, correct2schoice),
    x$Category, x$SubCat)


  ## write Rmd files
  for (i in 1L:nrow(x)) writeLines(rmd[i], paste0(x$ID[i], ".Rmd"))
  invisible(rmd)
}