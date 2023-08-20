test_that("Find all metadata in Types1.Rmd", {
    expected <- tribble(
        ~filename, ~qvariation, ~source, ~chapter, ~url, ~sheet, ~is_dynamic, ~difficulty,
        "ExpectedRmd/Types1.Rmd", 1, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 2, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 3, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 4, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 5, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 6, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 7, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 8, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 9, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 10, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 11, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 12, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 13, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2"
    ) %>% data.frame()

    metadata <- get_metadata("Types1.Rmd", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, wrong extension", {
    expected <- tribble(
        ~filename, ~qvariation, ~source, ~chapter, ~url, ~sheet, ~is_dynamic, ~difficulty,
        "ExpectedRmd/Types1.Rmd", 1, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 2, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 3, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 4, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 5, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 6, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 7, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 8, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 9, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 10, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 11, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 12, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 13, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2"
    ) %>% data.frame()

    metadata <- get_metadata("Types1.txt", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, no extension", {
    expected <- tribble(
        ~filename, ~qvariation, ~source, ~chapter, ~url, ~sheet, ~is_dynamic, ~difficulty,
        "ExpectedRmd/Types1.Rmd", 1, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 2, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 3, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 4, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 5, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 6, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "1",
        "ExpectedRmd/Types1.Rmd", 7, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 8, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 9, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 10, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 11, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 12, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2",
        "ExpectedRmd/Types1.Rmd", 13, "Kearns", "4", "docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Lambda Calculus", "TRUE", "2"
    ) %>% data.frame()

    metadata <- get_metadata("Types1.", "ExpectedRmd")

    expect_equal(metadata, expected)
})

test_that("Metadata with multi-line issue", {
    # expected <- list(
    #     source = "Allwood",
    #     chapter = "2",
    #     issue = c("no difficulty", "Code block in string."),
    #     url = "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
    #     sheet = "Truth Conditions",
    #     is_dynamic = "TRUE"
    # )
    expected <- tribble(
        ~filename, ~qvariation, ~source, ~chapter, ~issue, ~url, ~sheet, ~is_dynamic,
        "ExpectedRmd/Settheory16.Rmd", 1, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE",
        "ExpectedRmd/Settheory16.Rmd", 2, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE",
        "ExpectedRmd/Settheory16.Rmd", 3, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE",
        "ExpectedRmd/Settheory16.Rmd", 4, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE",
        "ExpectedRmd/Settheory16.Rmd", 5, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE",
        "ExpectedRmd/Settheory16.Rmd", 6, "Allwood", "2", "no difficulty\nCode block in string.", "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", "Truth Conditions", "TRUE"
    ) %>% data.frame()

    metadata <- get_metadata("Settheory16.Rmd", "ExpectedRmd")

    expect_equal(metadata, expected)
})