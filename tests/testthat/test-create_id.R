test_that("ID from category and sub-category", {
    res <- examling::create_id("cat", "sub")
    expect_true(str_detect(res, "^catsub"))
})

test_that("ID with spaces", {
    res <- examling::create_id("Cat", "Sub cat")
    expect_true(str_detect(res, "^CatSubcat"))
})

# test_that("Check for duplicates via brute force", {
#     ids <- c()

#     for (x in seq_len(1000)) {
#         new_id <- examling::create_id("cat", "sub")
#         ids <- c(ids, new_id)
#     }

#     expect_false(any(duplicated(ids)))
# })

test_that("ID with no sub-category", {
    res <- examling::create_id("Cat")
    expect_true(str_detect(res, "^Cat\\d*$"))
})
