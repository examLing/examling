req_cols <- c("id", "question", "type", "correct", "category")
ignore_cols <- c(
    "answers",
    "rcode",
    "image",
    "imagemd",
    "explanation",
    "subcat",
    "nchoices",
    "ncorrect"
)

yaml_header <- paste(
    "---",
    "title: \"%s\"",
    "date: \"`r Sys.Date()`\"",
    "%s---",
    "",
    sep = "\n"
)

js_submit <- paste(
    "<p>",
    "    <button id=\"sub%qid\">Submit</button>",
    "</p>",
    "<p id=\"res%qid\">",
    "    Click to submit.",
    "</p>",
    "<script>",
    "const btn%qid = document.querySelector('#sub%qid')",
    "btn%qid.addEventListener('click', (event) => {",
    "    let checkboxes = document.querySelectorAll('input[name=\"q%qid\"]:checked');",
    "    let value = 0;",
    "    checkboxes.forEach((checkbox) => {",
    "        value += 1 << checkbox.value;",
    "    });",
    "    console.log(value);",
    "    if (value == %correct) {",
    "        document.getElementById(\"res%qid\").innerHTML = \"Correct\";",
    "    } else {",
    "        document.getElementById(\"res%qid\").innerHTML = \"Incorrect\";",
    "    }",
    "});",
    "</script>",
    "",
    sep = "\n"
)

schoice <- paste(
    "",
    "Question",
    "========",
    "",
    "%s",
    "%s",
    "",
    "Answerlist",
    "----------",
    "",
    "%s%s",
    "",
    "Meta-information",
    "================",
    "exname: %s",
    "extype: schoice",
    "exsolution: %s",
    "exsection: %s",
    "exshuffle: TRUE",
    "",
    sep = "\n"
)

mchoice <- paste(
    "",
    "Question",
    "========",
    "",
    "%s",
    "%s",
    "",
    "Answerlist",
    "----------",
    "",
    "%s%s",
    "",
    "Meta-information",
    "================",
    "exname: %s",
    "extype: mchoice",
    "exsolution: %s",
    "exsection: %s",
    "exshuffle: TRUE",
    "",
    sep = "\n"
)

string <- paste(
    "",
    "Question",
    "========",
    "",
    "%s",
    "%s%s%s",
    "",
    "Meta-information",
    "================",
    "exname: %s",
    "extype: string",
    "exsolution: %s",
    "exsection: %s",
    "",
    sep = "\n"
)

dyna_start <- paste(
    "",
    "```{r, echo = FALSE, results = \"hide\"}",
    "qvariation <- 1",
    "```",
    "",
    "```{r, echo = FALSE, results = \"hide\"}",
    "df <- rexamsll::build_question_df()",
    "",
    sep = "\n"
)

dyna_start_instructions <- paste(
    "",
    "```{r, echo = FALSE, results = \"hide\"}",
    "qvariation <- 1",
    "instructions <- FALSE",
    "```",
    "",
    "```{r, echo = FALSE, results = \"hide\"}",
    "df <- rexamsll::build_question_df()",
    "",
    sep = "\n"
)

dyna_add <- paste(
    "",
    "df <- add_from_pool(",
    "    question = \"%s\",",
    "    image = %s,",
    "    answer_pool = %s,",
    "    correct_ids = %s,",
    "    df = df",
    ")",
    "",
    sep = "\n"
)

dyna_add_string <- paste(
    "",
    "df <- add_string_question(",
    "    question = \"%s\",",
    "    image = %s,",
    "    correct = \"%s\",",
    "    df = df",
    ")",
    "",
    sep = "\n"
)

dyna_end <- paste(
    "",
    "## find the row corresponding to the chosen question variation.",
    "if (qvariation > nrow(df)) {",
    "    stop(sprintf(",
    "        \"Question variation %%d is greater than the number of options (%%d).\",",
    "        qvariation, nrow(df)))",
    "}",
    "qrow <- df[qvariation, ]",
    "",
    "## include the image as a supplemental file.",
    "if (!is.na(qrow$image))",
    "    include_supplement(qrow$image, dir = \"./img\", recursive = TRUE)",
    "",
    sep = "\n"
)

dyna_make_choices <- paste(
    "",
    "",
    "choices <- rexamsll::build_choices(qrow, nchoices, ncorrect)",
    "```",
    "",
    sep = "\n"
)

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