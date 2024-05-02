library(tidyverse)
library(lobstr)

# Simple example of nesting ----
# Sample data frame
sales_data <- tibble(
  store = c('Store1', 'Store1', 'Store2', 'Store2', 'Store1', 'Store2'),
  product = c('ProductA', 'ProductB', 'ProductA', 'ProductB', 'ProductA', 'ProductB'),
  sales = c(10, 15, 10, 20, 25, 30),
  price = c(100, 150, 110, 160, 105, 155)
)

# Grouping and nesting data
grouped_data <- sales_data %>%
  group_by(store, product) %>%
  nest()

# Defining a function to apply to each nested tibble
analysis_function <- function(df) {
  list(
    total_sales = sum(df$sales),
    avg_price = mean(df$price),
    lm_model = broom::tidy(lm(sales ~ price, data = df))
  )
}

# Applying the function to each nested data frame
results <- grouped_data %>%
  mutate(analysis = map(data, analysis_function))

# Viewing the results
results


# Nesting and size ----
set.seed(123)
large_data <- tibble(
  id = 1:1e6,
  value = rnorm(1e6),
  group = sample(letters, 1e6, replace = TRUE)
)

original_size <- obj_size(large_data)
original_size

nested_data <- large_data %>%
  group_by(group) %>%
  nest()

nested_size <- obj_size(nested_data)
nested_size

# Inspecting sizes of the first few nested tibbles
obj_size(nested_data$data[[1]])
obj_size(nested_data$data[[2]])


# Comparing with sizes of equivalent non-nested slices
obj_size(large_data %>% filter(group == unique(large_data$group)[1]))
obj_size(large_data %>% filter(group == unique(large_data$group)[2]))


# Create a simple data.table
dt <- data.table(id = 1:3)

# Add a list column with different types of data
dt[, list_col := list(list(c(1, 2, 3)),
                      list(c("a", "b", "c")),
                      list(data.table(x = 1:2, y = 3:4)))]

