suppressPackageStartupMessages(library(bigmatrix))

types <- c("hub", "scale-free", "cluster", "band", "random")

for(type in types) {
  L <- tiger.generator(n = 200, d = 50, graph = type, prob = 0.5)
  data <- as.matrix(L$data)
  file.name <- paste("sample-", type, ".csv", sep="")
  outfile <- file(file.name, open="wt")
  res <- lapply(1:nrow(data), function(i) writeLines(paste(data[i,], collapse="\t"), con=outfile))
  close(outfile)
}

