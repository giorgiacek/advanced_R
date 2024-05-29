
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
x == NA # very important! : checks whether each element of x is the same of NA
is.na(x) # here you are vectorizing an evaluation/check, is the obj NA?
typeof(x)

NA == NA

x <- c(NA_character_, 1, 2)

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
a <- 1:4
attr(a, "x") <- "abcd"
attr(a) # wrong!
attributes(a) # right!

names(a) <- "abcd" # check the difference between names and other attributes!
a
names(a) <- letters[1:4]
a

attr(x = a, which = "names")
attr(x = a, which = "x")


sum_of_a <- sum(a)
attributes(sum_of_a)

a_x_2 <- a * 2
attributes(a_x_2)
# rule: if vector change of size then attribute disappear
# we can think of names as 'functional' attributes.

attributes(a[1])


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

attributes(a)$y # it works like a list!!


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

setNames()


m1 <- matrix(1:12, nrow = 3)
x <- 1:13
names(x) <- 1:14

names(m1) <- 1:12
m1

dimnames(m1) <- 1:12
dimnames(m1) <- list(1:3, 1:4)

attributes(m1)

dimnames(m1) <- list(letters[1:3], letters[1:4])
m1[a]

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

# Differences when table using char vs factor
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))
table(sex_char)
table(sex_factor)

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
list_coerce <- as.list(1:3)

## 5.2 Question 2: List all the ways that a list differs from an atomic vector ----

# 1. vectors are homogeneous/ lists are not.
# 2. vectors have one reference, lists have multiple references (in memory).

lobstr::ref(1:2) # vector

lobstr::ref(list(1:2, 2)) # list (question why is 1:2 int?)

typeof(list(1:2, 2)[2])
typeof(list(1:2, 2)[[2]])

lobstr::ref(list(list(1:3), list(1:3)))

# Note: Again this does not mean that the size increases much:
lobstr::obj_size(c(1:1000))
lobstr::obj_size(list(c(1:1000)))



# 3. Subsetting with out-of-bounds and NA values leads to different output.

# 3.1 Subsetting out of bounds:
(1:2)[3] # NA! x1
list(1:2)[3] # NULL!
as.list(1:2)[3] # NULL!

list(1, 2)[3]
list(1, 2)[[3]]


# 3.2 Subsetting with NAs:
(1:2)[NA] # NA! x2
## NA as an index is considered an indeterminate position,
## and thus the corresponding value is also indeterminate (NA).
length((1:2)[1])
length((1:2)[NA])
typeof((1:2)[NA])

list(1:2)[[NA]] # NULL! x1
list(1:2)[NA]
length(list(1:2)[NA])


as.list(1:2)[NA] # NULL! x2
length(as.list(1:2)[NA])

# 3.3 Additional exercise:
## 3.3.1 named list
v <- 4:6
l <- list(a = 4, b = 5, c = 6)
v[5]
l[5] # note that you get <NA> in the names too.

### 3.3.2
v[NA] # logical! -> recycled
v[NA_integer_] # integer -> just an index
l[NA]
l[NA_integer_]

# There is much much much more on accessing lists vs vectors. NOT TODAY! (subsetting chapter)

## 5.3 Question 3: Why do you need to use unlist() to convert a list to an atomic vector? ----

list1 <- list(1:3)
is.atomic(as.vector(list1))
is.vector(as.vector(list1))
typeof(as.vector(list1)) # it is a list!!



# A list is already a vector, so as.vector does not do much!
# Compare:
str(as.vector(list1))
str(unlist(list1))


# Example with dataframes:
is.vector(as.vector(mtcars))
typeof(as.vector(mtcars))
str(as.vector(mtcars))

identical(list(1:3), as.vector(list(1:3)))

typeof(unlist(mtcars))
str(unlist(mtcars))

# Point is: as.vector() will NOT flatten your lists/df,
# and list and df are complex vectors anyway!

# unlist very tricky function!


## 5.4 Compare and contrast c() and unlist() when combining a date and date-time into a single vector.----
date    <- as.Date("1970-01-02") # number of days since the reference date 1970-01-01.
dttm_ct <- as.POSIXct("1970-01-01 01:00",
                      tz = "UTC") # in seconds.

