//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] d;
  real<lower=0> min_s;
  real<lower=0> max_s;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> theta1;
  real<lower=0> theta2;
  real<lower=0> theta3;
  vector[N-1] x;
  real<lower=0> trans_last_x;
  // real<lower=fmax(0, d[1] - theta2), upper = fmin(x[2], d[1] - theta1)> x[1];
}

transformed parameters {
  real<lower=0> last_x;
  last_x = - 1/theta3 * log(trans_last_x);
}

// transformed data {
//
// }

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  int NewN;
  NewN = N - 2;
  theta1 ~ uniform(0, min_s);
  theta2 ~ uniform(max_s, theta1 + 10);
  theta3 ~ uniform(0, 10);
  x[1] ~ uniform(fmax(0, d[1] - theta2), fmin(x[2], d[1] - theta1));
  for(i in 2:NewN)
    x[i] ~ uniform(fmax(x[i-1], (d[i-1] <= d[i] - theta2) * (d[i] - theta2)), fmin(x[i+1], d[i] - theta2));
  x[N-1] ~ uniform(fmax(x[N-2], (d[N-2] <= d[N-1] - theta2) * (d[N-1] - theta2)), fmin(last_x, d[N-1] - theta2));
  trans_last_x ~ uniform(exp(- theta3 * (d[N] - theta1)), exp(-theta3 * fmax(x[N-1], (d[N-1] <= d[N] - theta2) * (d[N] - theta2))));
}

