test_that("Error; Empty dataframe", {
    colnames <- c(
        "ID",
        "Question",
        "Type",
        "Ans1",
        "Ans2",
        "Correct",
        "Category",
        "SubCat"
    )

    df <- data.frame(matrix(ncol = length(colnames), nrow = 0)) %>%
        setNames(colnames)

    expect_error(
        df <- examling:::validate_df(df),
        "Dataframe has no values. Did you select the wrong sheet?"
    )
})

test_that("Error; no answer columns", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "schoice",
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "No answer columns found"
    )
})

test_that("Error; no Type column", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Ans1 = "A",
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "Missing column\\(s\\): type"
    )
})

test_that("Error; no Correct or Category column", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "schoice",
        Ans1 = "A",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "Missing column\\(s\\): correct, category"
    )
})

test_that("No SubCat column", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "schoice",
        Ans1 = "A",
        Correct = "1",
        Category = "cat"
    )

    df <- examling:::validate_df(df)

    expect_true(all(df$subcat == ""))
})

test_that("Decimal in Correct column, as a number", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "schoice",
        Ans1 = "A",
        Correct = 1.5,
        Category = "cat",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "The Correct column must be plain text"
    )
})

test_that("Decimal in Correct column, as a string", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "schoice",
        Ans1 = "A",
        Correct = "1.5",
        Category = "cat",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "The Correct column must be plain text"
    )
})

test_that("String question, with no answer choices", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "string",
        Ans1 = NA,
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    df <- examling:::validate_df(df)

    expect_false(all(is.na(df)))
})

test_that("String question, with answer choices", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "string",
        Ans1 = "A",
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    expect_warning(
        df <- examling:::validate_df(df),
        "'string' row 1 has values in answer columns"
    )
})

test_that("Error; Mchoice question, with no answer choices", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "mhoice",
        Ans1 = NA,
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    expect_error(
        df <- examling:::validate_df(df),
        "Row 1 has no values in answer columns"
    )
})

test_that("Mchoice question, with answer choices", {
    df <- data.frame(
        ID = "1",
        Question = "Question",
        Type = "mchoice",
        Ans1 = "A",
        Correct = "1",
        Category = "cat",
        SubCat = "sub"
    )

    df <- examling:::validate_df(df)

    expect_false(all(is.na(df)))
})