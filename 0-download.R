# Get list of all source packages available on CRAN. 
# ~1 MB download
src_paths <- function(repo = "http://cran.rstudio.com") {
  t1 <- tempfile()
  t2 <- tempfile()
  
  base_url <- contrib.url(repo, "source")
  download.file(file.path(base_url, "Meta", "current.rds"), t1, quiet = TRUE)
  download.file(file.path(base_url, "Meta", "archive.rds"), t2, quiet = TRUE)
  
  current <- readRDS(t1)
  archive <- readRDS(t2)

  c(
    paste0("Archive/", unlist(lapply(archive, rownames), use.names = FALSE)),
    rownames(current)
  )
}

# Return a data frame with nicely parsed package info
src_packages <- function(repo = "http://cran.rstudio.com") {
  paths <- src_paths()
  pkg_ver <- gsub("\\.tar\\.gz$", "", basename(paths))
  pieces <- strsplit(pkg_ver, "_", fixed = TRUE)
  pkg <- vapply(pieces, "[[", 1, FUN.VALUE = character(1))
  ver <- vapply(pieces, "[[", 2, FUN.VALUE = character(1))
  
  pkgs <- data.frame(
    pkg = pkg, 
    ver = ver, 
    src = paths, 
    desc = paste0(pkg_ver, ".dcf"),
    stringsAsFactors = FALSE
  )
  pkgs <- pkgs[order(pkgs$pkg), ]
  rownames(pkgs) <- NULL
  pkgs
}

packages <- src_packages()
write.csv(packages, "packages.csv", row.names = FALSE)
