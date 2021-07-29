#' Bayesian Weighted Sums
#'
#' This function fits a Bayesian Weighted Sums as described in
#' Bayesian Weighted Sums: A Flexible Approach to Estimate Summed Mixture Effects.
#' Ghassan B. Hamra 1, Richard F. Maclehose, Lisa Croen, Elizabeth M. Kauffman
#' and Craig Newschaffer. 2021. International Journal of Environmental Research and Public Health.
#' An extension for binary outcome is included.
#'
#' @param iter Number of Hamiltonian Monte Carlo iterations
#' @param y    Am n-vector of outcomes
#' @param X    An n-by-p matrix of mixtures to be weightedly summed
#' @param Z    Default NULL. A matrix of confounders whose linear effects are estimated
#' @param alpha A p-vector of hyperparameters for the Dirichlet prior on the weights.
#' Default to be a vector of 1's.
#' @param family A string "gaussian" for linear regression and "binomial" for logistic regression
#' @param ... Additional arguments for `rstan::sampling`
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @export
bws <- function(iter, y, X, Z=NULL, alpha=NULL, family="gaussian", ...) {
  N <- length(y)
  if (N == 0) stop("Sample size of zero")
  if (length(X) > 0 & is.vector(X)) X <- array(X, dim = c(N, 1))
  P <- ncol(X)
  if (P == 0) stop("No predictors")
  if (is.null(alpha)) alpha <- rep(1, P)
  if (is.null(Z)) Z <- array(0, dim=c(N,1))
  K <- ncol(Z)
  data <- list(y=y, x=X, z=Z, N=N, P=P, K=K, alpha=alpha)
  if (family == "gaussian") {
    fit <- rstan::sampling(stanmodels$bws, data = data, iter = iter, ...)
  } else if (family == "binomial") {
    fit <- rstan::sampling(stanmodels$bwslogistic, data = data, iter = iter, ...)
  } else { stop(paste("Family", family, "not implemented")) }

  return(fit)
}
