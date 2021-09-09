#' @title Baseline Correction
#' @description `bl_()` removes the arched baseline from an NMR spectrum making the analysis more robust
#'
#' @details NMR spectra often have broad signals produced by proteins within a sample that span a large portion of the ppm axis. These broad signals interfere with the analysis of specific peaks. By removing it, the anaylsis is more robust.
#' This is achieved by calculating the trend of the spectrum using `ptw::asysm()` and then subtracts that from the spectrum's values.
#'
#' @param x the spectrum to be baseline corrected
#'
#' @return an x with a corrected baseline
#' @importFrom ptw asysm
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' xb <- bl_(x)

bl_ <- function(x){
  if (any(is.na(x))){
    x[is.na(x)]=0
  }
  xb <- x-asysm(x, maxit = 30, lambda = 1e+07)
  return(xb)
}
