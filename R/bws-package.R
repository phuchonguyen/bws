#' The 'bws' package.
#'
#' @description An interface to the Bayesian Weighted Sums model implemented in
#'   RStan. It estimates the summed effect of multiple, often moderately to
#'   highly correlated, continuous predictors. Its applications can be found in
#'   analysis of exposure mixtures. The model was proposed by Hamra, Maclehose,
#'   Croen, Kauffman, and Newschaffer (2021) This implementation include an
#'   extension to model binary outcome.
#'
#' @docType package
#' @name bws-package
#' @aliases bwspackage
#' @useDynLib bws, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @importFrom rstan sampling
#'
#' @references Stan Development Team (2020). RStan: the R interface to Stan. R
#' package version 2.21.2. https://mc-stan.org
#'
NULL
