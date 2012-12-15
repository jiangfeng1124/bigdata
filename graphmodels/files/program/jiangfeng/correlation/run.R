# This is to apply correlation screening algorithm
# to estimate a inverse covariance matrix
# Arguments:
# 1. data_path
# 2. result_dir

suppressPackageStartupMessages(library(optparse))

#### parse the options and arguments ####
option_list <- list(make_option(c("-t", "--thresh"), type="double", dest="threshold",
                                help="threshold for screening the correlation matrix"))
opt_parser = OptionParser(option_list = option_list)
arguments = parse_args(opt_parser, positional_arguments = TRUE)

options = arguments$options
args = arguments$args

#### validate the arguments ####
if(length(args) != 4) {
  cat("Incorrect number of required positional arguments\n\n")
  print_help(opt_parser)
  stop()
} else {
  data_sep = args[1]
  data_header = args[2]
  data_path = args[3]
  omega_path = args[4]
}

#### read the dataset ####
tbl_separator = c("tab"="\t", "comma"=",", "semicolon"=";", "space"=" ")
sep = tbl_separator[data_sep]
tbl_header = c("0"=FALSE, "1"=TRUE)
header = tbl_header[data_header]

usr_data = as.matrix(read.table(data_path, sep=sep, header=header))
dim = ncol(usr_data)
scaled_data = scale(usr_data, center = TRUE, scale = TRUE)

corr_mat = cor(scaled_data)
if(length(options) != 2) {
  # calculate the threshold
  threshold = sort(corr_mat)[dim*dim*0.95]
} else {
  threshold = options$threshold
}

#### screening the correlation matrix ####
omega = matrix(0, dim, dim)
for (r in 1:dim) {
  for (c in 1:dim) {
    omega[r, c] = ifelse(abs(corr_mat[r, c]) < threshold, 0, 1)
  }
}
diag(omega) <- rep(0, dim)
if(header){
  write(t(colnames(usr_data)), file = omega_path, ncolumns = ncol(omega))
  write(t(omega), file = omega_path, append=TRUE, ncolumns = ncol(omega))
} else {
  write(t(omega), file = omega_path, ncolumns = ncol(omega))
}
