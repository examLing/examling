req_cols <- c("question", "type", "image", "correct", "category", "subcat")

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

%s

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

%s

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
%s%s

Meta-information
================
exname: %s
extype: string
exsolution: %s
exsection: %s/%s
"

templates <- list()
templates$schoice <- schoice
templates$mchoice <- mchoice
templates$string <- string

usethis::use_data(
    req_cols,
    yaml_header,
    schoice,
    mchoice,
    string,
    templates,
    internal = TRUE, overwrite = TRUE)