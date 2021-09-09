#' @title Creatinine Area Estimator
#' @description Estimates the area of the creatinine signal
#'
#' @details `crea()` finds the ppm values between the upper and lower bounds provided by the sh parameter.
#' Then it removes all values below the estimated noise level provided by `pproc()` to increase accuracy.
#' Finally the remaining values are summed and is the value returned by the function.
#'
#' @param x The spectrum of which you want to calculate the total area
#' @param p The matched ppm variable to x
#' @param n The noise estimation from the pproc
#' @param c3 The ppm lower and upper limits defining the creatinine signal at ppm 3
#' @param c4 The ppm lower and upper limits defining the creatinine signal at ppm 4
#'
#' @return An estimated value for the creatinine area
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(x,p,n)
#' cr <- crea(x, p, n)

crea <- function(x, p, n, c3 = c(3,3.1), c4 = c(4,4.1)){
  x3 <- x[shift_pickr(x, p, c3, 0.005)]
  #x3[x3<n]=0
  a3 <- sum(x3)
  #x4 <- x[shift_pickr(x, p, c4, 0.005)]
  #x4[x4<n]=0
  #a4 <- sum(x4)
  #a <- sum(a3, a4)
  #r <- a4/a3
  #er <- ((2/3)/100)*10
  #lo <- (2/3)-er
  #up <- (2/3)+er
  #e <- as.array(r<=up & r>=lo)
  return(a3)
}
