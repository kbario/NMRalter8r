gluca <- function(x, p, n, ta){
  xd <- x[1,get_idx(c(5.2,5.3), p)]
  xd[xd<n]=0
  ds <- sum(xd)

  xm <- x[1,get_idx(c(3.2,3.95), p)]
  xm[xm<n]=0
  ms <- sum(xm)

  r <- ms/ds

  if (r<18){
    #this doth not be glucose
    nta <- ta
  }
  if (r>1){
    #there are additional signals in the 3-4
    a <- ds*18.46
    nta <- ta-a
  }
  return(nta)
}



