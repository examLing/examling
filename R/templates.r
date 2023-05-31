req_cols <- c("question", "type", "correct", "category", "subcat")
ignore_cols <- c("ID", "answers", "rcode", "image", "imagemd", "explanation")

yaml_header <- "---
title: \"%s\"
date: \"`r Sys.Date()`\"
%s---
"

js_submit <- "<p>
    <button id=\"sub%qid\">Submit</button>
</p>
<p id=\"res%qid\">
    Click to submit.
</p>
<script>
const btn%qid = document.querySelector('#sub%qid')
btn%qid.addEventListener('click', (event) => {
    let checkboxes = document.querySelectorAll('input[name=\"q%qid\"]:checked');
    let value = 0;
    checkboxes.forEach((checkbox) => {
        value += 1 << checkbox.value;
    });
    console.log(value);
    if (value == %correct) {
        document.getElementById(\"res%qid\").innerHTML = \"Correct\";
    } else {
        document.getElementById(\"res%qid\").innerHTML = \"Incorrect\";
    }
});
</script>
"

schoice <- "
Question
========

%s
%s

Answerlist
----------

%s%s

Meta-information
================
exname: %s
extype: schoice
exsolution: %s
exsection: %s/%s
exshuffle: TRUE
"

mchoice <- "
Question
========

%s
%s

Answerlist
----------

%s%s

Meta-information
================
exname: %s
extype: mchoice
exsolution: %s
exsection: %s/%s
exshuffle: TRUE
"

string <- "
Question
========

%s
%s%s%s

Meta-information
================
exname: %s
extype: string
exsolution: %s
exsection: %s/%s
"

dyna_start <- "
```{r, echo = FALSE, results = \"hide\"}
qvariation <- 1
```

```{r, echo = FALSE, results = \"hide\"}
df <- rexamsll::build_question_df()
"

dyna_add <- "
df <- add_from_pool(
    question = \"%s\",
    image = %s,
    answer_pool = %s,
    correct_ids = %s,
    df = df
)
"

dyna_end <- "
## find the row corresponding to the chosen question variation.
if (qvariation > nrow(df)) {
    stop(sprintf(
        \"Question variation %%d is greater than the number of options (%%d).\",
        qvariation, nrow(df)))
}
qrow <- df[qvariation, ]

%s

## if there aren't at least `ncorrect` correct answers, decrease ncorrect
ncorrect <- min(c(ncorrect, length(qrow$correct %%>%% unlist)))

## include the image as a supplemental file.
if (!is.na(qrow$image))
    include_supplement(qrow$image, dir = \"./img\", recursive = TRUE)

## sample correct and incorrect answers from qrow.
correct <- sample(qrow$correct %%>%% unlist, size = ncorrect)
incorrect <- sample(qrow$incorrect %%>%% unlist, size = nchoices - ncorrect)

## concatenate the two to get a list of all the answers.
choices <- c(correct, incorrect)
```
"

templates <- list()
templates$schoice <- schoice
templates$mchoice <- mchoice
templates$string <- string

usethis::use_data(
    req_cols,
    ignore_cols,
    yaml_header,
    schoice,
    mchoice,
    string,
    templates,
    internal = TRUE, overwrite = TRUE)