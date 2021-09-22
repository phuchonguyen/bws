
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bws

<!-- badges: start -->

<!-- badges: end -->

The goal of bws is to provide a user-friendly and efficient
implementation of the Bayesian Weighted Sums (BWS) described by Hamra,
Maclehose, Croen, Kauffman, and Newschaffer (2021) with some extensions
to work with binary and count response data.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("phuchonguyen/bws")
```

## Example

This is a basic example which shows you how to fit BWS:

``` r
library(bws)
## We first need to simulate some data
set.seed(123)
N <- 100
P <- 3
K <- 2
X <- matrix(rnorm(N*P), N, P)
Z <- matrix(rnorm(N*K), N, K)  # confounders
w <- gtools::rdirichlet(1, rep(1, P))
theta0 <- 2
theta1 <- 3
beta <- runif(K, 0.5, 1.5)
y <- theta0 + theta1*tcrossprod(X, w) + Z%*%beta + rnorm(N)
y <- as.vector(y)
## Fitting BWS is simple
fit <- bws::bws(iter = 2000, y = y, X = X, Z = Z,
         # additional arguments for rstan::sampling
         chains = 4, cores = 2, show_messages = FALSE)
```

Since the implementation uses Stan and returns an `rstanfit` object,
users can enjoy all the functionalities provided in `rstan` to analyze
the fitted
model:

``` r
rstan::traceplot(fit, pars = c("w", "theta1"), inc_warmup = TRUE, nrow = 2)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
print(fit, pars = c("w", "theta1"))
#> Inference for Stan model: bws.
#> 4 chains, each with iter=2000; warmup=1000; thin=1; 
#> post-warmup draws per chain=1000, total post-warmup draws=4000.
#> 
#>        mean se_mean   sd 2.5%  25%  50%  75% 97.5% n_eff Rhat
#> w[1]   0.05       0 0.03 0.00 0.03 0.05 0.07  0.12  2010    1
#> w[2]   0.68       0 0.04 0.61 0.66 0.68 0.70  0.75  2401    1
#> w[3]   0.27       0 0.03 0.21 0.25 0.27 0.28  0.32  3361    1
#> theta1 2.88       0 0.18 2.55 2.76 2.88 3.00  3.24  2038    1
#> 
#> Samples were drawn using NUTS(diag_e) at Wed Sep 22 00:33:37 2021.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
rstan::plot(fit)
#> ci_level: 0.8 (80% intervals)
#> outer_level: 0.95 (95% intervals)
```

<img src="man/figures/README-unnamed-chunk-2-2.png" width="100%" />

The model inferred the correct weights, which are set to 0.08, 0.71,
0.22 in the simulation.

## Reference:

Hamra, G.B.; Maclehose, R.F.; Croen, L.; Kauffman, E.M.; Newschaffer, C.
Bayesian Weighted Sums: A Flexible Approach to Estimate Summed Mixture
Effects. *Int. J. Environ. Res. Public Health* **2021**, *18*, 1373.
<https://doi.org/10.3390/ijerph18041373>
