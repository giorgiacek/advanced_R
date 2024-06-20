# Borrowed from amazing historian Jesse Sadler.

# The British currency system before 1971 was based on the pound (£), shilling (s), and pence (d).
# There were 20 shillings in a pound and 12 pence in a shilling.
# The function normalize() takes a vector of three integers representing an
# amount of money in pounds, shillings, and pence, and returns a vector of the
# same length with the same amount of money in the same format,
# but with the smallest number of shillings and pence possible.

# For example, normalize(c(132, 53, 35)) should return c(133, 13, 11)
# because 132 pounds, 53 shillings, and 35 pence is equivalent to:
# 133 pounds,
# 13 shillings,
# and 11 pence.


# The function should work for any input where the second and third elements are
# less than 20 and 12, respectively.

# 1. A normal function
normalize <- function(x) {
  pounds <- x[[1]] + ((x[[2]] + x[[3]] %/% 12) %/% 20)
  shillings <- (x[[2]] + x[[3]] %/% 12) %% 20
  pence <- x[[3]] %% 12

  c(pounds, shillings, pence)
}


normalize(c(132, 53, 35))

# 2. A S3 class
lsd <- function(x,
                bases = c(20, 12)) {
  structure(x,
            class = "lsd",
            bases = bases)
}

lsd(13)



# AND NOW?
# vctrs gives you a path to create a class that is more robust and easier to work with.

# 1. Creation




