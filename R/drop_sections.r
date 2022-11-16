## drop_sections.R

#' Help remove all sections from a pre-created QTI zip file.
#'
#' @details # Credits
#' Brighton Pauli, 2022

drop_sections_helper <- function(qti_file, temp_folder, out_file = NULL) {
    qti_name <- tools::file_path_sans_ext(qti_file)
    xml_file <- list.files(path = temp_folder, recursive = TRUE,
        pattern = paste0(qti_name, "_\\d+.xml"))[[1]] %>%
        paste0(temp_folder, "/", .)
    xml <- readLines(xml_file)

    # find the xml pieces that we want to cut out
    sec_beg <- grep("<section[^>]+title", xml)
    sec_obj <- grep("</selection_ordering", xml)
    sec_end <- grep("</section>", xml)

    # we still want to keep the last </section>
    last <- length(sec_end)
    sec_end <- sec_end[1:last - 1]

    # comment out all those <section> tags
    # NOTE: we still want to keep the last </section>
    xml[sec_beg] <- paste0("<!-- ", xml[sec_beg])
    xml[sec_obj] <- paste0(xml[sec_obj], " -->")
    xml[sec_end] <- paste0("<!-- ", xml[sec_end], " -->")

    # add a single root section at the start
    start <- sec_beg[[1]]
    xml <- c(
        xml[1:start - 1],
        "<section ident=\"root_section\">",
        xml[start:length(xml)]
    )

    # put together the code and send to the temp file
    xml <- paste(xml, sep = "\n", collapse = "\n")
    write(xml, xml_file)

    files <- list.files(temp_folder, recursive = TRUE)
    if (is.null(out_file))
        out_file <- paste0(qti_name, "_nosect.zip")

    owd <- getwd()
    setwd(temp_folder)
    zip(out_file, files)
    setwd(owd)
    file.copy(file.path(temp_folder, out_file), out_file)
}

#' Remove all sections from a pre-created QTI zip file.
#'
#' @param qti_file .zip file to edit
#' @param out_file .zip file to write to.
#'
#' @details
#' If `out_file` is not given, the default is the same as `qti_file`, but
#' with `_nosect` appended before the extension.
#'
#' @details
#' If `out_file` is given, it must end with the extension `.zip`.
#'
#' @details # Credits
#' Brighton Pauli, 2022
#'
#' @export

drop_sections <- function(qti_file, out_file = NULL) {
    temp_folder <- "temp"

    while (file.exists(temp_folder)) {
        temp_folder <- paste0("temp", as.character(sample(1:1e10, 1)))
    }

    unzip(qti_file, exdir = temp_folder)
    owd <- getwd()

    tryCatch(
        drop_sections_helper(qti_file, temp_folder, out_file = out_file),
        finally = {
            setwd(owd)
            unlink(temp_folder, recursive = TRUE)
        }
    )
}