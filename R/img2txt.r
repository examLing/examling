## img2txt.R

log_images <- FALSE

#' @title Visualize images in logs.
#'
#' @description Convert an image into a very rough text representation.
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

    # check for strange numbers of color channels.
    # 1 means the image is already grayscale.
    # 4 means there is an extra alpha channel that needs to be removed.
    # 3 means the image is ready to be grayscaled.
    if (spectrum(im) == 4) {
        im <- rm.alpha(im)
    }
    if (spectrum(im) == 3) {
        im <- grayscale(im)
    }

    df <- im %>%
        resize(w, h) %>%
        as.data.frame()

    df <- tryCatch(
        expr = {
            df %>%
                mutate(qv = as.integer(pmin(value, n))) %>%
                mutate(asc = asc[qv])
        },
        error = function(cond) {
            av <- mean(df$value)
            df %>%
                mutate(qv = value %/% av + 1) %>%
                mutate(qv = as.integer(pmin(qv, 2))) %>%
                mutate(asc = asc2[qv])
        }
    )

    image_string <- (function(n) paste0(df$asc[df$y == n], collapse = "")) %>%
        sapply(1:max(df$y), .) %>%
        paste0(collapse = "\n")
    image_string
}
