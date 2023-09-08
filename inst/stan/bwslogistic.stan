//
// Logistic version of BWS

data {
  int<lower=1> N;
  int<lower=1> P;
  int<lower=0> K;
  matrix[N, P] x;
  matrix[N, K] z;
  vector<lower=0>[P] alpha;  // Weights prior
  array[N] int<lower=0,upper=1> y;
}

parameters {
  real theta0;  // Regression intercept
  real theta1;  // Regression slope
  vector[K] beta;  // Covariates coefficients
  simplex[P] w;  // Weights
}

model {
  theta1 ~ normal(0, 100);   // vague prior
  beta ~ normal(0, 100);
  w ~ dirichlet(alpha);  // prior
  y ~ bernoulli_logit(theta0 + theta1 * (x * w) + z * beta);  // likelihood
}
