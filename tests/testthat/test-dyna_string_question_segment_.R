test_that("Basic question with image", {
    df <- data.frame(
        question = "What is the capitol of Michigan?",
        type = "string",
        image = "Michigan.jpg",
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = \"Michigan.jpg\",",
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
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
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
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
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
        correct = "Lansing"
    )

    res <- rexamsll:::dyna_string_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_string_question(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = NA,",
        "    correct = \"Lansing\",",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})