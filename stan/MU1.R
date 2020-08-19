
library(rstan)
library(parallel)
options(mc.cores = parallel::detectCores())
library(queuecomputer)

sessionInfo()

seed <- 1
set.seed(seed)

cl <- makeCluster(parallel::detectCores())

theta1 = 1
theta2 = 5
theta3 = 0.2
n = 50

a = cumsum(rexp(n, theta3))
s = runif(n, theta1, theta2)

d = as.numeric(queuecomputer::queue(a, s))

dat <- list(N = n, d = d, min_s = min(s), max_s = max(s))

fit <- stan(
  file = "stan/MU1.stan",
  model_name = "example",
  data = dat,
  iter = 50000,
  init = rep(list(list(x = a[-n], trans_last_x = exp(-theta3 * a[n]), theta1 = theta1, theta2 = theta2, theta3 = theta3)), parallel::detectCores()),
  chains = parallel::detectCores(),
  cores = parallel::detectCores(),
  pars = c("theta1", "theta2", "theta3"),
  control = list(max_treedepth = 15, adapt_delta = 0.99)
)

save(fit, file = "fit_NUTS.RData")
