#' @title Chemical Shift Picking
#' @description `shift_pickr()` is programmed to search a given ppm region for a maximum value (i.e., the apex of a metabolite peak) and return the chemical shift that best encapsulates said peak. Is most useful when picking peaks to estimate their area.
#'
#' @details `shift_pickr()` takes chemical shift region in the **sh** parameter and searches for the largest value in x in that chemical shift.
#' From there, the value of pm is added and subtracted from the ppm where the maximum x values resides to give a shift that best encapsulates the peak which is then returned by the function.
#'
#' @param x The spectrum of which you want to calculate the total area
#' @param p The matched ppm variable to x
#' @param sh Takes arrangements of values:
#' 1. The first is two values where the first is the lower ppm value and the second is the upper ppm value. This is then parsed to `get_idx()` to find the idx which is then parsed to the x variable.
#' 2. The second arrangement is an array of numbers that are interpreted as the already calculated idx values and are parse straight to the x variable
#' @param pm The plus/minus value you want to add or subtract from the peak. Default = 0.005
#'
#' @return An array of values mapped to defined peak
#' @export
#'
#' @author Kyle Bario \email{kylebario1@@gmail.com}
#'
#' @examples
#' data(x,p)
#' idx <- shift_pickr(x, p, sh = c(5,5.5), pm = 0.01)

shift_pickr <- function(x, p, sh, pm = 0.005){
  if (length(sh)>2){
    i <- sh
  } else {
    i <- get_idx(sh, p)
  }
  m <- unname(which(x==max(x[i])))
  s <- get_idx(c(p[m]-pm,p[m]+pm), p)
  return(s)
}
