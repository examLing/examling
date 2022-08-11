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
* Type: One of 'schoice', 'mchoice', or 'string'
* Image: The image file's name (or inserted image for Excel/Google Sheets)
* Ans#: Any number of answer columns, preferably labeled with numbers for
* Correct: The index of (or letter corresponding to) the correct answer
* Category: Question's category
* SubCat: Questions's subcategory

# Functions

## `add_question(question, image, explanation, <see below>, df)`

Add a question to a dataframe, validating and/or transforming inputs.

Parameters:
* `question`: Question text.
* `image`: Image filename (optional).
* `explanation`: Explanation for the correct answer (optional).
* `correct_ids`: Numeric vector of correct answer indices.
* `choices`: Tibble of answer choices, with id and text columns.
* `correct`: Vector of possible correct answers.
* `incorrect`: Vector of possible incorrect answers.
* `df`: Dataframe to add question to.

ONLY `correct_ids`+`choices` OR `correct`+`incorrect` should be provided.

If you use the first pair, `correct` and `incorrect` vectors will be
generated automatically from the choices using the given indices.

If a dataframe is not provided, a new one is created.

### Examples

Using `correct` and `incorrect`:

```
df <- add_question(
    question = "Which city is located in Asia?",
    correct = c("Kyoto", "Tokyo", "Beijing", "Delhi"),
    incorrect = c("Paris", "London", "Washington D.C."),
    df = df
)
```

Using `correct_ids` and `choices`:

```
answers <- tribble(
    ~id, ~text,
    1, "Paris",
    2, "London",
    3, "Kyoto",
    4, "Delhi",
    5, "Washington D.C.",
    6, "Tokyo",
    7, "Beijing"
)

df <- add_question(
    question = "Which city is located in Europe?",
    choices = answers,
    correct_ids = c(1, 2),
    df = df
)
```

## `bulleted_list(x)`

Concatenate string items to form a bulleted list.

Parameters:
* `x`: List of strings.

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
