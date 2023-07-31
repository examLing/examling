test_that("Load sheet by name", {
    unlink("Example/*")
    url <- paste0(
        "docs.google.com/spreadsheets/d/",
        "1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        collapse = ""
    )

    google2rmd(
        url,
        "Example",
        sheet = "Truth Conditions"
    )

    google2rmd(
        url,
        "Example",
        sheet = "Lambda Calculus"
    )

    expect_gt(length(list.files("Example")), 0)
})