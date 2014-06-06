# Jasmin Straube, Queensland Facility of Advanced Bioinformatics
# Part of this script was borrowed from parallel and snow package.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Moleculesral Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Moleculesral Public License for more details.
#
# You should have received a copy of the GNU Moleculesral Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#' Derivative information for \code{lmmspline} objects
#' 
#' Calculates the derivative information for \code{lmmspline} objects with a \code{"p-spline"} or \code{"cubic p-spline"} basis.
#' 
#' @import parallel 
#' @importFrom stats deriv
#' @param expr An object of class \code{lmmspline}.
#' @param numCores alternative \code{numeric} value indicating the number of CPU cores to be used for parallelization. Default value is automatically estimated.
#' @param ... Additional arguments which are passed to \code{deriv}.
#' @return deriv returns an object of class \code{lmmspline} containing the following components:
#' \item{predSpline}{ \code{data.frame} containing the predicted derivative values based on the linear model object or the linear mixed effect model object.}
#' \item{modelsUsed}{\code{numeric} vector indicating the model used to fit the data. 0 = linear model, 1 = linear mixed effect model spline (LMMS) with defined basis ("cubic" by default), 2 = LMMS taking subject-specific random intercept, 3 = LMMS with subject specific intercept and slope.}
#' \item{model}{\code{list} of models used to model time profiles.}
#' \item{derivative}{\code{logical} value indicating if the predicted values are the derivative information.}
#' @examples
#' \dontrun{
#' data(kidneySimTimeGroup)
#' # run lmmSpline on the samples from group 1 only
#' G1 <- which(kidneySimTimeGroup$group=="G1")
#' testLMMSplineTG<- lmmSpline(data=kidneySimTimeGroup$data[G1,],
#'                   time=kidneySimTimeGroup$time[G1],
#'                   sampleID=kidneySimTimeGroup$sampleID[G1],
#'                   basis="p-spline")
#' testLMMSplineTGDeri <- deriv(testLMMSplineTG)
#' summary(testLMMSplineTGDeri)}

#' @export
deriv.lmmspline <- function(expr, numCores, ...){

models <- expr@models
basis <- expr@basis
if(missing(numCores)){
  num.Cores <- detectCores()
}else{
  num.Cores <- detectCores()
  if(num.Cores<numCores){
    warning(paste('The number of cores is bigger than the number of detected cores. Using the number of detected cores',num.Cores,'instead.'))
  }else{
    num.Cores <- numCores
  }
  
}

if(sum(expr@basis%in%c('p-spline','cubic p-spline'))==0)
  stop('Objects must be modelled with p-spline or cubic p-spline basis.')


derivLme <- function(fit){ 
  #random slopes
  
  if(class(fit)=='lm'){
    beta.hat <- rep(fit$coefficients[2],length(unique(fit$model$time)))
    return(beta.hat)
    
  }else if(class(fit)=='lme'){
    u <- unlist(fit$coefficients$random$all)
    beta.hat <- fit$coefficients$fixed[2]
    Zt <-  fit$data$Zt[!duplicated(fit$data$Zt),]>0
    deriv.all <-    beta.hat + rowSums(Zt%*%t(u)) 
    return(deriv.all)
  }
}

#penalized cubic

derivLmeCubic <- function(fit){ 
  #random slopes
  if(class(fit)=='lm'){
    beta.hat <- rep(fit$coefficients[2],length(unique(fit$model$time)))
    return(beta.hat)
    
  }else if(class(fit)=='lme'){
    u <- unlist(fit$coefficients$random$all)
    beta.hat <- fit$coefficients$fixed[2]
    PZ <-  fit$data$Zt[!duplicated(fit$data$Zt),]
    PZ <-PZ^(1/3)
    deriv.all <-    beta.hat + rowSums((PZ*PZ)%*%(t(u)*3)) 
    return(deriv.all)
  }
  
}

cl <- makeCluster(num.Cores,"SOCK")
deri <- NULL
clusterExport(cl, list('models','basis','deri','derivLme','derivLmeCubic'),envir=environment())

new.data <- parLapply(cl,1:length(models),fun = function(i){
  if(basis=='p-spline')
    deri <- derivLme(models[[i]])
  if(basis=='cubic p-spline')
    deri <- derivLmeCubic(models[[i]])
  return(deri)
})

stopCluster(cl)
deri <- as.data.frame(matrix(unlist(new.data),nrow=length(models),ncol=length(unique(expr@data$time)),byrow=T))
rownames(deri) <- rownames(expr@predSpline)
colnames(deri) <- unique(expr@data$time)
expr@predSpline <- deri
expr@derivative <- TRUE
return(expr)
}