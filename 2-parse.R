library(stringr)
# Parse DESCRIPTION into convenient format
read.description <- function(file) {
  dcf <- read.dcf(file)
  
  dcf_list <- setNames(as.list(dcf[1, ]), colnames(dcf))
  lapply(dcf_list, str_trim)
}

paths <- dir("cache", full.name = TRUE)
descs <- lapply(paths, plyr::failwith(NULL, read.description))

failed <- vapply(descs, is.null, logical(1))
paths[failed]
# [1] "cache/ellipse_0.0.1.dcf"   "cache/ellipse_0.1-1.dcf"  
# [3] "cache/ellipse_0.2-1.dcf"   "cache/multilm_0.1-3.dcf"  
# [5] "cache/multilm_0.1-4.dcf"   "cache/multilm_0.1.dcf"    
# [7] "cache/npConfRatio_1.0.dcf"

descs <- plyr::compact(descs)

saveRDS(descs, "all.rds")
