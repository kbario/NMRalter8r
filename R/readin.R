#' @title Import 1D NMR spectra
#' @details This function imports TopSpin processed NMR spectra as well as spectrometer and processing parameters found in files \emph{acqus} and \emph{procs}. Experiments can be filtered according to data acquisition variables using the \code{exp_type} argument: For example, to read standard 1D NMR experiments use \code{exp_type=list(exp='noesygppr1d')}. More than one argument can be provided as list element. **Objects in the R environment with the same variable names will be overwritten.**
#' @param path Given as a string, the path to the overarching files containing the NMR spectrum.
#' @return
#' The function exports the following three objects into the currently active R environment (no variable assignments needed):
#' 1. **x**: The NMR spectrum in an array of values matched to p
#' 2. **p**: The column-matched ppm array of the x variable
#' 3. **m**: The spectrometer metadata as extracted from the \emph{acqus} file, row-matched to x
#' @export
#' @author Torben Kimhofer \email{torben.kimhofer@@murdoch.edu.au}
#' @examples
#' readin(path = system.file('extdata/15', package = 'NMRadjustr'))
#' @section

readin <- function(path) {
  path = gsub(paste0(.Platform$file.sep, "$"), '', path)
  ff<-list.files(path = paste(path, 'pdata', '1', sep=.Platform$file.sep), pattern = "^1r$", all.files = FALSE, full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
  if( length(ff) == 1 ) {
    f_list=list(list(f_procs=paste(path, 'pdata', '1', 'procs', sep=.Platform$file.sep), f_acqus=paste(path, 'acqus', sep=.Platform$file.sep)))
    # meta<-.self$.extract_pars1d(f_list)
    meta<-extract_pars1d_(f_list)
    endianness<-ifelse(meta$p_BYTORDP!=0, 'big', 'little')
    spec <- readBin(ff, what = "int", n = meta$p_FTSIZE, size = 4, signed = T, endian = endianness)
    spec <- ((2^meta$p_NC_proc) * spec)
    swp <-  meta$p_SW_p/meta$p_SF
    dppm <- swp/(length(spec) - 1)
    offset <- meta$p_OFFSET
    ppm <- seq(from = offset, to = (offset - swp), by = -dppm)
    assign("x", spec, envir = .GlobalEnv)
    assign("p", ppm, envir = .GlobalEnv)
    assign("m", meta, envir = .GlobalEnv)
  }else{
    return(NULL)
  }
}

#' @title Read Bruker NMR paramter files - helper function read1d
#' @param f_list list, intact files system for NMR experiments. See fct checkFiles1d
#' @return data frame of spectrometer acquisition metadata
#' @author \email{torben.kimhofer@@murdoch.edu.au}
#' @section

extract_pars1d_ <- function(f_list) {
  out <- lapply(seq(length(f_list)), function(i) {

    f_procs <- f_list[[i]]$f_procs[i]
    fhand <- file(f_procs, open = "r")
    f_procs <- readLines(fhand, n = -1, warn = FALSE)
    close(fhand)

    idx <- grep("..", f_procs, fixed = TRUE)
    f_procs[idx] <- vapply(idx, function(i) {
      gsub(" .*", f_procs[i + 1], f_procs[i])
    }, FUN.VALUE = "")
    out <- strsplit(gsub("^##\\$", "", grep("^##\\$", f_procs, value = TRUE, fixed = FALSE), fixed = FALSE), "=")
    d_procs_val <- gsub("^ ", "", vapply(out, "[[", 2, FUN.VALUE = ""))
    names(d_procs_val) <- paste0("p_", vapply(out, "[[", 1, FUN.VALUE = ""))

    f_acqu <- f_list[[i]]$f_acqus[i]
    # extract procs information for t2
    fhand <- file(f_acqu, open = "r")
    f_acqu <- readLines(fhand, n = -1, warn = FALSE)
    close(fhand)

    idx <- grep("..", f_acqu, fixed = TRUE)
    f_acqu[idx] <- vapply(idx, function(i) {
      gsub(" .*", f_acqu[i + 1], f_acqu[i])
    }, FUN.VALUE = "")

    out <- strsplit(gsub("^##\\$", "", grep("^##\\$", f_acqu, value = TRUE, fixed = FALSE), fixed = FALSE), "=")
    d_acqu_val <- gsub("^ ", "", vapply(out, "[[", 2, FUN.VALUE = ""))
    names(d_acqu_val) <- paste0("a_", vapply(out, "[[", 1, FUN.VALUE = ""))

    idx <- grep("date", names(d_acqu_val), ignore.case = TRUE)
    d_acqu_val[idx] <- as.character(as.POSIXct(x = "01/01/1970 00:00:00", format = "%d/%m/%Y %H:%M:%S") +
                                      (as.numeric(d_acqu_val[idx])))
    pars <- c(d_acqu_val, d_procs_val)
    return(pars)
  })

  out_le <- vapply(out, length, FUN.VALUE = 1)
  if (length(unique(out_le)) > 1) {
    cnam <- unique(as.vector(vapply(out, names, FUN.VALUE = out[[1]])))
    out_df <- matrix(NA, nrow = 1, ncol = length(cnam))
    out <- as.data.frame(t(vapply(out, function(x, odf = out_df, cc = cnam) {
      odf[1, match(names(x), cnam)] <- x
      return(odf)
    }, FUN.VALUE = out[[1]])))
    colnames(out) <- cnam
  }

  if (is.list(out)) {
    out <- do.call(rbind, out)
  }
  if (nrow(out) != length(f_list)) {
    out <- t(out)
  }
  dtype_num <- apply(out, 2, function(x) {
    !any(is.na(suppressWarnings(as.numeric(x))))
  })
  out <- as.data.frame(out)
  out[, dtype_num] <- apply(out[, dtype_num], 2, as.numeric)
  return(out)
}
