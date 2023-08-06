test_that("Basic schoice question with image", {
    df <- data.frame(
        id = "1",
        question = "What is the capitol of Michigan?",
        type = "schoice",
        answers = I(data.frame(
            ans1 = "Lansing",
            ans2 = "Albany",
            ans3 = "Sacramento",
            ans4 = "Boston"
        )),
        image = "Michigan.jpg",
        explanation = "",
        correct = "1",
        category = "geography"
    )

    res <- rexamsll:::dyna_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_from_pool(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = \"Michigan.jpg\",",
        "    answer_pool = data.frame(text = c(\"Lansing\", \"Albany\", \"Sacramento\", \"Boston\"), id = seq_len(4)),",
        "    explanation = \"\",",
        "    correct_ids = c(1),",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})

test_that("Basic schoice question with no answers", {
    df <- data.frame(
        id = "1",
        question = "What is the capitol of Michigan?",
        type = "schoice",
        answers = NA,
        image = "Michigan.jpg",
        explanation = "",
        correct = "1",
        category = "geography"
    )

    res <- rexamsll:::dyna_question_segment_(df[1, ])

    expected_result <- paste(
        "",
        "df <- add_from_pool(",
        "    question = \"What is the capitol of Michigan?\",",
        "    image = \"Michigan.jpg\",",
        "    answer_pool = setNames(data.frame(matrix(ncol = 2, nrow = 0)), c(\"text\", \"id\")),",
        "    explanation = \"\",",
        "    correct_ids = c(1),",
        "    df = df",
        ")",
        "",
        sep = "\n"
    )

    expect_equal(res, expected_result)
})