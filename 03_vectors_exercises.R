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


# 3. Simple S3 vectors
# Question 3.1: What sort of object does table() return?
# What is its type? What attributes does it have?
# How does the dimensionality change as you tabulate more variables?
x <- table(mtcars[c("vs", "cyl", "am")])

?table

typeof(x)

attributes(x)

str(x) # more useful this way

# Subset x like it's an array:
x[ , , 1]

x[ , , 2]

# Question 3.2 Does Table count NAs?
d <- factor(rep(c("A","B","C"), 10), levels = c("A","B","C","D","E"))
is.na(d) <- 3:4 # sets NAs, but not the levels
d. <- addNA(d)
d.[1:7]
table(d.) # ", exclude = NULL" is not needed
## i.e., if you want to count the NA's of 'd', use
table(d, useNA = "ifany")
table(d)


# 4. Complex S3 vectors


