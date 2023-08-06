test_that("Find all metadata in Types1.Rmd", {
    expected <- list(
        difficulty = "1",
        source = "Kearns",
        chapter = "4",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.Rmd", "Example")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1, with `paste`d values", {
    expected <- list(
        difficulty = 1,
        source = "Kearns",
        chapter = 4,
        is_dynamic = TRUE
    )

    expected <- lapply(expected, paste)

    metadata <- get_metadata("Types1", "Example")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, wrong extension", {
    expected <- list(
        difficulty = "1",
        source = "Kearns",
        chapter = "4",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.txt", "Example")

    expect_equal(metadata, expected)
})

test_that("Find all metadata in Types1.Rmd, no extension", {
    expected <- list(
        difficulty = "1",
        source = "Kearns",
        chapter = "4",
        is_dynamic = "TRUE"
    )

    metadata <- get_metadata("Types1.", "Example")

    expect_equal(metadata, expected)
})