# we can see it like that:
unclass(date)
unclass(dttm_ct)

str(date)
str(dttm_ct)
attributes(date)
attributes(dttm_ct)

# Output in R version 3.6.2
c(date, dttm_ct)  # also equal to c.Date(date, dttm_ct)
#> [1] "1970-01-02" "1979-11-10" -> considered days!
c(dttm_ct, date)  # also equal to c.POSIXct(date, dttm_ct)
#> [1] "1970-01-01 02:00:00 CET" "1970-01-01 01:00:01 CET" -> considered seconds!


sloop::s3_dispatch(c(dttm_ct, date)) # Thank you Zander!!!

# Point 2: c() will strip dttm_ct of the attribute but not the class:
c(date, dttm_ct)
attributes(c(date, dttm_ct))
class(c(date, dttm_ct))

# unlist() will strip dttm_ct of attributes AND class:
list(date, dttm_ct)
unlist(list(date, dttm_ct))
attributes(unlist(list(date, dttm_ct)))
class(unlist(list(date, dttm_ct))) # numeric!

# This will NOT happen when you list them:
class(list(date, dttm_ct)[[1]]) # not stripped
class(unlist(list(date, dttm_ct))[[2]]) # stripped

typeof(12.4)
class(12.4)
# Additional notes on dates
dates <- seq(as.Date("2020-01-01"), by = "month", length.out = 3)
str(dates)

sloop::s3_dispatch(typeof(12.4))



## 5.5 Additional note:
# differences between c(), list(), append()
x <- list(a = "1",
          b = as.list(1:3))
y <- list(z = "Hola",
          w = 1:4)


# different ways to combine lists
# 1. c()
c(x, y)

# 2. append()
append(x, y)


# 3. list
list(x, y)


lobstr::obj_size((1:3))
lobstr::obj_size(list((1:3)))

lobstr::ref(as.list(1:3))

# 4. unlist()
unlist(list(x, y))


# 5. c() with do.call()
do.call(c, list(x, y))




# 6. Data.frames and Tibbles ----
## 1. Creating ----
### 1.1 What is a data.frame? What are its attributes? ----
df1 <- data.frame(x = 1:3,
                  y = letters[1:3])
typeof(df1) # it is still a list
attributes(df1) # with specific attributes (names, class, row.names)

### 1.2 (Addition) What is a tibble? What are its attributes? ----
library(tibble)
tb1 <- tibble(x = 1:3,
              y = letters[1:3])
typeof(tb1)  # still a list
attributes(tb1) # different attributes values (class =! class df)


identical(tb1, df1) # FALSE
all.equal(tb1, df1) # highlights differences in attributes


### 1.3 (Addition) What is a data.table? What are its attributes? ----
library(data.table)
dt1 <- data.table(x = 1:3,
                  y = letters[1:3])
typeof(dt1)  # "list"
attributes(dt1) # $.internal.selfref!

identical(dt1, df1) # FALSE
all.equal(dt1, df1)
all.equal(dt1, tb1)


### 1.4 stringAsFactors() ----
df2 <- data.frame(x = 1:3,
                  y = c("a", "b", "c"))

typeof(df2$y)
str(df2)
# I think that I have a default to stringAsFactors = FALSE?
# tibbles will NOT coerce to factors.

str(tb1)

### 1.5 non-syntactic names
data.frame(`1` = 1,
           x = "a") # 1 will be converted to a names which can be used

tibble(`1` = 1,
        x = "a") # not with lazy tibbles

data.table(`1` = 1,
           x = "a") # or with data.tables!

### 1.6 Recycling shorter inputs ----
# Quite different behaviour actually!
data.frame(x = 1:4,
           y = 1:2) # shorter input, but multiple of x
data.frame(x = 1:4,
           y = 1:3) # not multiple of x

tibble(x = 1:4,
       y = 1) # size 1 ok

tibble(x = 1:4,
       y = 1:2) # not ok!

data.table(x = 1:4,
           y = 1:2) # dt is actually okay with multiples as well

