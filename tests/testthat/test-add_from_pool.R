test_that("Add pooled question to empty dataframe", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_from_pool(
        "What is the answer?",
        answer_pool = tribble(
            ~id, ~text,
            1, "40",
            2, "41",
            3, "42",
            4, "43"
        ),
        correct_ids = 3,
        df = df
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = I(list("42")),
        incorrect = I(list(c("40", "41", "43"))),
        explanation = NA
    )

    expect_equal(nrow(df), 1)
    expect_equal(df, expected_result)
})

test_that("Build dataframe with pooled question", {
    df <- add_from_pool(
        "What is the answer?",
        answer_pool = tribble(
            ~id, ~text,
            1, "40",
            2, "41",
            3, "42",
            4, "43"
        ),
        correct_ids = 3
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = I(list("42")),
        incorrect = I(list(c("40", "41", "43"))),
        explanation = NA
    )

    expect_equal(nrow(df), 1)
    expect_equal(df, expected_result)
})

test_that("Add two questions, no starting dataframe", {
    df <- add_from_pool(
        "What is the answer?",
        answer_pool = tribble(
            ~id, ~text,
            1, "40",
            2, "41",
            3, "42",
            4, "43"
        ),
        correct_ids = 3
    )

    df <- add_from_pool(
        "What is the second answer?",
        answer_pool = tribble(
            ~id, ~text,
            1, "30",
            2, "31",
            3, "32",
            4, "33"
        ),
        correct_ids = c(3, 4),
        df = df
    )

    expected_result <- rbind(
        data.frame(
            question = "What is the answer?",
            image = NA,
            correct = I(list("42")),
            incorrect = I(list(c("40", "41", "43"))),
            explanation = NA
        ),
        data.frame(
            question = "What is the second answer?",
            image = NA,
            correct = I(list(c("32", "33"))),
            incorrect = I(list(c("30", "31"))),
            explanation = NA
        )
    )

    expect_equal(nrow(df), 2)
    expect_equal(df, expected_result)
})

test_that("Insert keywords into pooled question", {
    df <- add_from_pool(
        "How many %1 are in a %2?",
        answer_pool = tribble(
            ~id, ~text,
            1, "10",
            2, "100",
            3, "1,000",
            4, "10,000"
        ),
        correct_ids = 3,
        keywords = c("grams", "kilogram")
    )

    expected_result <- data.frame(
        question = "How many grams are in a kilogram?",
        image = NA,
        correct = I(list("1,000")),
        incorrect = I(list(c("10", "100", "10,000"))),
        explanation = NA
    )

    expect_equal(nrow(df), 1)
    expect_equal(df, expected_result)
})

test_that("Use all parameters, unnamed", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_from_pool(
        "How many %1 are in a %2?",
        "image.png",
        "\"Kilo\" means thousand.",
        tribble(
            ~id, ~text,
            1, "10",
            2, "100",
            3, "1,000",
            4, "10,000"
        ),
        3,
        c("grams", "kilogram"),
        df
    )

    expected_result <- data.frame(
        question = "How many grams are in a kilogram?",
        image = "image.png",
        correct = I(list("1,000")),
        incorrect = I(list(c("10", "100", "10,000"))),
        explanation = "\"Kilo\" means thousand."
    )

    expect_equal(nrow(df), 1)
    expect_equal(df, expected_result)
})

test_that("Insert >9 keywords into pooled question", {
    df <- add_from_pool(
        "%1, %2, %3, %4, %5, %6, %7, %8, %9, %10",
        answer_pool = tribble(
            ~id, ~text,
            1, "10",
            2, "100",
            3, "1,000",
            4, "10,000"
        ),
        correct_ids = 3,
        keywords = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")
    )

    expected_result <- data.frame(
        question = "a, b, c, d, e, f, g, h, i, j, k",
        image = NA,
        correct = I(list("1,000")),
        incorrect = I(list(c("10", "100", "10,000"))),
        explanation = NA
    )

    expect_equal(nrow(df), 1)
    expect_equal(df, expected_result)
})
