test_that("Set question type to unallowed string 'm-choice'", {
    expect_error(
        create_rmd("", "m-choice"),
        paste(
            "Question type must be 'schoice', 'mchoice', or 'string'. Given: ",
            "m-choice",
            sep = ""
        )
    )
})

test_that("Set dynamic type to unallowed string 'na'", {
    expect_error(
        create_rmd("", "mchoice", "na"),
        paste(
            "Dynamic type must be 'none', 'variations', 'keywords', ",
            "'dynamic', or 'pooled'. Given: na",
            sep = ""
        )
    )
})

test_that("Set dynamic type to 'dynamic' for 'string' question", {
    expect_error(
        create_rmd("", "string", "dynamic"),
        paste(
            "Dynamic type must be 'none', 'variations', or 'keywords'. ",
            "Given: dynamic",
            sep = ""
        )
    )
})

df <- data.frame(
    question_type = c(
        "mchoice", "mchoice", "mchoice", "mchoice", "mchoice",
        "schoice", "schoice", "string", "string"
    ),
    dynamic_type = c(
        "none", "variations", "keywords", "dynamic", "pooled",
        "none", "pooled", "none", "variations"
    )
)

for (i in seq_len(nrow(df))) {
    filename <- paste(
        "Empty/",
        paste(df$question_type[i], df$dynamic_type[i], sep = "_"),
        ".Rmd",
        sep = ""
    )

    actualname <- paste(
        "ExpectedRmd/",
        paste(df$question_type[i], df$dynamic_type[i], sep = "_"),
        ".Rmd",
        sep = ""
    )

    if (!file.exists(filename)) {
        create_rmd(
            filename,
            df$question_type[i],
            df$dynamic_type[i]
        )
    }

    test_that(filename, {
        expecttext <- filename %>%
            read_file %>%
            gsub("\r", "", .)

        actualtext <- actualname %>%
            read_file %>%
            gsub("\r", "", .)

        expect_equal(actualtext, expecttext)
    })
}