#' Bayesian Weighted Sums
#'
#' Fits a Bayesian Weighted Sums as described in Bayesian Weighted Sums: A
#' Flexible Approach to Estimate Summed Mixture Effects. Ghassan B. Hamra 1,
#' Richard F. MacLehose, Lisa Croen, Elizabeth M. Kauffman and Craig
#' Newschaffer. 2021. International Journal of Environmental Research and Public
#' Health. An extension for binary outcome is included.
#'
#' @param iter Number of Hamiltonian Monte Carlo iterations
#' @param y    Am n-vector of outcomes
#' @param X    An n-by-p matrix of mixtures to be weighted-summed
#' @param Z    Default NULL. A matrix of confounders whose linear effects are
#'   estimated
#' @param alpha A p-vector of hyperparameters for the Dirichlet prior on the
#'   weights. Default to be a vector of 1's.
#' @param family A string "gaussian" for linear regression and "binomial" for
#'   logistic regression
#' @param ... Additional arguments for `rstan::sampling`
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @examples
#' \dontrun{
#' N <- 50; P <- 3; K <- 2
#' X <- matrix(rnorm(N*P), N, P)
#' Z <- matrix(rnorm(N*K), N, K)  # confounders
#' theta0 <- 0.5; theta1 <- 1.25
#' w <- c(0.3, 0.2, 0.5)
#' beta <- c(0.5, 0.3)
#' y <- theta0 + theta1*(X%*%w) + Z%*%beta + rnorm(N)
#' fit <- bws::bws(iter = 2000, y = y, X = X, Z = Z, family = "gaussian",
#'                 chains = 4, cores = 2, show_messages = FALSE)
#' plot(fit)
#' }
#' @export
bws <- function(iter, y, X, Z=NULL, alpha=NULL, family="gaussian", ...) {
  y <- as.vector(y)
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
