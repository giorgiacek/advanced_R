# S3
# 0. Libraries ----
library(sloop)

# 1. Basics ----
# S3 is a base type with AT LEAST a class, e.g. factors:
f <- factor(c("a", "b", "c"))
typeof(f) # integer
attributes(f) # with levels attributes and class == factor


# S3 behaves differently from base type (integer) whenever it is passed to a generic function
# But which functions are generic? Use ftype() from sloop to figure it out
ftype(print)

print(f)
print(unclass(f))

# Beware that str() is generic
ftype(str)

# ... so it hides details sometimes!
time <- strptime(c("2017-01-01", "2020-05-04 03:21"), "%Y-%m-%d")
str(time) # seems small
str(unclass(time)) # but lot of stuff in here

# The generic is a middleman: its job is to define the interface
# (i.e. the arguments) then find the right implementation for the job.
# The implementation for a specific class is called a method,
# and the generic finds that method by performing method dispatch.

# generic (print) -> method (print.factor)

s3_dispatch(print(f))

# Generally, you can identify a method by the presence of . in the function name.
ftype(t.test) # but some functions are old and the . does not mean that they are methods.
ftype(t.data.frame)
ftype(print.factor)


# s3 methods are not exported usually, they live in the package. So you need to use:
print.factor # this is exported
s3_get_method(weighted.mean.Date) # this is not exported.

## 1.1 Basics Questions ----
### 3. What does the as.data.frame.data.frame() method do? Why is it confusing?
# How could you avoid this confusion in your own code?

### 4. Check the difference in behaviour between these two calls:
set.seed(1014)
some_days <- as.Date("2017-01-31") + sample(10, 5)

mean(some_days) # mean of the date
mean(unclass(some_days)) # mean of the doubles underneath


### 5.
x <- ecdf(rpois(100, 10))
typeof(x) # object of the class ecdf (also note superclasses)
attributes(x)

### 6.
x <- table(rpois(100, 5))
x
typeof(x)
class(x)
attributes(x) # dimensions is what help the method when printed
s3_get_method(print.table)

# 2. Classes ----
# Create and assign class in one step:
x <- structure(list(), class = "my_class")

# Create, then set class
x <- list()
class(x) <- "my_class"

constructor_function <- function() {
  structure(list(), class = "my_class") # or the other variation
}

x <- constructor_function()

class(x)
inherits(x, "my_class") # to check if it's of a given class!
# suggest not to use . e.g. my.class because it could be confusing

## !!! Attention !!! 1 ----
# R does not prevent you from changing the class of an object

mod <- lm(log(mpg) ~ log(disp), data = mtcars) # linear model
class(mod)
print(mod)

# You can turn it into a date (?!)
class(mod) <- "Date"

# Unsurprisingly this doesn't work very well!
print(mod)

## 2.1 Constructors -----
# The constructor should follow three principles:

# Be called new_myclass().
# Have one argument for the base object, and one for each attribute.
# Check the type of the base object and the types of each attribute.

## example 1: constructor for class with one attribute
new_Date <- function(x = double()) {
  stopifnot(is.double(x)) # check if it's a double
  structure(x, class = "Date") # gives it class Date
}

new_Date(c(-1, 0, 1))


## example 2: constructor for a class with multiple attributes
new_difftime <- function(x = double(), units = "secs") {
  stopifnot(is.double(x))
  units <- match.arg(units, c("secs", "mins", "hours", "days", "weeks"))

  structure(x,
            class = "difftime",
            units = units
  )
}

new_difftime(c(1, 10, 3600), "secs")

## 2.2 Validators ----
# the validator will be called to go through more complex checks
# new constructor function for factors:
new_factor <- function(x = integer(),
                       levels = character()) {

  stopifnot(is.integer(x)) # small checks
  stopifnot(is.character(levels))

  structure(
    x,
    levels = levels,
    class = "factor"
  )
}

new_factor(1:5, "a") # but when you create an object like so, it will throw an error as you need enough levels!

