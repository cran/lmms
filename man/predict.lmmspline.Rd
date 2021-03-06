% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.lmmspline-method.R
\name{predict.lmmspline}
\alias{predict.lmmspline}
\title{Predicts fitted values of an \code{lmmspline} Object}
\usage{
\method{predict}{lmmspline}(object, timePredict, numCores, ...)
}
\arguments{
\item{object}{an object inheriting from class \code{lmmspline}.}

\item{timePredict}{an optional \code{numeric} vector. Vector of time points to predict fitted values. If \code{missing} uses design points.}

\item{numCores}{alternative \code{numeric} value indicating the number of CPU cores to be used for parallelization. By default estimated automatically.}

\item{...}{ignored.}
}
\value{
\code{matrix} containing predicted values for the requested time points from argument \code{timePredict}.
}
\description{
Predicts the fitted values of an \code{lmmspline} object for time points of interest.
}
\examples{
\dontrun{
data(kidneySimTimeGroup)
G1 <- which(kidneySimTimeGroup$group=="G1")
testLMMSpline<- lmmSpline(data=kidneySimTimeGroup$data[G1,],
                 time=kidneySimTimeGroup$time[G1],
                 sampleID=kidneySimTimeGroup$sampleID[G1],keepModels=T)
mat.predict <- predict(testLMMSpline, timePredict=c(seq(1,4, by=0.5)))}
}

