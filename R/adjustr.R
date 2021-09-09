#' @title NMR Number of Scans Estimator
#' @description `alter8r()` is the keystone function that the package is based on. It takes the input values of what an NMR spectrum's signal and noise values are and how many scans it took to produce them and returns the number of scans need to be performed by an NMR to produce the desired signal to noise ratio as defined in the goal arg.
#'
#' @details The signal to noise ratio of an NMR spectrum shows how large the signal is compared to that of the noise. Adjusting the number of done by an NMR spectrometer can allow you to alter this signal to noise ratio.
#' The relationship between number of scans and signal to noise ratio is based around a square root so if one wants to increase the the signal to noise ratio by a factor of two, they must increase the number of scans by a factor of 4.
#' `alter8r()` takes this relationship into account to calculate the number of scans needed to be performed on a sample to produce a spectrum with a certain signal to noise and is the value returned by the function.
#'
#' @param sig The signal
#' @param noi The noise
#' @param goal The target signal to noise
#' @param ns The number of scans used to create the provided signal and noise values
#' @param r2 Arguments passed to embedded roundr function. See roundr help for details.
#'
#' @return The number of scans (rounded based on the input arguments from r2) necessary to achieve the goal signal to noise
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(x,m,n)
#' cr <- crea(x, p, n)
#' ns <- alter8r(cr, n, 40000, m$a_NS, c(4,512,2))
#' cat(ns)

alter8r <- function(sig, noi, goal, ns, r2){
  roundr(((goal/(sig/noi))^2)*ns, r2)
}
