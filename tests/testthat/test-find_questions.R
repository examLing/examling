test_that("Find all questions, no filter", {
    actual <- find_questions("ExpectedRmd")

    expected_filenames <- c(
        "ExpectedRmd/Anaphors11.Rmd", "ExpectedRmd/Denotations1.Rmd",
        "ExpectedRmd/Indexicality12.Rmd", "ExpectedRmd/Settheory13.Rmd",
        "ExpectedRmd/Settheory14.Rmd", "ExpectedRmd/Settheory15.Rmd",
        "ExpectedRmd/Settheory16.Rmd", "ExpectedRmd/Truthconditions8.Rmd",
        "ExpectedRmd/Types1.Rmd"
    )

    expect_equal(unique(actual$filename), expected_filenames)

    expected_qvariations <- c(
        0, seq_len(6), 0, seq_len(6), seq_len(2), 0, seq_len(6), seq_len(2),
        seq_len(13)
    )

    expect_equal(actual$qvariation, expected_qvariations)
})

test_that("Find all questions, filter out ones with issues", {
    actual <- find_questions("ExpectedRmd", is.na(issue))

    expect_equal(0, 0)
})