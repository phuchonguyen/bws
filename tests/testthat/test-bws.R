test_that("basic model fitting works", {
  N <- 50
  P <- 3
  K <- 2
  X <- matrix(rnorm(N*P), N, P)
  Z <- matrix(rnorm(N*K), N, K)  # confounders
  w <- c(0.3, 0.2, 0.5)
  theta0 <- 0.5
  theta1 <- 1.25
  beta <- runif(K, 0.5, 1.0)
  y <- theta0 + theta1*(X%*%w) + Z%*%beta + rnorm(N)
  iter <- 1000
  fit <- bws::bws(iter = iter, y = y, X = X, Z = Z, refresh = 0,
                  include_intercept = FALSE,
                  chains = 1, cores = 1, show_messages = FALSE) #burn in is iter/2
  samps <- rstan::extract(fit)
  expect_equal(dim(samps$theta0), iter/2)
  expect_equal(dim(samps$theta1), iter/2)
  expect_equal(dim(samps$beta), c(iter/2, K))
  expect_equal(dim(samps$w), c(iter/2, P))
  expect_equal(sum(is.na(samps$sigma)), 0)
  expect_equal(sum(is.na(samps$theta1)), 0)
})

test_that("basic model without Z, no intercept works", {
  N <- 50
  P <- 3
  K <- 0
  X <- matrix(rnorm(N*P), N, P)
  Z <- NULL
  w <- c(0.3, 0.2, 0.5)
  theta0 <- 0.5
  theta1 <- 1.25
  y <- theta0 + theta1*(X%*%w) + rnorm(N)
  iter <- 1000
  fit <- bws::bws(iter = iter, y = y, X = X, Z = Z, refresh = 0,
                  include_intercept = TRUE,
                  chains = 1, cores = 1, show_messages = FALSE) #burn in is iter/2
  samps <- rstan::extract(fit)
  expect_equal(dim(samps$theta0), iter/2)
  expect_equal(dim(samps$theta1), iter/2)
  expect_equal(dim(samps$beta), c(iter/2, K + 1))
  expect_equal(dim(samps$w), c(iter/2, P))
  expect_equal(sum(is.na(samps$sigma)), 0)
  expect_equal(sum(is.na(samps$theta1)), 0)
})

test_that("logistic model fitting works", {
  N <- 50
  P <- 3
  K <- 2
  X <- matrix(rnorm(N*P), N, P)
  Z <- matrix(rnorm(N*K), N, K)  # confounders
  w <- c(0.3, 0.2, 0.5)
  theta0 <- 0.5
  theta1 <- 1.25
  beta <- runif(K, 0.5, 1.0)
  y <- theta0 + theta1*(X%*%w) + Z%*%beta + rnorm(N)
  y <- 1*(y > 0)
  iter <- 1000
  fit <- bws::bws(iter = iter, y = y, X = X, Z = Z, refresh = 0,
                  family = 'binomial', include_intercept = TRUE,
                  chains = 1, cores = 1, show_messages = FALSE) #burn in is iter/2
  samps <- rstan::extract(fit)
  expect_equal(dim(samps$theta0), iter/2)
  expect_equal(dim(samps$theta1), iter/2)
  expect_equal(dim(samps$beta), c(iter/2, K + 1)) # adds intercept
  expect_equal(dim(samps$w), c(iter/2, P))
  expect_equal(sum(is.na(samps$sigma)), 0)
  expect_equal(sum(is.na(samps$theta1)), 0)
})
