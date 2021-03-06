% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.lmmsde-method.R
\name{plot.lmmsde}
\alias{plot.lmmsde}
\title{Plot of \code{lmmsde} objects}
\usage{
\method{plot}{lmmsde}(x, y, data, time, group, type, smooth, mean, ...)
}
\arguments{
\item{x}{An object of class \code{lmmsde}.}

\item{y}{\code{numeric} or \code{character} value. Either the row index or the row name determining which feature should be plotted.}

\item{data}{alternative \code{matrix} or \code{data.frame} containing the original data for visualisation purposes.}

\item{time}{alternative \code{numeric} indicating the sample time point. Vector of same length as row lenghth of data for visualisation purposes.}

\item{group}{alternative \code{numeric} indicating the sample group. Vector of same length as row length of data for visualisation purposes.}

\item{type}{a \code{character} indicating what model to plot. Default  \code{'all'}, options: \code{'time'}, \code{'group'},\code{'group*time'}.}

\item{smooth}{an optional \code{logical} value. By default set to \code{FALSE}. If \code{TRUE} smooth representation of the fitted values.}

\item{mean}{alternative \code{logical} if the mean should be displayed.  By default set to \code{TRUE}.}

\item{\ldots}{Additional arguments which are passed to \code{plot}.}
}
\value{
plot showing raw data, mean profile and fitted profile.
}
\description{
Plot of the raw data the mean and the fitted \code{lmmsde} profile.
}
\examples{
\dontrun{
data(kidneySimTimeGroup)
lmmsDEtestl1 <-lmmsDE(data=kidneySimTimeGroup$data,time=kidneySimTimeGroup$time,
                sampleID=kidneySimTimeGroup$sampleID,
                group=kidneySimTimeGroup$group,
                experiment="longitudinal1",basis="p-spline",keepModels=T) 
plot(lmmsDEtestl1,y=2,type="all")
plot(lmmsDEtestl1,y=2,type="time")
plot(lmmsDEtestl1,y=2,type="group")
plot(lmmsDEtestl1,y=2,type="group*time",smooth=TRUE)

#to save memory do not keep the models
lmmsDEtestl1 <-lmmsDE(data=kidneySimTimeGroup$data,time=kidneySimTimeGroup$time,
                sampleID=kidneySimTimeGroup$sampleID,
                group=kidneySimTimeGroup$group,
                experiment="longitudinal1",basis="p-spline",keepModels=F) 
# just the fitted trajectory                 
plot(lmmsDEtestl1,y=2,type="all")

plot(lmmsDEtestl1,y=2,type="all",data=kidneySimTimeGroup$data,time=kidneySimTimeGroup$time,
group=kidneySimTimeGroup$group)}  
}

