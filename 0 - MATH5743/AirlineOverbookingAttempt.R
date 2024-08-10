# in a live lecture, professor mentioned that airline overbooking was on the way
# this is an attempt at addressing the problem using optimization

if(!require(stats)) install.packages("stats", dependencies=TRUE)
library(stats)

# Documenting parameters for the problem upfront
# N --> Number of seats
# p --> Probability of each passenger showing up
# alpha --> Acceptable probability of overbooking
# t_low --> Lower bound for tickets
# t_high --> Upper bound for tickets


# Define the overbooking probability function
# I'm assuming this a binomial problem since each passenger is an independent Bernoulli trial
overbooking_prob <- function(t, N, p) {
  1 - pbinom(N, floor(t), p)  # Ensure t is an integer
}

# Define the optimization function f(t) = P(X > N) - alpha
optimized_booking <- function(t, N, p, alpha) {
  overbooking_prob(t, N, p) - alpha
}

# Using bisection to find the root of the optimization function
# Newton's method kept giving me NaN errors, will have to work more on that
bisection_method <- function(N, p, alpha, t_low, t_high, tol = 1e-6, max_iter = 100) {
  for (i in 1:max_iter) {
    t_mid <- (t_low + t_high) / 2
    ob_low <- optimized_booking(t_low, N, p, alpha)
    ob_mid <- optimized_booking(t_mid, N, p, alpha)
    
    if (abs(ob_mid) < tol) {
      return(list(optimal_t = round(t_mid), iterations = i))
    }
    
    if (ob_low * ob_mid < 0) {
      t_high <- t_mid
    } else {
      t_low <- t_mid
    }
    
    if (abs(t_high - t_low) < tol) {
      return(list(optimal_t = round(t_mid), iterations = i))
    }
  }
  warning("The method did not converge, so sorry :(")
  return(list(optimal_t = round((t_low + t_high) / 2), iterations = max_iter))
}

# Run the function
N <- 1000       # Number of seats
p <- 0.87       # Probability of showing up
alpha <- 0.03  # Acceptable probability of overbooking
t_low <- N     # Lower bound for tickets
t_high <- 2 * N  # Upper bound for tickets, can be adjusted as needed

result <- bisection_method(N, p, alpha, t_low, t_high)
optimal_t <- result$optimal_t
iterations <- result$iterations

# Output the result
optimal_t
iterations