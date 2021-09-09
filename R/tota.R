#' @title Total Area Estimation
#' @description This function gets all values that reside within the given upper and lower bounds of an x variable and sums them to give a reasonably accurate estimation of the total area of the spectrum
#'
#' @details `tota()` finds the ppm values between the upper and lower bounds provided by the sh parameter.
#' Then it removes all values below the estimated noise level provided by `pproc()` to increase accuracy.
#' Finally the remaining values are summed and is the value returned by the function.
#'
#' @param x The spectrum of which you want to calculate the total area
#' @param p The matched ppm variable to x
#' @param n The noise estimation from the pproc
#' @param sh The chemical shift of the region you want to calculate total area of
#'
#' @return A value of the total area estimation
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(x,p,n)
#' ta <- tota(x, p, n)

tota <- function(x, p, n, sh = c(0.25,9.5)){
  xt <- x[get_idx(sh, p)]
  xt[xt<n]=0
  s <- sum(xt)
  return(s)
}
