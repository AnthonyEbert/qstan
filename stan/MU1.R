
library(rstan)

theta1 = 2
theta2 = 7
theta3 = 3
n = 50

a = cumsum(rexp(n, theta3))
s = runif(n, theta1, theta2)

d = as.numeric(queuecomputer::queue(a, s))

dat <- list(N = n, d = d, min_s = min(s), max_s = max(s))

fit <- stan(
  file = "stan/MU1.stan",
  model_name = "example",
  data = dat,
  iter = 50,
  init = list(list(x = a[-n], trans_last_x = exp(-a[n]))),
  chains = 1,
  pars = c("theta1", "theta2", "theta3")
)
