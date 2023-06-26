test_that("Simple bulleted list of strings", {
    actual <- bulleted_list(c("Simple", "bulleted", "list", "of", "strings"))

    expected <- "* Simple
* bulleted
* list
* of
* strings
"

    expect_equal(actual, expected)
})

test_that("Empty bulleted list", {
    actual <- bulleted_list(c())

    expected <- ""
    
    expect_equal(actual, expected)
})

test_that("Bulleted list out of a vector of numbers", {
    actual <- bulleted_list(c(1, 2, 3, 4, 5))

    expected <- "* 1
* 2
* 3
* 4
* 5
"
    expect_equal(actual, expected)
})

test_that("Bulleted list from a list object", {
    actual <- bulleted_list(list(c("First", "Second")))

    expected <- "* First
* Second
"
    
    expect_equal(actual, expected)
})

test_that("Bulleted list of a single number", {
    actual <- bulleted_list(4)

    expected <- "* 4
"
    expect_equal(actual, expected)
})
