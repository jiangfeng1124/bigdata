# This is to apply correlation screening algorithm
# to estimate a inverse covariance matrix
# Arguments:
# 1. data_path
# 2. result_dir

suppressPackageStartupMessages(library(optparse))

#### parse the options and arguments ####
option_list <- list(make_option(c("-l", "--lambda"), type="double", dest="lambda",
                                help="parameter to control the regularization"))
opt_parser <- OptionParser(option_list = option_list)
arguments <- parse_args(opt_parser, positional_arguments = TRUE)

options <- arguments$options
args <- arguments$args

#### validate the arguments ####
print(length(args))
if(length(args) != 4) {
  cat("Incorrect number of required positional arguments\n\n")
  print_help(opt_parser)
  stop()
} else {
  data_sep = args[1]
  data_header = args[2]
  data_path <- args[3]
  icov_path <- args[4]
}

suppressPackageStartupMessages(library(bigmatrix))

#### read the dataset ####
tbl_separator = c("tab"="\t", "comma"=",", "semicolon"=";", "space"=" ")
sep = tbl_separator[data_sep]
tbl_header = c("0"=FALSE, "1"=TRUE)
header = tbl_header[data_header]

usr_data <- as.matrix(read.table(data_path, sep=sep, header=header))
dim <- ncol(usr_data)

if(length(options) != 2) {
  output <- tiger(usr_data, method="clime", standardize=TRUE)
  index <- which(output$sparsity >= 0.02)[1]
  if(is.na(index))
    index <- length(output$path)
  cat("index: ", index, "\n")
  icov <- output$icov[[index]]
} else {
  output <- tiger(usr_data, method="clime", standardize=TRUE, lambda=options$lambda)
  icov <- output$icov[[1]]
}

#### screening the correlation matrix ####
icov <- as.matrix(icov)
if(header){
  write(t(colnames(usr_data)), file = icov_path, ncolumns = ncol(icov))
  write(t(icov), file = icov_path, append=TRUE, ncolumns = ncol(icov))
} else {
  write(t(icov), file = icov_path, ncolumns = ncol(icov))
}
