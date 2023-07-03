test_that("Build question dataframe, empty", {
    df <- rexamsll::build_question_df()

    expected_result <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    expect_equal(df, expected_result)
})

test_that("Add question to empty dataframe", {
    df <- rexamsll::build_question_df()

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