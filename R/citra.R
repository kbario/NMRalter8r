#' @title Citrate Area Estimation
#' @description Estimates the area of the citrate signal
#'
#' @details `citra()` finds the ppm values between the upper and lower bounds provided by the sh parameter.
#' Then it removes all values below the estimated noise level provided by `pproc()` to increase accuracy.
#' Finally the remaining values are summed and is the value returned by the function.
#'
#' @param x The spectrum of which you want to calculate the total area
#' @param p The matched ppm variable to x
#' @param n The noise estimation from the pproc
#' @param sh The ppm lower and upper limits defining the cirtate signal
#'
#' @return An estimated value of the citrate area
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(x,p,n)
#' cit <- citra(x, p, n)

citra <- function(x, p, n, sh = c(5.2,5.3)){
  b <- x[shift_pickr(x, p, sh, 0.005)]
  b[b<n]=0
  i <- get_idx(sh, p)
  j <- i[-(match(b,i))]
  s <- x[shift_pickr(x, p, j, 0.005)]
  s[s<n]=0
  sm <- sum(x[c(b, s)])
  return(sm)
}

