% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulatemmhp.R
\name{simulatemmhp}
\alias{simulatemmhp}
\title{Simulate Markov Modulated Hawkes Process}
\usage{
simulatemmhp(object, nsim = 1, given_state = FALSE, states = NULL,
  seed = NULL, ...)
}
\arguments{
\item{object}{a mmhp object including its Q, delta, tau, lambda0, lambda1, beta and alpha.}

\item{nsim}{number of points to simulate.}

\item{given_state}{if the hidden state trajectory is given. It `TRUE`, then simulate according to the given state. Default to `FALSE`}

\item{states}{an object containing:
- z: the states of Markov Process,
- x: time of each transition of Markov process
- ending: preset ending time for the process}

\item{seed}{seed for the random number generator.}

\item{...}{other arguments.}
}
\value{
simulated Markov Modulated Hawkes Process, including states of Markov Process, time of each transition of Markoc Process, state at each event, times of Poisson events.
}
\description{
Simulate Markov Modulated Hawkes Process (including all the history) according to a mmhp object
}
\examples{
Q <- matrix(c(-0.4, 0.4, 0.2, -0.2), ncol = 2, byrow = TRUE)
x <- mmhp(Q, delta = c(1 / 3, 2 / 3), lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2)
simulatemmhp(x)
}
