#' @title Noise Estimation
#' @description This function estimates the noise of an NMR spectrum through the analysis of the upper end of the spectrum.
#'
#' @details Noise in an NMR spectrum is inevitable and a product of the detectors in the spectrometer. But noise only introduces error to spectral analysis so removing values below the noise threshold makes data analysis on spectra more robust.
#' `noi_()` gets the index of the ppm between 9.5 and 11 and calculates the trimmed mean and the standard deviation of the x values within this chemical shift.
#' From there, the standard deviation is multiplied by 5 and the mean is add to provide a maximum estimation of noise in that spectrum.
#' This method was developed from the paper by Torgrip et al. (2008) and can be found in the link in see also.
#'
#' @param x The read in spectra
#' @param p the matched ppm var to your x
#'
#' @return an estimation of noise level of the provided x spectrum
#' @importFrom stats sd
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @seealso The methods paper by Torgrip et al. (2008): \url{http://dx.doi.org/10.1007/s11306-007-0102-2}
#'
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' n <- noi_(x, p)

noi_ <- function(x, p){
  rm <- 5*sd(x[get_idx(c(9.5,11), p)])+(mean((x[get_idx(c(9.5,11), p)]), trim = 0.05))
  return(rm)
}
