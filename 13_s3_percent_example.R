library(vctrs)
library(rlang) # for abort()
library(zeallot) # for the %<-% operator


# Constructor
new_percent <- function(x = double()) {
  if (!is_double(x)) { # simple checks
    abort("`x` must be a double vector.")
  }

  new_vctr(x, # new class
           class = "vctrs_percent")
}

x <- new_percent(c(seq(0, 1, length.out = 4), NA))
x

# Helper which is user friendly
percent <- function(x = double()) {
  x <- vec_cast(x, double()) # coerce to double
  new_percent(x)
}

percent(c(0.1, 0.2, 0.3, 0.4, NA)) # will pass

# Check if an object is a percent
is_percent <- function(x) {
  inherits(x, "vctrs_percent")
}


# First method:
format.vctrs_percent <- function(x, ...) {
  out <- formatC(signif(vec_data(x) * 100, 3))
  out[is.na(x)] <- NA
  out[!is.na(x)] <- paste0(out[!is.na(x)], "%")
  out
}

x <- new_percent(c(0.1, 0.2, 0.3, 0.4, NA))
x
