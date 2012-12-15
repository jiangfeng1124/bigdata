#!/bin/python

# This is to apply correlation screening algorithm
# to estimate a inverse covariance matrix
# Arguments:
# 1. data_path
# 2. result_dir

import sys
import os
from optparse import OptionParser
from numpy import *

def loadDataSet(file_name):
  fr = open(file_name)
  data_mat = []
  for line in fr:
    feats = line.strip().split()
    data_mat.append([float(feat) for feat in list(feats)])
  return mat(data_mat)

#### parse the options and arguments ####
opt_parser = OptionParser()
opt_parser.add_option("-t", "--thresh", dest="threshold", help="set a threshold for screening the correlation matrix", default=0.5)
(options, args) = opt_parser.parse_args()

#### validate the arguments ####
if len(args) != 2:
  opt_parser.error("Missing argument (data_path) or (result_dir)")
  quit()

threshold = float(options.threshold)

(data_path, result_dir) = args

# read the dataset
# standardize the data matrix
data_mat = loadDataSet(data_path)
dim = shape(data_mat)[1]
col_mean = mean(data_mat, axis=0)
data_mat = mat((data_mat - col_mean) / sqrt(diag(cov(data_mat, rowvar=0))))

corr_mat = corrcoef(data_mat, rowvar=0)

# screening the correlation matrix
omega = matrix(zeros(shape=(dim, dim)))
for r in range(0, dim):
  for c in range(0, dim):
    if r == c:
      omega[r, c] = 0
    elif abs(corr_mat[r,c]) < threshold:
      omega[r, c] = 0
    else:
      omega[r, c] = 1

# visualize the graph
import igraph
plot_path = result_dir + "/graph_py.png"
g = igraph.Graph.Adjacency(omega.tolist()).as_undirected()
igraph.plot(g, plot_path, vertex_size = [24], vertex_color=["red"], vertex_label=range(1, dim+1), vertex_label_size=[12], layout = g.layout_fruchterman_reingold(), margin = 60, bbox=(690, 460))

