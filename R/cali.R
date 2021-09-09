#' @title NMR spectral TSP calibration
#' @description This function shifts the x varibale left or right so that it's TSP peak sits at 0 ppm.
#'
#' @details `cali()` finds how far away the maximum value of of x between -0.2 and 0.2 is from the ppm variable closest to 0.
#' It then adds and subtracts the appropriate amount of values on either end of the spectrum so that x's TSP peak resides at 0.
#'
#' @param x The spectrum you want to calibrate as an array
#' @param p The matched ppm variable to the x you want to calibrate
#'
#' @return A spectrum that is calibrated to tsp
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' xc <- cali(x, p)

cali <- function(x, p){
  if (!is.null(dim(x))){
    stop('This function is intended to only calibrate a single spectra')
  }
  i <- get_idx(c(-.2,.2), p)
  d <- (which.min(abs(p)))-(which(p==p[i][which.max(x[i])]))
  si <- sign(d)
  dif <- abs(d)
  if (si==-1){
    x <- x[-(1:dif)]
    x <- c(x, rep(0, dif))
  }
  if (si==1){
    x <- x[-((length(x)-dif+1):length(x))]
    x <- c(rep(0, dif), x)
  }
  return(x)
}
