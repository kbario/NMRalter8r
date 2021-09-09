#' @title Get ppm indexes
#' @description `get_idx()` finds which ppm elements are within certain bounds provided in the argument 'r'.
#'
#' @details The ppm variable matched to a spectrum indicates at what frequency the peak resides. To look at x values between certain frequencies, ask `get_idx()` to find what columns of x are between the frequency values.
#' For instance, to find the values of creatinine (which resides between ppm 3 and 3.1) in your x variable, input 3 and 3.1 into `get_idx()` and provide the ppm variable p.
#' From there, `get_idx()` asks what ppm values are both above the lower ppm of 3 and below the upper ppm of 3.1. These ppm values are then returned as the output of `get_idx()`.
#'
#' @param r the lower and upper bounds of the ppm region you wish to find the indexes of
#' @param p the ppm variable you want to find the indexes of
#' @author Torben Kimhofer \email{torben.kimhofer@@murdoch.edu.au}
#' @return An array containing the indexes between the lower and upper bounds
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(p)
#' idx <- get_idx(r = c(3,3.1), p)

get_idx <- function (r, p){
  if (length(r)>2){stop('Too many values provided. Only 2 values accepted')}
  r <- sort(r, decreasing = TRUE)
  which(p <= r[1] & p >= r[2])
}
