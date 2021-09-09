#' @title Spectral Preprocessing
#' @description `pproc()` streamlines the processing of NMR spectra by combining functions of NMRadjustr in the appropriate order to return the cleanest spectrum possible with the least amount of fuss.
#'
#' @details `pproc()` only takes one spectrum at a time due to the nature of NMRadjustr's purpose.
#' It begins be ensuring the spectrum is orientated the right way. Often spectra acquired with a small number of scans are incorrectly orientated because the water signal towers over all other signals.
#' From there, the spectra are calibrated so that the peak of the TSP signal is at a ppm of 0.
#' The lower ppm, water and urea regions are then removed, leaving the upper ppm region for a noise estimation.
#' Baseline correction using asymmetric least squares is performed and a noise estimation between the region of 9.5/11 is done before the upper ppm region is removed.
#' Finally, the processed x spectrum, matched ppm variable, original spectrum and noise estimation are then assigned to the global environment overwriting the existing varibales.
#'
#' @param x The spectra that you are processing
#' @param p The ppm matched to your spectra
#'
#' @return This function returns:
#' 1. **x**: a fully preprocessed spectrum ready for it's dilution to be estimated
#' 2. **p**: the matched ppm variable for the preprocessed x
#' 3. **o**: the original X spectra that was input into the function
#' 4. **n**: the estimated value of noise for this spectrum
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' pproc(x, p)

pproc <- function(x, p){
  xf <- flip_(x, p, c(3,3.1))
  x_og <- xf
  xc <- cali(xf, p)
  xr <- xc[-c(get_idx(c(min(p), 0.25), p), get_idx(c(4.6,4.9), p), get_idx(c(5.55,6), p))]
  pn <- p[-c(get_idx(c(min(p), 0.25), p), get_idx(c(4.6,4.9), p), get_idx(c(5.55,6), p), get_idx(c(9.5,max(p)), p))]
  xb <- bl_(xr)
  n <- noi_(xb,p)
  xg <- xb[-get_idx(c(9.5,max(p)), p)]
  assign('x', xg, envir = .GlobalEnv)
  assign('p', pn, envir = .GlobalEnv)
  assign('o', x_og, envir = .GlobalEnv)
  assign('n', n, envir = .GlobalEnv)
}
