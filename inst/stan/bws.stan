// The input data is a vector 'y' of length 'N', and matrix 'X' of dimension 'N x P'.
data {
  int<lower=1> N;
  int<lower=1> P;
  int<lower=0> K;
  matrix[N, P] x;
  matrix[N, K] z;
  vector<lower=0>[P] alpha;  // Weights prior
  vector[N] y;
}

parameters {
  real theta0;  // Regression intercept
  real theta1;  // Regression slope
  vector[K] beta;  // Covariates coefficients
  simplex[P] w;  // Weights
  real<lower=0> sigma;
}

model {
  theta1 ~ normal(0, 100);   // vague prior
  beta ~ normal(0, 100);
  w ~ dirichlet(alpha);  // prior
  y ~ normal(theta0 + theta1 * (x * w) + z * beta, sigma);  // likelihood
}



