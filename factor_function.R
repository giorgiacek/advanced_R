function (x = character(), levels, labels = levels, exclude = NA,
          ordered = is.ordered(x), nmax = NA) {
  # Handle null input by assigning an empty character vector
  if (is.null(x))
    x <- character()

  # Store original names from 'x' to reapply later
  nx <- names(x)

  # Determine levels if not provided
  if (missing(levels)) {
    y <- unique(x, nmax = nmax)  # Get unique elements of 'x'
    ind <- order(y)              # Order these unique elements
    levels <- unique(as.character(y)[ind])  # Use ordered unique elements as levels
  }

  # Ensure 'ordered' attribute is evaluated
  force(ordered)

  # Convert 'x' to character if not already
  if (!is.character(x))
    x <- as.character(x)

  # Exclude specified levels
  levels <- levels[is.na(match(levels, exclude))]

  # Match 'x' to 'levels' to create the factor
  f <- match(x, levels)

  # Reapply original names
  if (!is.null(nx))
    names(f) <- nx

  # Handling labels
  if (missing(labels)) {
    levels(f) <- as.character(levels)
  } else {
    nlab <- length(labels)
    if (nlab == length(levels)) {
      # Set factor levels to provided labels
      nlevs <- unique(xlevs <- as.character(labels))
      at <- attributes(f)
      at$levels <- nlevs
      f <- match(xlevs, nlevs)[f]
      attributes(f) <- at
    }
    else if (nlab == 1L)
      # When one label is provided, append it to all levels
      levels(f) <- paste0(labels, seq_along(levels))
    else
      # Throw an error if labels length mismatch
      stop(gettextf("invalid 'labels'; length %d should be 1 or %d",
                    nlab, length(levels)), domain = NA)
  }

  # Set class of 'f' to 'ordered' or 'factor' based on the 'ordered' argument
  class(f) <- c(if (ordered) "ordered", "factor")

  # Return the created factor
  f
}
