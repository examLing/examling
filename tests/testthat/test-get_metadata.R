test_that("Find all metadata in Types1.Rmd", {
    expected <- list(
        source = "Kearns",
        chapter = "4",
        url = "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        sheet = "Lambda Calculus",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.Rmd", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1, with `paste`d values", {
    expected <- list(
        source = "Kearns",
        chapter = 4,
        url = "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        sheet = "Lambda Calculus",
        is_dynamic = TRUE
    )

    expected <- lapply(expected, paste)

    metadata <- get_metadata("Types1", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, wrong extension", {
    expected <- list(
        source = "Kearns",
        chapter = "4",
        url = "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        sheet = "Lambda Calculus",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.txt", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, no extension", {
    expected <- list(
        source = "Kearns",
        chapter = "4",
        url = "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        sheet = "Lambda Calculus",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Metadata with multi-line issue", {
    expected <- list(
        source = "Allwood",
        chapter = "2",
        issue = c("no difficulty", "Code block in string."),
        url = "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        sheet = "Truth Conditions",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Settheory16.Rmd", "ExpectedRmd")

    expect_equal(metadata, expected)
})