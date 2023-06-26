test_that("Add question to empty dataframe", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_question(
        "What is the answer?",
        correct = "42",
        incorrect = c("40", "41", "43"),
        df = df
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = I(list("42")),
        incorrect = I(list(c("40", "41", "43"))),
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Build dataframe with question", {
    df <- add_question(
        "What is the answer?",
        correct = "42",
        incorrect = c("40", "41", "43")
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = I(list("42")),
        incorrect = I(list(c("40", "41", "43"))),
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Add two questions, no starting dataframe", {
    df <- add_question(
        "What is the answer?",
        correct = "42",
        incorrect = c("40", "41", "43")
    )

    df <- add_question(
        "What is the second answer?",
        correct = c("32", "33"),
        incorrect = c("30", "31"),
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

test_that("Insert keywords into question", {
    df <- add_question(
        "How many %1 are in a %2?",
        correct = "1,000",
        incorrect = c("10", "100", "10,000"),
        keywords = c("grams", "kilogram")
    )

    expected_result <- data.frame(
        question = "How many grams are in a kilogram?",
        image = NA,
        correct = I(list("1,000")),
        incorrect = I(list(c("10", "100", "10,000"))),
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Use all parameters, unnamed", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_question(
        "How many %1 are in a %2?",
        "image.png",
        "\"Kilo\" means thousand.",
        "1,000",
        c("10", "100", "10,000"),
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

    expect_equal(df, expected_result)
})

test_that("Insert >9 keywords into question", {
    df <- add_question(
        "%1, %2, %3, %4, %5, %6, %7, %8, %9, %10",
        correct = "1,000",
        incorrect = c("10", "100", "10,000"),
        keywords = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")
    )

    expected_result <- data.frame(
        question = "a, b, c, d, e, f, g, h, i, j",
        image = NA,
        correct = I(list("1,000")),
        incorrect = I(list(c("10", "100", "10,000"))),
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Create question with no correct answers", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_question(
        "What is the answer?",
        incorrect = c("40", "41", "43", "44"),
        df = df
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = NA,
        incorrect = I(list(c("40", "41", "43", "44"))),
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Create question with ONLY correct answers", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_question(
        "What is the answer?",
        correct = c("40", "41", "43", "44"),
        df = df
    )

    expected_result <- data.frame(
        question = "What is the answer?",
        image = NA,
        correct = I(list(c("40", "41", "43", "44"))),
        incorrect = NA,
        explanation = NA
    )

    expect_equal(df, expected_result)
})
