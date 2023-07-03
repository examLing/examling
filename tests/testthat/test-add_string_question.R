test_that("Add question to empty dataframe", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_string_question(
        "What is the capitol of Michigan?",
        correct = "Lansing",
        df = df
    )

    expected_result <- data.frame(
        question = "What is the capitol of Michigan?",
        image = NA,
        correct = "Lansing",
        incorrect = NA,
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Build dataframe with question", {
    df <- add_string_question(
        "What is the capitol of Michigan?",
        correct = "Lansing"
    )

    expected_result <- data.frame(
        question = "What is the capitol of Michigan?",
        image = NA,
        correct = "Lansing",
        incorrect = NA,
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Add two questions, no starting dataframe", {
    df <- add_string_question(
        "What is the capitol of Michigan?",
        correct = "Lansing"
    )

    df <- add_string_question(
        "What is the capitol of New York?",
        correct = "Albany",
        df = df
    )

    expected_result <- rbind(
        data.frame(
            question = "What is the capitol of Michigan?",
            image = NA,
            correct = "Lansing",
            incorrect = NA,
            explanation = NA
        ),
        data.frame(
            question = "What is the capitol of New York?",
            image = NA,
            correct = "Albany",
            incorrect = NA,
            explanation = NA
        )
    )

    expect_equal(nrow(df), 2)
    expect_equal(df, expected_result)
})

test_that("Insert keywords into question", {
    df <- add_string_question(
        "What is the %1 of %2?",
        correct = "Lansing",
        keywords = c("capitol", "Michigan")
    )

    expected_result <- data.frame(
        question = "What is the capitol of Michigan?",
        image = NA,
        correct = "Lansing",
        incorrect = NA,
        explanation = NA
    )

    expect_equal(df, expected_result)
})

test_that("Use all parameters, unnamed", {
    df <- data.frame(matrix(ncol = 5, nrow = 0)) %>%
        setNames(c("question", "image", "correct", "incorrect", "explanation"))

    df <- add_string_question(
        "What is the %1 of %2?",
        "image.png",
        "Lansing is a city on the lower peninsula of Michigan west of Detroit",
        "Lansing",
        c("capitol", "Michigan"),
        df
    )

    expected_result <- data.frame(
        question = "What is the capitol of Michigan?",
        image = "image.png",
        correct = "Lansing",
        incorrect = NA,
        explanation = paste(
            "Lansing is a city on the lower peninsula of Michigan west of",
            "Detroit"
        )
    )

    expect_equal(df, expected_result)
})