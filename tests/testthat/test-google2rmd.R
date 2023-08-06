test_that("Load sheet by name", {
    unlink("Example/*")
    url <- paste0(
        "docs.google.com/spreadsheets/d/",
        "1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4",
        collapse = ""
    )

    suppressWarnings(
        expect_warning(
            google2rmd(
                url,
                "Example",
                sheet = "Truth Conditions"
            ),
            paste0(
                "Spreadsheet formatting cannot be read; use markdown-style ",
                "formatting instead."
            )
        )
    )

    suppressWarnings(
        google2rmd(
            url,
            "Example",
            sheet = "Lambda Calculus"
        )
    )

    expect_gt(length(list.files("Example")), 0)
})

filenames <- list.files("Example")

for (filename in filenames) {
    expectname <- paste0("ExpectedRmd/", filename)
    actualname <- paste0("Example/", filename)
    if (file.exists(expectname)) {
        test_that(filename, {
            expecttext <- expectname %>%
                read_file %>%
                gsub("\r", "", .)

            actualtext <- actualname %>%
                read_file %>%
                gsub("\r", "", .)

            expect_equal(actualtext, expecttext)
        })
    }
}