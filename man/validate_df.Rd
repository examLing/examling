% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validate_df.R
\name{validate_df}
\alias{validate_df}
\title{Check a dataframe for issues.}
\usage{
validate_df(df)
}
\arguments{
\item{df}{Dataframe to validate.}
}
\description{
Ensure that a dataframe conforms to examling standards,
stopping otherwise.
}
\section{Requirements}{
The dataframe must have the following columns:
\itemize{
\item Question
\item Type
\item Correct
\item Category
}

Previously, the Image column was also required. Now, if there is no Image
column, an empty one is added.

All columns must be plain text.

There must be at least one answer column.

For common errors, see the following vignette:

\code{vignette("spreadsheet-validation", package = "examling")}
}

\section{Credits}{
Brighton Pauli, 2022.
}

