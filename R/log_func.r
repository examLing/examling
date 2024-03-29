## log_func.R

pkg.env <- new.env()
pkg.env$logs_are_open <- FALSE

#' @title Wrapper for `logr::log_open`.
#'
#' @description Create a log file, if needed, and run `logr::log_open`.` If
#' you have previously run `end_logs()`, this will restart the logs for your
#' function calls.
#'
#' @param filepath Path to write logs to.
#'
#' @details
#' By default, the path for logs is "./logs/yyyymmdd_hhmmsss.log"
#'
#' @export

start_logs <- function(filepath = NA) {
    if (pkg.env$logs_are_open) return()

    if (is.na(filepath)) {
        filepath <- Sys.time() %>%
            format("logs/%Y%m%d_%H%M%S.log")
    }

    # if the log directory does not exist already, create it
    if (!file.exists("logs")) {
        dir.create("logs", recursive = TRUE)
    }

    logr::log_open(filepath, show_notes = FALSE)
    pkg.env$logs_are_open <- TRUE
}

#' @title Wrapper for `logr::log_close`.
#'
#' @description Run this function to stop generating logs for your functions.
#' You can restart the logs using `start_logs()`.
#'
#' @export

end_logs <- function() {
    if (pkg.env$logs_are_open) logr::log_close()
    pkg.env$logs_are_open <- FALSE
}