data.table(x = 1:4,
           y = 1:3) # AND WITH NOT MULTIPLES (with remainder)

### 1.7 In-itinere ----
data.frame(x = 2,
           y = x*2) # nope!

tibble(x = 2,
       y = x*2) # yep!

data.table(x = 2,
           y = x *2) # nope!


## 2. Row names ----
df3 <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"),
  row.names = c("Bob", "Susan", "Sam") # special! needs to contain unique names
)

df3

df4 <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"),
  row.names = c("Bob", "Bob", "Sam") # you get an error otherwise!
)

# you can then retrieve them:
rownames(df3)
# and you can subset:
df3["Bob", ]

# Row names are undesirable though, good example:
df3[1,] # If we want to duplicate this row
df3[c(1, 1, 1), ] # the names will change

dt3 <- data.table(age = c(35, 27, 18),
                  hair = c("blond", "brown", "black"),
                  row.names = c("Bob", "Susan", "Sam")) # you just get a variable called row.names!

rownames(dt3) # the rownames are actually 1, 2, 3

row.names(df3) <- c("a", "b", "c") # works
row.names(dt3) <- c("a", "b", "c") # does not work


# so tibbles will not have rownames:
as_tibble(df3)
as_tibble(df3, rownames = "name")

## 3. Subsetting ----
# you can subset a data frame or a tibble like a 1D structure (where it behaves like a list),
# or a 2D structure (where it behaves like a matrix).


df3$age # list-like will return a vector (not dataframe)
df3[1:2, c("age", "hair")] # matrix-like will return dataframe (for two columns only!)


# Undesirable 1: type
one_var <- "age"
two_vars <- c("age", "hair")


df3[,two_vars]
df3[,one_var, drop=FALSE] # you need drop = FALSE

tb3 <- as_tibble(df3)
tb3[,one_var] # returns tibble

dt3 <- as.data.table(df3)
dt3[ , one_var] # small reminder that this does not work
dt3[ , ..one_var] # but this returns a data.table


# Undesirable 2: partial matching
df3$x
df3$a # !!! it takes age


tb3$a # does not do anything
dt3$a # IT HAS THE SAME ISSUE BE CAREFUL!! VERY SCARY STUFF


## 4. List Columns ----
df3$list_col <- list(1:3, 1:4, 1:5) # needs to have 3 elements in it


data.frame(x = 1:3,
           list_col = list(1:3, 1:4, 1:5)) # NOPE! This won't work

data.frame(x = 1:3,
           list_col = I(list(1:3, 1:4, 1:5))) # You need this!

# Also what do you expect here?
data.frame(x = 1:3,
           list_col = list(1,2,3))

# But you can do it in a tibble:
tibble(x = 1:3,
       y = list(1:2, 1:3, 1:4))

tibble(x = 1:3,
       list_col = list(1,2,3)) # will work just fine and place it in a list



## 5.Questions ----
### 1 Can you have a data frame with zero rows? What about zero columns? ----
# Yes you can create them subsetting:
### data.frames
mtcars[0, ]

mtcars[ , 0]

mtcars[0, 0]

### data.tables
mtcarsdt<-mtcars
setDT(mtcarsdt) # setting as reference

mtcarsdt[ , 0]
mtcarsdt[0, ]

### tibbles
mtcarstb <- as_tibble(mtcars)
mtcarstb[0, ]

# Or when creating them
data.frame( x = logical(),
            y = integer())

data.table( x = logical(),
            y = integer())

tibble(x = logical(),
       y = integer())


# also, you can create an empty dataframe but with given row number:
data.frame()[1:3, ]


## 6.6 What happens if you attempt to set rownames that are not unique? ----
data.frame(row.names = c("x", "y", "y")) # Error


df <- data.frame(x = 1:3)
row.names(df) <- c("x", "y", "y") # Error again

# as we saw before, if you subset and repeat the same item, it will deduplicate the rownames
row.names(df) <- c("x", "y", "z")
df[c(1, 1, 1), , drop = FALSE]


## 6.7  If df is a data frame, what can you say about t(df), and t(t(df))? ----
# Note t() is for transpose of a matrix.

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