# so it is better to build a validator you can pass the result through:
validate_factor <- function(x) {

  values <- unclass(x)
  levels <- attr(x, "levels") # checks that the levels are okay

  if (!all(!is.na(values) & values > 0)) {
    stop(
      "All `x` values must be non-missing and greater than zero",
      call. = FALSE
    )
  }

  if (length(levels) < max(values)) {
    stop(
      "There must be at least as many `levels` as possible values in `x`",
      call. = FALSE
    )
  }

  x
}

validate_factor(new_factor(1:5, "a")) # will throw an error and inform
validate_factor(new_factor(1:5, c("a", "b", "c", "d", "e"))) # will pass

## 2.3 Helpers ----
# If you want the user to create an object, you should create an helper function:
## 1. this function should be called like the object.
## 2. it should call the constructor and the validator.
## 3. and it should give the user info about errors etc.

# something like this:
factor_v2 <- function(x = character(), # takes in a string
                   levels = unique(x)) { # levels are unique values of x

  ind <- match(x, levels)
  #print(ind)
  validate_factor(new_factor(ind, levels))
}

factor_v2(c("a", "b", "b", "a"))


# example with our difftime constructor (no validator added here)
difftime <- function(x = double(), units = "secs") {
  x <- as.double(x) # this coerces the input to double
  # before, we only checked if it was double:
  new_difftime(x, units = units)
}

# example with a factor
factor_v2 <- function(x = character(), # takes in a string
                   levels = unique(x)) { # levels are unique values of x
  ind <- match(x, levels)
  #print(ind)
  validate_factor(new_factor(ind, levels))
}


## 2.4 Question:
## How is factor different from the base function factor?
base::factor()



# 3. Methods ----
# Methods are functions that are called by the generic function.
# The job of an S3 generic is to perform method dispatch,
# i.e. find the specific implementation for a class.
# Method dispatch is performed by UseMethod()
# UseMethod() takes two arguments:
# the name of the generic function (required),
# the argument to use for method dispatch (optional).

# 3.1 Generic and methods overview ----
## Examples of generic calling directly UseMethod():
mean
print

## In fact, if you want to create your own generic, it works simply like so:
my_new_generic <- function(x) {
  UseMethod("my_new_generic")
}

## You should not add computations in a generic, for example like so:
my_new_generic <- function(x) {
  x + 1 # very bad!
  UseMethod("my_new_generic")
}

## As that line will be executed for each class, and it would be hard to debug etc.

# Advanced R says: "You don’t pass any of the arguments of the generic to UseMethod();
# it uses deep magic to pass to the method automatically."
# What happens is just that UseMethods() checks the class of x, checks if there is any method,
# and then it moves on to the next "inherited" class (more on this later.)

## Anyway, what happens exactly when we dispatch a method?
num <- 1:4
sloop::s3_dispatch(mean(num)) # this will call the method mean.numeric
sloop::s3_dispatch(print(num)) # this will call the method print.numeric

# For a double vector, it looks at whether there is a specified mean method,
# and if not, it will look at the default method.


## When does not dispatch to default? When there is a method for it!
create_adjusted_value <- function(x, adjustment_factor = 1) {
  structure(list(value = x,
                 adjustment = adjustment_factor),
            class = "adjusted_value")
}

# Custom mean function for adjusted_vector class
mean.adjusted_value <- function(x, ...) {
  adjusted_data <- x$value * x$adjustment
  mean(adjusted_data, ...) # ... is for additional arguments, more when we do functions.
}

adjusted_value <- create_adjusted_value(1:4, 0.2)
adjusted_value
mean(adjusted_value) # this will call the mean.adjusted_value method
(1*0.2 + 2*0.2 + 3*0.2 + 4*0.2) / 4 # it is adjusted

sloop::s3_dispatch(mean(adjusted_value))

## basically UseMethods() looks for this:
paste0("generic", ".", c(class(num), "default"))
UseMethod # is a primitve though, it is written in C code. You can look for the
# source code here: src/main/objects.c












