## img2txt.r

log_images <- TRUE

#' Convert an image into a very rough text representation.
#'
#' @param imgpath File path for image.
#' @param h Height of result image, in number of lines. (Default 10)

img2txt <- function(imgpath, h = 10) {
    im <- load.image(imgpath)

    asc <- c(" ", ".", "o", "O", "0")
    asc2 <- c(" ", "@")
    n <- length(asc)

    h <- 10
    w <- 2.4 * h * width(im) / height(im)
    df <- im %>%
        grayscale() %>%
        resize(w, h) %>%
        as.data.frame

    df <- tryCatch({
            df %>%
                mutate(qv = as.integer(cut_number(value, n))) %>%
                mutate(asc = asc[qv])
        },
        error = function(cond) {
            av <- mean(df$value)
            df %>%
                mutate(qv = value %/% av + 1) %>%
                mutate(asc = asc2[qv])
        }
    )

    (function(n) paste0(df$asc[df$y == n], collapse = "")) %>%
        sapply(1:max(df$y), .) %>%
        paste0(collapse = "\n")
}
