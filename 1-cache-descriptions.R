# Download and cache all descriptions locally

local <- dir("cache")
packages <- read.csv("packages.csv", stringsAsFactors = FALSE)
missing <- packages[!(packages$desc %in% local), ]

cache_description <- function(src, desc, repo = "http://cran.rstudio.com") {
  message("Caching ", desc)
  t1 <- tempfile()
  on.exit(unlink(t1))
  
  src_url <- file.path(contrib.url(repo, "source"), src)
  download.file(src_url, t1, quiet = TRUE)
  
  ls <- untar(t1, list = TRUE)
  description <- ls[basename(ls) == "DESCRIPTION"]
  if (length(description) == 0) stop("No DESCRIPTION")
  if (length(description) > 1) {
    description <- description[which.min(nchar(description))]
    message("Mutliple descriptions: using ", description) 
  }
  
  untar(t1, files = description, exdir = tempdir())
  file.copy(file.path(tempdir(), description), file.path("cache", desc))
}

Map(function(...) try(cache_description(...)), missing$src, missing$desc)
