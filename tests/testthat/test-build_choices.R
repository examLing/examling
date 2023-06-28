test_that("Build choices with default NCorrect", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    set.seed(1)
    choices <- build_choices(df[1, ], 4)

    expect_equal(names(choices), c("answerlist", "exsolution"))
    expect_equal(choices$exsolution, "1000")
    expect_equal(str_count(choices$answerlist, "\n"), 4)
})

test_that("Random number of correct answers", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    checker_exs <- list("1000" = 0, "1100" = 0, "1110" = 0, "1111" = 0)
    found_invalid_exsolution <- FALSE

    set.seed(1)

    for (x in seq_len(100)) {
        choices <- build_choices(df[1, ], 4, NA)

        exs <- choices$exsolution
        if (exs %in% names(checker_exs)) {
            checker_exs[[exs]] <- checker_exs[[exs]] + 1
        } else {
            found_invalid_exsolution <- TRUE
        }
    }

    expect_true(all(checker_exs > 0))
    expect_false(found_invalid_exsolution)
})