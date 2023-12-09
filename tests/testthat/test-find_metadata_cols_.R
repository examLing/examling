df_test <- data.frame(
    id = c("1", "2", "3", "1", "1", "4", "4", "4", "4"),
    question = c(
        "Question 1a?",
        "Question 2?",
        "Question 3?",
        "Question 1b?",
        "Question 1c?",
        "Question 4a?",
        "Question 4b?",
        "Question 4c?",
        "Question 4d?"
    ),
    type = c(
        "mchoice",
        "mchoice",
        "string",
        "",
        "",
        "mchoice",
        "",
        "",
        ""
    ),
    ans1 = c(
        "ARS",
        "Trust",
        "",
        "",
        "",
        "0",
        "",
        "",
        ""
    ),
    ans2 = c(
        "**BLT**",
        "Relationship status",
        "",
        "",
        "",
        "1",
        "",
        "",
        ""
    ),
    ans3 = c(
        "*BES*",
        "Jealousy",
        "",
        "",
        "",
        "2",
        "",
        "",
        ""
    ),
    ans4 = c(
        "QTI",
        "Happiness",
        "",
        "",
        "",
        "3",
        "",
        "",
        ""
    ),
    ans5 = c(
        "ASL",
        "Friendship",
        "",
        "",
        "",
        "4",
        "",
        "",
        ""
    ),
    ans6 = c(
        "UoM",
        "",
        "",
        "",
        "",
        "5",
        "",
        "",
        ""
    ),
    correct = c(
        "3",
        "1, 3",
        "Ambwani, Strauss",
        "2",
        "1, 2, 4, 5, 6",
        "2, 3, 5",
        "1, 3, 5",
        "6",
        "1, 3, 6"
    ),
    category = c(
        "article",
        "article",
        "article",
        "",
        "",
        "math",
        "",
        "",
        ""
    ),
    subcat = c(
        "measure",
        "predictors",
        "author",
        "",
        "",
        "numbers",
        "",
        "",
        ""
    ),
    difficulty = c(
        "1",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    ),
    source = c(
        "Kearns",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    ),
    chapter = c(
        "1",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    ),
    author = c(
        "Kearns",
        "Brighton",
        "Bob",
        "",
        "",
        "Brighton",
        "",
        "",
        ""
    ),
    warning = c(
        "",
        "",
        "",
        "BLT is bolded, but that gives away the answer.",
        "",
        "",
        "",
        "",
        ""
    ),
    nchoices = c(
        "3",
        "",
        "",
        "",
        "",
        "4",
        "",
        "",
        ""
    )
)

test_that("Find metadata in default test", {
    expected <- c(
        "difficulty",
        "source",
        "chapter",
        "author",
        "warning"
    )

    metadata_cols <- examling:::find_metadata_cols_(df_test)
    expect_equal(metadata_cols, expected)
})
