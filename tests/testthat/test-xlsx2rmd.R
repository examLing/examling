test_that("Load sheet by name", {
    google2rmd(
        "https://docs.google.com/spreadsheets/d/1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4/edit#gid=895826255",
        "Example/Danny/05 Truth Conditions",
        sheet = "Truth Conditions"
    )

    expect_equal(1, 1)
})