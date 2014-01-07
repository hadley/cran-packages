library(dplyr)
library(ggplot2)

descs <- readRDS("all.rds")

names <- tbl_df(data.frame(
  name = unlist(lapply(descs, names))
))
names %.% group_by(name) %.% tally() %.% arrange(desc(n)) %.% head(20)


df <- data.frame(
  package = sapply(descs, "[[", "Package"),
  version = sapply(descs, "[[", "Version"),
  date = sapply(descs, "[[", "Date"),
  published = sapply(descs, "[[", "Date/Publication")
)

vars <- c("Package", "Version", "Date", "Date/Published", "Packaged")
important <- lapply(descs, function(df) df[intersect(names(df), vars)])

all_df <- rbind_all(important)
