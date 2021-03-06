#' Draw the intensity of the Markov-modulated Hawkes Process(MMHP)
#'
#' Take a mmhp object and draw its intensity accordingly
#'
#' @param mmhp a mmhp object including its state, state_time, tau, lambda0, lambda1, beta and alpha.
#' @param simulation the simulated Markov-modulated Hawkes Process(MMHP)
#' @param yupper upper limit of y axis of the plot.
#' @param add logical; if TRUE add to an already existing plot; if NA start a new plot taking the defaults for the limits and log-scaling of the x-axis from the previous plot. Taken as FALSE (with a warning if a different value is supplied) if no graphics device is open.
#' @param color A specification for the default plotting color.
#' @param given_main title of the plot.
#' @importFrom graphics plot
#' @importFrom graphics points
#' @importFrom graphics legend

#' @export
#' @examples
#' Q <- matrix(c(-0.4, 0.4, 0.2, -0.2), ncol = 2, byrow = TRUE)
#' x <- mmhp(Q, delta = c(1 / 3, 2 / 3), lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2)
#' y <- simulatemmhp(x)
#' drawUniMMHPIntensity(x, y)
drawUniMMHPIntensity <- function(mmhp, simulation, yupper = 10, add = FALSE, color = 1, given_main = "Intensity Plot of MMHP") {
  # input mmhp: mmhp object generated by mmhp.R
  t <- simulation$tau
  state <- simulation$z
  state_time <- simulation$x
  lambda0 <- mmhp$lambda0
  lambda1 <- mmhp$lambda1
  alpha <- mmhp$alpha
  beta <- mmhp$beta

  n <- length(t)
  m <- length(state)

  if (add == FALSE) {
    graphics::plot(0, 0,
      xlim = c(0, state_time[m]), ylim = c(0, yupper), type = "n", xlab = "Time", ylab = "Intensity",
      main = given_main
    )
    graphics::points(t[-1], rep(lambda0 / 2, n - 1), cex = 0.6, pch = ifelse(mmhp$tau_state[-1] == 1, 16, 1), col = "blue")
    points(state_time, rep(lambda0, m), cex = 0.6, pch = 4, col = "red")
  }
  for (i in 1:(m - 1)) {
    if (state[i] == 1) {
      hawkes_time <- t[t >= state_time[i] & t < state_time[i + 1]]
      if (i == 1) hawkes_time <- hawkes_time[-1]
      history <- t[t < state_time[i]]
      drawHPIntensity(lambda1, i, alpha, beta, state_time[i], state_time[i + 1], history[-1], hawkes_time, color = color)
    } else {
      segments(x0 = state_time[i], x1 = state_time[i + 1], y0 = lambda0, lty = 2, col = color)
    }
  }

  if (add == FALSE) {
    graphics::legend("topleft", c("Hawkes event", "Poisson process event", "state change point"),
      col = c("blue", "blue", "red"),
      pch = c(16, 1, 4)
    )
  } else {
    legend("topright", c("True", "Estimation"), col = c("black", color), lty = c(1, 1))
  }
}
