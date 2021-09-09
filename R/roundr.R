#' @title Round to a Multiple of 4
#' @description This function rounds the given value n to the nearest value created by r2.
#'
#' @details `roundr()` works by creating an array and finding which number n is closest to.
#' r2 contains all the input arguments for the `seq()` function (being the min, max and step args) which are then parsed to `seq()` to create an array of values.
#' `roundr()` then takes the number to be round: n, and finds the minimum absolute difference between it and all values in the sequence created by r2.
#' Finally the number in the array closest to n is returned as the 'rounded' value.
#'
#' @param n The number you want to round
#' @param r2 Encodes the values plugged into the `seq()` function with the elements being:
#' 1. The minimum value to be rounded to
#' 2. The maximum value to be rounded to, and
#' 3. The step/multiple to be incremented by. Ideally, 1 and 2 should be a multiple of 3
#'
#' @return A integer rounded to the nearest multiple of the third element in r2
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' ns <- roundr(n = 37, r2 = c(4,256,4))

roundr <- function(n, r2 = c(4, 512, 4)){
  sq <- seq(r2[1], r2[2], r2[3])
  sq[which.min(abs(sq-n))]
}
