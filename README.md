# `examling`

`examling` is an extension to the `r/exams` package that provides convenient function for importing questions from external sources and manipulating information within dynamic questions.

For more information, go to https://brightp-py.github.io/examling_site/index.html.

# Installation

While `examling` is in development, the most recently pushed version can be
installed through GitHub using the devtools library.

```r
install.packages("devtools")

library(devtools)
install_github("https://github.com/examLing/examling")
library(examling)
```

# CSV Column Headers

* Question: The question text
* Type: One of 'schoice', 'mchoice', or 'string'
* Image: The image file's name (or inserted image for Excel/Google Sheets)
* Ans#: Any number of answer columns, preferably labeled with numbers for
* Correct: The index of (or letter corresponding to) the correct answer
* Category: Question's category
* SubCat: Questions's subcategory