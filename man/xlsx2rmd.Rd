% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xlsx2rmd.R
\name{xlsx2rmd}
\alias{xlsx2rmd}
\title{Import questions from an Excel sheet.}
\usage{
xlsx2rmd(x, output_dir, ..., sheet = 1, log_file = NA, url = NA)
}
\arguments{
\item{x}{Filepath to xlsx file.}

\item{output_dir}{Directory to write Rmd files to.}

\item{...}{Additional arguments for openxlsx::loadWorkbook.}

\item{sheet}{Index or name of sheet that contains questions.}

\item{log_file}{Directory to write log files to.}

\item{url}{For internal use only.}
}
\description{
Convert an xlsx spreadsheet of questions into r/exams-style
Rmd files.
}
\details{
The image is imported from the xlsx file and saved in the 'img' directory
with the same name as the question's generated ID.
}
\section{xlsx format}{
The xlsx file should have the following columns:
\itemize{
\item Question: the question text
\item Image: the image file
\item Type: "schoice", "mchoice", or "string"
\item Ans1: the answer text for the first answer
\item Ans2: the answer text for the second answer
\item Ans3: the answer text for the third answer
\item Ans4: the answer text for the fourth answer
\item Ans5: the answer text for the fifth answer
\item Correct: the correct answer number (1-5)
\item Category: the category of the question
\item SubCat: the subcategory of the question
}
}

\section{Credits}{
Brighton Pauli, 2022.
}

\seealso{
\link{csv2rmd}
}
