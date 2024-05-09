
# Advanced R technical session---------------
# Chapter 3: Vectors ------------------------


# 0. Load packages ----
library(lobstr) # in case we need to check sizes etc


# 1. Atomic Vectors ----
## 1.0 Additional Notes ----
### 1.0.1 Character constants in R ----
# Using double quotes
print("Hello, world!")

# Using single quotes
print('Hello, world!')

# Double quotes inside single quotes
print('He said, "Hello, world!"')
cat('He said, "Hello, world!"')
print("He said, 'Hello, world!'")

# Newline and tab (print vs concatenate and print, cat)
print("Line 1\nLine 2")
cat("Line 1\nLine 2")
cat("Column1\tColumn2")

# Backspace and bell
cat("Wrong\b\b\bRight\a")

# Unicode example
print("\u03C0")  # Greek letter Pi

# Octal and Hexadecimal representations (security, debugging,)
cat("\141")  # Octal for 'a'
cat("\x61")  # Hexadecimal for 'a'
cat("\110\145\154\154\157\40\127\157\162\154\144\41")


# Fun way to understand what the octal system is (and raw):
octal_value <- "141"
reversed_digits <- rev(strsplit(octal_value, "")[[1]])

decimal_value <- sum(as.integer(reversed_digits) * 8^(seq_along(reversed_digits) - 1))

decimal_value

as.raw(decimal_value) # .... it's the hexadecimal!
character_from_octal <- rawToChar(as.raw(decimal_value)) # raw data are by default represented in hex.

character_from_octal

## 1.0.2 Missingness propagation ----
NA > 5
10 * NA
!NA

# Exceptions when identity holds:
NA ^ 0
NA | TRUE
NA & FALSE

# !!!
x <- c(NA, 5, NA, 10)
x == NA
is.na(x)
typeof(x)

## 1.0.3 Testing ----
x <- 1:3
is.vector(x)

attr(x, 'attribute_of_x') <- 'i am an attribute'
is.vector(x)

x <- NULL
is.atomic(x) # !!!!! Not true for R 4.4.0.9000 , 4.4.0, 4.3.3





## 1.1 Question 1: Test vector coercion rules ----
c(1, FALSE)      # will be coerced to ...
c("a", 1)        # will be coerced to ...
c(TRUE, 1L)      # will be coerced to ...

## 1.2 Question 2: What do you expect from running this and why? ----
1 == "1"

# compare with:
identical(1, '1') # looks at entire definition of objects supplied!

1:3 == '1'

identical(1:3, '1')
# Note: identical is not equivalent to ==, diff purpose and identical will
# always be faster (returns one element).

-1 < FALSE

"one" < 2 # hint: lexicographic order!

## 1.3 Why is the default missing value, NA, a logical vector?
int_vector <- c(1, NA)
typeof(int_vector)

int_vector <- c(1, NA_character_)
typeof(int_vector)

int_vector <- c(1, NaN) # it is not the same! But also coercion following the hierarchy.
typeof(int_vector)


# 2. Attributes ----

## 2.0 Additional Notes ----
### 2.0.1 Setting Attributes ----
attr(a, "x") <- "abcdef"

a <- structure( # setting an attribute as well
  1:3,
  x = "abcdef", # more than 1 attribute!
  y = 4:6
)

a <- structure(
  1:3,
  x = "abcdef",
  y = 4:8 # can be longer!
)

attr(a) # wrong
attributes(a)
attr(x = a, which = "names")
attr(x = a, which = "x")

## 2.1 Question 1:How is setNames()/unname implemented? ----
# Already covered!

setNames <- function(object = nm, nm) {
  names(object) <- nm
  object
}

# it is pipable!

unname <- function(obj, force = FALSE) {
  if (!is.null(names(obj)))
    names(obj) <- NULL
  if (!is.null(dimnames(obj)) && (force || !is.data.frame(obj))) # won't touch data.frames
    dimnames(obj) <- NULL
  obj
}

m1 <- matrix(1:12, nrow = 3)
x <- 1:13
names(x) <- 1:14

names(m1) <- 1:12
m1

dimnames(m1) <- 1:12
dimnames(m1) <- list(1:3, 1:4)

attributes(m1)

## 2.2 Question 2: What does dim() return when applied to a 1-dimensional vector? ----
# When might you use NROW() or NCOL()?

x <- 1:10
nrow(x)
ncol(x)
dim(x)

