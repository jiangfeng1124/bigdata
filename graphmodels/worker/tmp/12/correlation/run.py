#!/bin/python

# This is to apply correlation screening algorithm
# to estimate a inverse covariance matrix
# Arguments:
# 1. data_path
# 2. result_dir

import sys
from optparse import OptionParser

opt_parser = OptionParser()
opt_parser.add_option("-t", "--thresh", dest="threshold", help="set a threshold for screening the correlation matrix", default=0.5)
(options, args) = opt_parser.parse_args()

if len(args) != 2:
  opt_parser.error("Missing argument (data_path) or (result_dir)")
  quit()

print args[0], args[1]
print type(options)
print options.threshold

(data_path, result_dir) = args
print "data_path: ", data_path
print "result_dir: ", result_dir

