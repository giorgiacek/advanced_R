# Load necessary library
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

# Define parameters for the Beta distribution
alpha <- 2
beta <- 5
poverty_line <- 0.3

# Create a sequence of income values from 0 to 1
income <- seq(0, 1, length.out = 1000)

# Calculate the CDF values for these income levels
cdf_values <- pbeta(income, alpha, beta)

# Create a data frame for plotting
data <- data.frame(Income = income, CDF = cdf_values)

# Plot the CDF (Area is P1)
p <- ggplot(data, aes(x = Income, y = CDF)) +
  geom_line(color = "blue") +
  geom_area(data = subset(data, Income <= poverty_line), fill = "skyblue") +
  geom_vline(xintercept = poverty_line, linetype = "dashed", color = "red") +
  ggtitle("CDF of Income and the Poverty Gap") +
  xlab("Income") + ylab("Cumulative Distribution Function")

# Display the plot
print(p)


# # Calculate P0 - headcount ratio at the poverty line
P0 <- pbeta(poverty_line, alpha, beta)

# Plot the CDF
p <- ggplot(data, aes(x = Income, y = CDF)) +
  geom_line(color = "blue") +
  geom_area(data = subset(data, Income <= poverty_line), fill = "skyblue") +
  geom_vline(xintercept = poverty_line, linetype = "dashed", color = "red") +
  geom_text(aes(x = poverty_line, y = P0, label = sprintf("P0 = %.2f", P0), vjust = -0.5), color = "darkred") +
  ggtitle("CDF of Income and Poverty Measures (P0 and P1)") +
  xlab("Income") + ylab("Cumulative Distribution Function")

# Display the plot
print(p)


# Calculate P2 - severity of poverty index
P2 <- integrate(function(x) ((poverty_line - x)/poverty_line)^2 * dbeta(x, alpha, beta), lower = 0, upper = poverty_line)$value

# Plot the CDF
p <- ggplot(data, aes(x = Income, y = CDF)) +
  geom_line(color = "blue") +
  geom_area(data = subset(data, Income <= poverty_line), fill = "skyblue", alpha = 0.5) +
  geom_vline(xintercept = poverty_line, linetype = "dashed", color = "red") +
  geom_text(aes(x = poverty_line, y = P0, label = sprintf("P0 = %.2f, P2 = %.2f", P0, P2), vjust = -0.5), color = "darkred") +
  ggtitle("CDF of Income and Poverty Measures (P0, P1, and P2)") +
  xlab("Income") + ylab("Cumulative Distribution Function")

# Display the plot
print(p)

# Define parameters for the Beta distribution
alpha <- 2
beta <- 5
poverty_line <- 0.3
income <- seq(0, 1, length.out = 1000)

# Calculate the CDF values and the poverty gaps squared
cdf_values <- pbeta(income, alpha, beta)
poverty_gaps_squared <- ((poverty_line - income) / poverty_line)^2
poverty_gaps_squared[income > poverty_line] <- NA  # Only consider values below the poverty line

# Create a data frame for plotting
data <- data.frame(Income = income, CDF = cdf_values, Severity = poverty_gaps_squared)

# Plot the CDF with a tile for severity
p <- ggplot(data, aes(x = Income, y = CDF)) +
  geom_line(color = "blue") +
  geom_area(data = subset(data, Income <= poverty_line), aes(fill = Severity)) +
  scale_fill_gradient(low = "skyblue", high = "blue", guide = "none") +
  geom_vline(xintercept = poverty_line, linetype = "dashed", color = "red") +
  ggtitle("CDF of Income and Visualizing Severity of Poverty (P2)") +
  xlab("Income") + ylab("Cumulative Distribution Function")

# Display the plot
print(p)

# Define parameters for the Beta distribution
alpha <- 2
beta <- 5
n <- 1000  # Number of income points

# Define parameters for the Beta distribution
alpha <- 2
beta <- 15
n <- 1000  # Number of income points

# Generate income data
set.seed(42)
income <- rbeta(n, alpha, beta)

# Calculate the CDF using the empirical method
income_sorted <- sort(income)
cdf <- cumsum(table(income_sorted)/n)

# Calculate the Lorenz curve
total_income <- sum(income_sorted)
cumulative_income <- cumsum(income_sorted)
lorenz <- cumulative_income / total_income

# Create a data frame for plotting
data <- data.frame(
  Income = income_sorted,
  CDF = cdf,
  Lorenz = lorenz,
  Quantile = cdf  # Use CDF as the x-axis for Lorenz for correct alignment
)

# Create the plot
plot <- ggplot(data) +
  geom_line(aes(x = Income, y = CDF), color = "blue", size = 1) +
  geom_line(aes(x = Quantile, y = Lorenz), color = "red", size = 1) +
  labs(x = "Income / Quantile",
       y = "Proportion", title = "CDF and Lorenz Curve") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_minimal()

# Display the plot
print(plot)
