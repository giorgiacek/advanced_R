# Subsetting notes


# Notes: Base R very very fast, even though the syntax is a bit more verbose.
## Subsetting multiple elements

x <- c(1, 2, 3, 4, 5)
# Positive integers
x[c(1, 3, 5)]

# Duplicate integers will duplicate items
x[c(1, 1, 3, 3, 5, 5)]

# Real numbers will truncate
x[c(1.5, 3.2, 5.9)]
# this equals selecting position 1, 3, 5.

# Negative integers will exclude elements at a specific position.
x[c(-2, -4)]
# this equals excluding position 2 and 4.

# Logical vectors
x[c(TRUE, FALSE, TRUE, FALSE, TRUE)]

# Recycling rule in subsetting !!!!
x[c(TRUE, FALSE)]
# this equals selecting position 1(TRUE), 2(FALSE) 3(TRUE), 4(FALSE), 5(TRUE)
# because the logical vector is recycled.
# Very risky.


# with nothing is not like with 0
x[]
x[0] # empty numeric vector

# character vectors for named vectors
named_vector <- c(age = 1, b = 2, c = 3)
named_vector[c("a", "c")]
# this will return NA for the missing value.

# Lists ----
## [
list_data <- list(a = 1, b = 2, c = 3)
list_data[c(1, 3)]

## [[]]
list_data[[1]]
# which is equal to
list_data[["a"]]
# or equal to
list_data$a


# Higher dimensional objects ----
# With a vector (single) or multiple.
# with a matrix.
a <- matrix(1:6, nrow = 2)
# vector for each dimension
a[1, 2]


# dataframes
## Tibbles vs Data.frame vs Data.Table





