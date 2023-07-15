test_that("Find 4 answer columns, format Ans#", {
    colnames <- c(
        "ID",
        "Question",
        "Type",
        "Ans1",
        "Ans2",
        "Ans3",
        "Ans4",
        "Correct",
        "Category",
        "SubCat"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)
    ans_cols <- rexamsll:::find_answer_columns(df)

    expected_result <- c(4, 5, 6, 7)

    expect_equal(ans_cols, expected_result)
})

test_that("Find 4 answer columns, format ans# and Ans#", {
    colnames <- c(
        "ID",
        "Question",
        "Type",
        "Ans1",
        "ans2",
        "Ans3",
        "ans4",
        "Correct",
        "Category",
        "SubCat"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)
    ans_cols <- rexamsll:::find_answer_columns(df)

    expected_result <- c(4, 5, 6, 7)

    expect_equal(ans_cols, expected_result)
})

test_that("Find 4 scattered answer columns, format Ans#", {
    colnames <- c(
        "ID",
        "Ans3",
        "Question",
        "Type",
        "Ans1",
        "Ans4",
        "Correct",
        "Category",
        "SubCat",
        "Ans2"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)

    expect_warning(
        ans_cols <- rexamsll:::find_answer_columns(df),
        "Answer columns Ans3, Ans1, Ans4, Ans2 are not consecutive"
    )

    expected_result <- c(2, 5, 6, 10)

    expect_equal(ans_cols, expected_result)
})

test_that("Find 4 answer columns, format Answer <letter>", {
    colnames <- c(
        "ID",
        "Question",
        "Type",
        "Answer A",
        "Answer B",
        "Answer C",
        "Answer D",
        "Correct",
        "Category",
        "SubCat"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)
    ans_cols <- rexamsll:::find_answer_columns(df)

    expected_result <- c(4, 5, 6, 7)

    expect_equal(ans_cols, expected_result)
})

test_that("Find 4 answer columns, with an 'answers' column", {
    colnames <- c(
        "ID",
        "Question",
        "Type",
        "Answer A",
        "Answer B",
        "Answer C",
        "Answer D",
        "Correct",
        "Category",
        "SubCat",
        "answers"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)
    ans_cols <- rexamsll:::find_answer_columns(df)

    expected_result <- c(4, 5, 6, 7)

    expect_equal(ans_cols, expected_result)
})