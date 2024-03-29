% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bws.R
\name{bws}
\alias{bws}
\title{Bayesian Weighted Sums}
\usage{
bws(
  iter,
  y,
  X,
  Z = NULL,
  alpha = NULL,
  family = "gaussian",
  include_intercept = TRUE,
  ...
)
}
\arguments{
\item{iter}{Number of Hamiltonian Monte Carlo iterations}

\item{y}{Am n-vector of outcomes}

\item{X}{An n-by-p matrix of mixtures to be weighted-summed}

\item{Z}{A matrix of confounders whose linear effects are estimated.
Default NULL that includes the intercept if include_intercept is TRUE.}

\item{alpha}{A p-vector of hyperparameters for the Dirichlet prior on the
weights. Default to be a vector of 1's.}

\item{family}{A string "gaussian" for linear regression and "binomial" for
logistic regression.}

\item{include_intercept}{Default TRUE, adds column of 1 to Z.}

\item{...}{Additional arguments for \code{rstan::sampling}}
}
\value{
An object of class \code{stanfit} returned by \code{rstan::sampling}
}
\description{
Fits a Bayesian Weighted Sums as described in Bayesian Weighted Sums: A
Flexible Approach to Estimate Summed Mixture Effects. Ghassan B. Hamra 1,
Richard F. MacLehose, Lisa Croen, Elizabeth M. Kauffman and Craig
Newschaffer. 2021. International Journal of Environmental Research and Public
Health. An extension for binary outcome is included.
}
\examples{
N <- 50; P <- 3; K <- 2
X <- matrix(rnorm(N*P), N, P)
Z <- matrix(rnorm(N*K), N, K)  # confounders
theta0 <- 0.5; theta1 <- 1.25
w <- c(0.3, 0.2, 0.5)
beta <- c(0.5, 0.3)
y <- theta0 + theta1*(X\%*\%w) + Z\%*\%beta + rnorm(N)
fit <- bws::bws(iter = 2000, y = y, X = X, Z = Z, family = "gaussian",
                chains = 2, cores = 2, refresh = 0)
}
