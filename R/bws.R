#' Bayesian Weighted Sums
#'
#' This function fits a Bayesian Weighted Sums as described in
#' Bayesian Weighted Sums: A Flexible Approach to Estimate Summed Mixture Effects.
#' Ghassan B. Hamra 1, Richard F. Maclehose, Lisa Croen, Elizabeth M. Kauffman
#' and Craig Newschaffer. 2021. International Journal of Environmental Research and Public Health.
#'
#' @param iter Number of Hamiltonian Monte Carlo iterations
#' @param y    Am n-vector of outcomes
#' @param X    An n-by-p matrix of mixtures to be weightedly summed
#' @param Z    Default NULL. A matrix of confounders whose linear effects are estimated
#' @param alpha A p-vector of hyperparameters for the Dirichlet prior on the weights.
#' Default to be a vector of 1's.
#' @param ... Additional arguments for `rstan::sampling`
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @export
bws <- function(iter, y, X, Z=NULL, alpha=NULL, ...) {
  N <- length(y)
  if (N == 0) stop("Sample size of zero")
  if (length(X) > 0 & is.vector(X)) X <- array(X, dim = c(N, 1))
  P <- ncol(X)
  if (P == 0) stop("No predictors")
  if (is.null(alpha)) alpha <- rep(1, P)
  if (is.null(Z)) Z <- array(0, dim=c(N,1))
  K <- ncol(Z)

  data <- list(y=y, x=X, z=Z, N=N, P=P, K=K, alpha=alpha)
  fit <- rstan::sampling(stanmodels$bws, data = data, iter = iter, ...)

  return(fit)
}
