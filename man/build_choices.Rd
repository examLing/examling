% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build_choices.r
\name{build_choices}
\alias{build_choices}
\title{Choose correct and incorrect answers.}
\usage{
build_choices(question_row, nchoices, ncorrect = 1)
}
\arguments{
\item{question_row}{Single row of data. See \code{build_question_df()}.}

\item{nchoices}{Total number of choices to give students.}

\item{ncorrect}{Number of choices that are correct (default: 1).
0 <= \code{ncorrect} <= \code{nchoices}}
}
\value{
Named list with two string values:
\enumerate{
\item \code{answerlist}: Bulleted list with all possible choices.
\item \code{exsolution}: Binary representation of the correct answer(s).
}
}
\description{
Choose correct and incorrect answers and format them for
\code{r/exams} files.
}
\section{N Correct}{
By default, \code{ncorrect} is set to 1. A warning will be thrown if \code{ncorrect}
is greater than \code{nchoices}.

To have a random number of correct answers, set \code{ncorrect} to \code{NA},
\code{"random"}, or a vector of two numbers. \code{NA} and \code{random} will set
\code{ncorrect} to a random number between 1 and \code{ncorrect}, inclusively.
Providing a vector of two numbers will set \code{ncorrect} to a random number
between those two numbers, inclusively.
}

\section{Credits}{
Brighton Pauli, 2023
}

\seealso{
\link{build_question_df}
}
