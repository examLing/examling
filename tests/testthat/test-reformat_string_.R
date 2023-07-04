test_that("Empty string", {
    res <- rexamsll:::reformat_string_("")
    expect_equal(res, "")
})

test_that("Regular string", {
    res <- rexamsll:::reformat_string_("Regular string")
    expect_equal(res, "Regular string")
})

test_that("Backslashes", {
    res <- rexamsll:::reformat_string_("C:\\Users")
    expect_equal(res, "C:\\\\Users")
})

test_that("Quotes", {
    res <- rexamsll:::reformat_string_("\"Quotes\"")
    expect_equal(res, "\\\"Quotes\\\"")
})

test_that("Integer input", {
    res <- rexamsll:::reformat_string_(1)
    expect_equal(res, "1")
})

test_that("Backslashes before quotes", {
    res <- rexamsll:::reformat_string_("\\\"")
    expect_equal(res, "\\\\\\\"")
})