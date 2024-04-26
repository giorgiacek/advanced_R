#--------------------------------------------
# Advanced R technical session---------------
# Chapter 3: Vectors ------------------------
#--------------------------------------------

# 0. Load packages
library(lobstr)

# 1. Atomic

# 2. Attributes
# Question 1: What does dim() return when applied to a 1-dimensional vector?
# When might you use NROW() or NCOL()?

x <- 1:10
nrow(x)
ncol(x)

# Treats vector as a 1-column matrix, so what will it return?
NROW(x)
NCOL(x)






