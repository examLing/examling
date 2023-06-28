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

test_that("Random number of correct answers from range", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    checker_exs <- list("1000" = 0, "1100" = 0, "1110" = 0)
    found_invalid_exsolution <- FALSE

    set.seed(1)

    for (x in seq_len(100)) {
        choices <- build_choices(df[1, ], 4, c(1, 3))

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

test_that("Request more correct choices than df$correct has", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    set.seed(1)

    expect_warning(
        choices <- build_choices(df[1, ], 7, 6),
        paste(
            "Expected number of correct choices 6 greater than actual amount",
            "of correct choices 5"
        )
    )

    expect_equal(names(choices), c("answerlist", "exsolution"))
    expect_equal(choices$exsolution, "1111100")
})

test_that("Request more correct choices than total choices", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    set.seed(1)

    expect_warning(
        choices <- build_choices(df[1, ], 4, 5),
        paste(
            "Provided number of correct choices 5 greater than total number",
            "of choices 4"
        )
    )

    expect_equal(names(choices), c("answerlist", "exsolution"))
    expect_equal(choices$exsolution, "1111")
})

test_that("Request too many correct choices in random range", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    set.seed(1)

    expect_warning(
        choices <- build_choices(df[1, ], 4, c(1, 5)),
        paste(
            "Upper bound on number of correct answers 5 greater than number",
            "of choices 4"
        )
    )

    ncorrect <- choices$exsolution %>%
        str_split("") %>%
        unlist() %>%
        strtoi %>%
        sum()

    expect_equal(names(choices), c("answerlist", "exsolution"))
    expect_lte(ncorrect, 4)
    expect_gte(ncorrect, 1)
})

test_that("Invalid random range for ncorrect", {
    df <- rexamsll::add_question(
        "Which letter(s) are vowels?",
        correct = c("a", "e", "i", "o", "u"),
        incorrect = c("b", "c", "d", "f", "g", "h")
    )

    expect_error(
        choices <- build_choices(df[1, ], 4, c(1, 5, 6)),
        "Invalid length for ncorrect: expected vector of length 1 or 2"
    )

    expect_error(
        choices <- build_choices(df[1, ], 4, c()),
        "Invalid length for ncorrect: expected vector of length 1 or 2"
    )
})
