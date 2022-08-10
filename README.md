# Installation

While `rexamsll` is in development, the most recently pushed version can be
installed through GitHub using the devtools library.

```r
install.packages("devtools")

library(devtools)
install_github("https://github.com/examLing/rexamsll")
library(rexamsll)
```

# CSV Column Headers

* Question: The question text
* Image: The image file's name (or inserted image for Excel/Google Sheets)
* Ans#: Any number of answer columns, preferably labeled with numbers for
* Correct: The index of (or letter corresponding to) the correct answer
* Category: Question's category
* SubCat: Questions's subcategory

# Functions

## `create_id(category, subcat)`

Create an ID with format "[category][subcat][random number]"

Parameters:
* `category`: The category of the question.
* `subcat`: The subcategory of the question.

Returns a string of the form "[category][subcat][random number]".

## `csv2rmd(x, output_dir, ...)`

Convert a csv file of questions into r/exams-style Rmd files.

Parameters:
* `x`: Filepath to csv file.
* `output_dir`: Directory to write Rmd files to.
* `...`: Additional arguments for read.csv.

## `df2rmd(df, output_dir)`

Convert a dataframe of questions into r/exams-style Rmd files.

**Used in other functions in the package. `df2rmd` is available to the user,
but they are not expected to run it directly.**

Parameters:
* `df`: Dataframe of questions.
* `output_dir`: Directory to write Rmd files to.

## `google2rmd(url, output_dir)`

Download a Google Sheet of questions and convert it to Rmd files.

Parameters:
* `url`: URL to the Google Sheet.
* `output_dir`: Directory to write Rmd files to.

## `xlsx2rmd(x, output_dir, ...)`

Convert an xlsx spreadsheet of questions into r/exams-style Rmd files.

Parameters:
* `x`: Filepath to xlsx file.
* `output_dir`: Directory to write Rmd files to.
* `...`: Additional arguments for openxlsx::loadWorkbook.

Inserted images are imported from the xlsx file and saved in the
`[output_dir]/img` directory with the same name as the question's generated ID.

## `bulleted_list(x)`

Concatenate string items to form a bulleted list.

Parameters:
* `x`: List of strings.
