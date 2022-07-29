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

usethis::use_data(schoice, mchoice, string, templates, internal = TRUE,
    overwrite = TRUE)