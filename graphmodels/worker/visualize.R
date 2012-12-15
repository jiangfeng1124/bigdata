
suppressPackageStartupMessages(library(optparse))
library(igraph)

option_list <- list()
opt_parser <- OptionParser(option_list = option_list)
arguments <- parse_args(opt_parser, positional_arguments = TRUE)
args <- arguments$args

if(length(args) != 2) {
  cat("Missing arguments\n\n")
  print_help()
  stop()
} else {
  result_dir <- args[1]
  program_lang <- args[2]
}

if(program_lang == "R") {
  omega_path = paste(result_dir, "/omega.Rdata", sep = "")
  load(omega_path) 
  omega <- as.matrix(omega)
} else {
  omega_path = paste(result_dir, "/omega.txt", sep = "")
  omega <- as.matrix(read.table(omega_path))
}

dim <- ncol(omega)
vertex.size <- 200 / dim
# graph
plot_path <- paste(result_dir, "/graph.png", sep = "")
png(file = plot_path, width = 690, height = 460)
g <- graph.adjacency(as.matrix(omega), mode = "undirected", diag = FALSE)
layout.grid <- layout.fruchterman.reingold(g)
par(mfrow <- c(1, 1))
plot(g, layout = layout.grid, edge.color = 'gray50', vertex.color = "red", vertex.size = vertex.size, margin = 0, vertex.label = NA)
dev.off()
