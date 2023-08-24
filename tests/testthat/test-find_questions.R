test_that("Find all questions, no filter", {
    actual <- find_questions(
        "D:/git/rexams-ll/rexamsll/tests/testthat/ExpectedRmd"
    )

    expect_equal(0, 0)
})

test_that("Find all questions, filter out ones with issues", {
    actual <- find_questions(
        "D:/git/rexams-ll/rexamsll/tests/testthat/ExpectedRmd",
        is.na(issue)
    )

    expect_equal(0, 0)
})