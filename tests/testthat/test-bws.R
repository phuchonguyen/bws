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
                  chains = 1, cores = 1, show_messages = FALSE) #burn in is 500
  samps <- rstan::extract(fit)
  expect_equal(dim(samps$theta0), iter/2)
  expect_equal(dim(samps$theta1), iter/2)
  expect_equal(dim(samps$beta), c(iter/2, K))
  expect_equal(dim(samps$w), c(iter/2, P))
  expect_equal(sum(is.na(samps$sigma)), 0)
  expect_equal(sum(is.na(samps$theta1)), 0)
})
