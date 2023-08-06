test_that("Basic question with image", {
    df <- data.frame(
        question = "What is the capitol of Michigan?",
        type = "string",
        image = "Michigan.jpg",
        explanation = "",
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = \"Michigan.jpg\",",
        "    explanation = \"\",",
        "    correct = \"Lansing\",",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})

test_that("Basic question, image is empty string", {
    df <- data.frame(
        question = "What is the capitol of Michigan?",
        type = "string",
        image = "",
        explanation = "",
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
        "    explanation = \"\",",
        "    correct = \"Lansing\",",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})

test_that("Basic question, image is NA", {
    df <- data.frame(
        question = "What is the capitol of Michigan?",
        type = "string",
        image = NA,
        explanation = "",
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
        "    explanation = \"\",",
        "    correct = \"Lansing\",",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})

test_that("Basic question, image is not specified", {
    df <- data.frame(
        question = "What is the capitol of Michigan?",
        type = "string",
        explanation = "",
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
        "    explanation = \"\",",
        "    correct = \"Lansing\",",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})