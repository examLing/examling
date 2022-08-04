req_cols <- c("question", "type", "image", "correct", "category", "subcat")

yaml_header <- "---
title: \"%s\"
date: \"`r Sys.Date()`\"
%s---
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