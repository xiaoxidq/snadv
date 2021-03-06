#' Simulate Markov Modulated Hawkes Process
#'
#' Simulate Markov Modulated Hawkes Process (including all the history) according to a mmhp object
#'
#' @param object a mmhp object including its Q, delta, tau, lambda0, lambda1, beta and alpha.
#' @param nsim number of points to simulate.
#' @param seed seed for the random number generator.
#' @param given_state if the hidden state trajectory is given. It `TRUE`, then simulate according to the given state. Default to `FALSE`
#' @param states an object containing:
#'              - z: the states of Markov Process,
#'              - x: time of each transition of Markov process
#'              - ending: preset ending time for the process
#' @param ... other arguments.
#' @importFrom stats rexp
#'
#' @return simulated Markov Modulated Hawkes Process, including states of Markov Process, time of each transition of Markoc Process, state at each event, times of Poisson events.
#' @export
#' @examples
#' Q <- matrix(c(-0.4, 0.4, 0.2, -0.2), ncol = 2, byrow = TRUE)
#' x <- mmhp(Q, delta = c(1 / 3, 2 / 3), lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2)
#' simulatemmhp(x)
simulatemmhp <- function(object, nsim = 1, given_state = FALSE, states = NULL, seed = NULL, ...) {
  if (!is.null(seed)) set.seed(seed)
  m <- 2
  #------------------------
  if (sum(object$delta) != 1) stop("Invalid delta")
  if (any(object$delta == 1)) {
    initial <- (1:m)[as.logical(object$delta)]
  } else {
    initial <- sample(m, 1, prob = object$delta)
  }
  #------------------------
  Q <- object$Q
  lambda0 <- object$lambda0
  lambda1 <- object$lambda1
  alpha <- object$alpha
  beta <- object$beta

  Pi <- diag(m) - diag(1 / diag(Q)) %*% Q
  zt <- rep(NA, nsim + 1)
  tau <- rep(NA, nsim + 1)
  #------------------------ initialization for Markov process
  #    the length of x and z may be too short
  #    gets extended later if required
  if (given_state == FALSE) {
    x <- rep(NA, nsim * 10)
    z <- rep(NA, nsim * 10)
    z[1] <- zt[1] <- initial
    x[1] <- tau[1] <- 0
    lambda.max <- 0
    i <- 1 # index for state
    j <- 2 # index for event
    #------------------------ initialization for Hawkes process

    while (j < nsim + 2) {
      i <- i + 1
      #   extend x and z if too short
      if (i > length(x)) {
        x <- c(x, rep(NA, nsim * 10))
        z <- c(z, rep(NA, nsim * 10))
      }
      #   sim time spent in Markov state y[i-1]
      z[i] <- sample(x = 1:m, size = 1, prob = Pi[(z[i - 1]), ])
      x[i] <- x[i - 1] + rexp(1, rate = -Q[z[i - 1], z[i - 1]])
      t0 <- x[i - 1]

      if (z[i - 1] == 1) {
        #   sim times of Hawkes Poisson events
        simulate.result <- simulatehp(lambda1, alpha, beta, x[i - 1], x[i], tau[1:(j - 1)])
        hp <- simulate.result$t
        lambda.max <- ifelse(lambda.max > simulate.result$lambda.max, lambda.max, simulate.result$lambda.max)
        if (!hp[1] == 0) {
          tau[j:(j + length(hp) - 1)] <- hp
          zt[j:(j + length(hp) - 1)] <- z[i - 1]
          j <- j + length(hp)
        }
      }

      if (z[i - 1] == 2) {
        while (j < nsim + 2) {
          #   sim times of Poisson events
          ti <- t0 + rexp(1, rate = lambda0)
          if (ti < x[i]) {
            tau[j] <- t0 <- ti
            zt[j] <- z[i - 1]
            j <- j + 1
          }
          else {
            break
          }
        }
      }
    }
    return(list(x = x[1:i], z = z[1:i], tau = tau[1:(nsim + 1)], zt = zt[1:(nsim + 1)], lambda.max = lambda.max))
  } else {
    x <- states$x
    z <- states$z
    ending <- states$ending
    zt[1] <- z[1]
    tau[1] <- 0
    lambda.max <- 0
    i <- 1 # index for state
    j <- 2 # index for event
    #------------------------ initialization for Hawkes process

    while (tau[j - 1] <= ending & i < length(x)) {
      i <- i + 1
      t0 <- x[i - 1]

      if (z[i - 1] == 1) {
        #   sim times of Hawkes Poisson events
        simulate.result <- simulatehp(lambda1, alpha, beta, x[i - 1], x[i], tau[1:(j - 1)])
        hp <- simulate.result$t
        lambda.max <- ifelse(lambda.max > simulate.result$lambda.max, lambda.max, simulate.result$lambda.max)
        if (!hp[1] == 0) {
          tau[j:(j + length(hp) - 1)] <- hp
          zt[j:(j + length(hp) - 1)] <- z[i - 1]
          j <- j + length(hp)
        }
      }

      if (z[i - 1] == 2) {
        while (tau[j - 1] <= ending) {
          #   sim times of Poisson events
          ti <- t0 + rexp(1, rate = lambda0)
          if (ti < x[i]) {
            tau[j] <- t0 <- ti
            zt[j] <- z[i - 1]
            j <- j + 1
          }
          else {
            break
          }
        }
      }
    }
    return(list(tau = tau[1:(j - 1)][tau[1:(j - 1)] <= ending], zt = zt[1:(j - 1)][tau[1:(j - 1)] <= ending], lambda.max = lambda.max))
  }
}
