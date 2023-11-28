## create_rmd.R

#' @title Start a new .Rmd file from a template.
#'
#' @description Create a .Rmd file in a specified location with the basic
#'  layout provided, ready for the user to create a new question.
#'
#' @param save_as Where to save the created file.
#' @param question_type What kind of question being created. From:
#'  * `"schoice"`
#'  * `"mchoice"`
#'  * `"string"`
#' @param dynamic_type How to make the question dynamic. Default is `"none"`.
#' From:
#'  * `"none"` - No code blocks are used for random question generation.
#'      Normal.
#'  * `"variations"` - Create a dataframe that contains full variations of
#'      a question.
#'  * `"keywords"` - Like `"variations"`, but only a few key words in the
#'      question are changed between variations, as well as the answers.
#'  * `"dynamic"` - (`"schoice"` and `"mchoice"` only). Start with a tribble of
#'      potential answers and draw from it for each variation. Other answers
#'      from the tribble are used as incorrect choices.
#'  * `"pooled"` - (`"schoice"` and `"mchoice"` only). Single question where
#'      the answer choices are randomly selected.
#' @param open Whether or not to open the file upon creation. Default: `false`.
#'
#' @details # Examples for Dynamic Types
#'
#' * `"none"` - Q: "Who developed the famous equation e = mc^2?", A: "Albert
#'      Einstein".
#' * `"variations"` - Different questions referring to the properties of
#'      helium atoms that should still be kept in the same file. Q:
#'      "What is the atomic mass of helium?", A: "4". Q: "What state of
#'      matter is helium", A: "Gas".
#' * `"keywords"` - Questions asking the atomic masses of different elements.
#'      Q: "What is the atomic mass of HELIUM?", A: "4". Q: "What is the
#'      atomic mass of OXYGEN?", A: "16".
#' * `"dynamic"` - Questions asking which elements belong to different columns.
#'      Q: "Which element(s) can be found in column 18?", A: "He", "Ne", "Ar",
#'      "Kr", "Xe", "Rn", or "Og". Q: "Which element(s) can be found in column
#'      16?", A: "O", "S", "Se", "Te", "Po", or "Lv".
#' * `"pooled"` - Q: "Which element has the largest atomic radius?",
#'      A: "Francium" (the incorrect answers can be drawn from a pool
#'      containing all other elements).
#'
#' @details # `string` Questions
#'
#' If the `question_type` is `"string"`, the `dynamic_type` can only be
#' `"none"`, `"keywords"`, or `"variations"`.
#'
#' @details # Credits
#' Brighton Pauli, 2023
#'
#' @export

create_rmd <- function(
    save_as,
    question_type,
    dynamic_type = "none",
    open = FALSE
) {
    template_name <- question_type

    if (question_type == "schoice" || question_type == "mchoice") {
        if (dynamic_type != "none" &&
            dynamic_type != "variations" && dynamic_type != "keywords" &&
            dynamic_type != "dynamic" && dynamic_type != "pooled"
        ) {
            stop(paste(
                "Dynamic type must be 'none', 'variations', 'keywords', ",
                "'dynamic', or 'pooled'. Given: ", dynamic_type,
                sep = ""
            ))
        }
    } else if (question_type == "string") {
        if (dynamic_type != "none" &&
            dynamic_type != "variations" && dynamic_type != "keywords"
        ) {
            stop(paste(
                "Dynamic type must be 'none', 'variations', or 'keywords'. ",
                "Given: ", dynamic_type,
                sep = ""
            ))
        }
    } else {
        stop(paste(
            "Question type must be 'schoice', 'mchoice', or 'string'. Given: ",
            question_type,
                sep = ""
        ))
    }

    if (dynamic_type != "none") {
        template_name <- paste0(question_type, "_", dynamic_type)
    }

    rmarkdown::draft(
        save_as,
        template_name,
        "rexamsll",
        edit = open
    )
}