#' @title Spectral Flipping
#' @description `flip_()` re-orientates/flips the spectrum on the x axis so that the peaks are pointing the correct way.
#'
#' @details `flip_()` looks at the chemical shift provided by the sh variable and sums the x values in that area.
#' It then determines if the sum of this area has a positive or negative sign (indicating if in that area, the peak is pointing in the positive or negative direction). If it is in the negative direction, the entire spectrum is mulitplied by -1 and returned.
#'
#' @param x the spectra wanting to be flipped
#' @param p the match ppm variable
#' @param sh the chemical shift used to calculate orientation given as the upper and lower ppm bounds
#'
#' @return Returns a spectrum (array) with the correct orientation
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' xf <- flip_(x, p, sh = c(3,3.1))

flip_ <- function(x, p, sh){
  s = sum(x[get_idx(sh, p)])
  if (s<=0){
    x <- x*-1
  }
  return(x)
}