# Treats vector as a 1-column matrix, so what will it return?
NROW(x)
NCOL(x)


# 3. Simple S3 vectors ----
## 3.1 Question 1: What sort of object does table() return? ----
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

## 3.2 Question 2 Does Table count NAs? ----
d <- factor(rep(c("A","B","C"), 10), levels = c("A","B","C","D","E"))
is.na(d) <- 3:4 # sets NAs, but not the levels
d. <- addNA(d)
d.[1:7]
table(d.) # ", exclude = NULL" is not needed
## i.e., if you want to count the NA's of 'd', use
table(d, useNA = "ifany")
table(d)


# 4. Complex S3 vectors ----
## 4.1 Question 1: What happens to a factor when you modify its levels? ----
f1 <- factor(letters)
f1
as.integer(f1)
levels(f1) <- rev(levels(f1))
f1
as.integer(f1)

## 4.2 Question 2: How do f2 and f3 they differ from f1? ----
f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))


# 5. Lists ----

## 5.1 Question 1 ----
list <- list(1:3)
list_coerce <- as.list(1:3) # are these the same? Why? Why not?

## 5.2 Question 2: List all the ways that a list differs from an atomic vector ----

# 1. vectors are homogeneous/ lists are not
# 2. vectors have one reference, lists have multiple references

lobstr::ref(1:2)

lobstr::ref(list(1:2, 2))

# 3. Subsetting with out-of-bounds and NA values leads to different output.

# Subsetting atomic vectors
(1:2)[3]

(1:2)[NA]


# Subsetting lists
as.list(1:2)[3]

as.list(1:2)[NA]

list(1:2)[3]

## 5.3 Question 3: Why do you need to use unlist() to convert a list to an atomic vector? ----

list1 <- list(1:3)
is.vector(as.vector(list1))
typeof(as.vector(list1))


is.vector(as.vector(mtcars))
typeof(as.vector(mtcars))

typeof(unlist(mtcars))
str(unlist(mtcars))

# 6. Data.frames, Tibbles, data.tables ----
## 6.1 What is a data.frame? What are its attributes? ----
df1 <- data.frame(x = 1:3, y = letters[1:3])
typeof(df1)
attributes(df1)

## 6.2 What is a tibble? What are its attributes? ----
library(tibble)
tb1 <- tibble(x = 1:3, y = letters[1:3])
typeof(tb1)  # "list"
attributes(tb1)


## 6.3 What is a data.table? What are its attributes? ----
library(data.table)
dt1 <- data.table(x = 1:3, y = letters[1:3])
typeof(dt1)  # "list"
attributes(dt1)

## 6.4 What is the difference between colnames() and names()? ----

data.frame(a = integer(), b = logical())
#> [1] a b
#> <0 rows> (or 0-length row.names)

data.frame(row.names = 1:3)  # or data.frame()[1:3, ]
#> data frame with 0 columns and 3 rows

data.frame()
#> data frame with 0 columns and 0 rows

## 6.5 Can you have a data frame with zero rows? What about zero columns? ----
### data.frames
mtcars[0, ]


mtcars[ , 0]


mtcars[0, 0]

### data.tables
mtcarsdt<-mtcars
setDT(mtcarsdt)

mtcarsdt[ , 0]
mtcarsdt[0, ]



## 6.6 What happens if you attempt to set rownames that are not unique? ----
data.frame(row.names = c("x", "y", "y"))


df <- data.frame(x = 1:3)
row.names(df) <- c("x", "y", "y")


row.names(df) <- c("x", "y", "z")
df[c(1, 1, 1), , drop = FALSE]


## 6.7  If df is a data frame, what can you say about t(df), and t(t(df))? ----
# Note t() is for transpose of a matrix

df <- data.frame(x = 1:3, # different types!
                 y = letters[1:3])
is.matrix(df)

is.matrix(t(df))
t(df) # coercion following the hierarchy

is.matrix(t(t(df))) # basically original dataframe but coerced.


dim(df)

dim(t(df))

dim(t(t(df)))



## 6.8 What does as.matrix() do? and data.matrix()? ----

df_coltypes <- data.frame(
  a = c("a", "b"),
  b = c(TRUE, FALSE),
  c = c(1L, 0L),
  d = c(1.5, 2),
  e = factor(c("f1", "f2"))
)

as.matrix(df_coltypes)

data.matrix(df_coltypes)
# it always follows the hierarchy!

