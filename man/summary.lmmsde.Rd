% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.lmmsde-methods.R
\name{summary.lmmsde}
\alias{summary.lmmsde}
\title{Summary of a \code{lmmsde} Object}
\usage{
\method{summary}{lmmsde}(object, ...)
}
\arguments{
\item{object}{An object of class \code{lmmsde} .}

\item{...}{Additional arguments which are passed to \code{summary}.}
}
\value{
summary of the \code{lmmsde} object.
}
\description{
Summarizes the \code{lmmsde} object returned by the \code{\link{lmmsDE}} method. Including the models fitted, parameter used and the number of features declared as differentially expressed.
}
\examples{
\dontrun{
data(kidneySimTimeGroup) 
lmmsDEtest <-lmmsDE(data=kidneySimTimeGroup$data,time=kidneySimTimeGroup$time,
             sampleID=kidneySimTimeGroup$sampleID,group=kidneySimTimeGroup$group)
summary(lmmsDEtest)}
}

