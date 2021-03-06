% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mmhp.R
\name{mmhp}
\alias{mmhp}
\title{Create a Markov-modulated Hawkes Process(MMHP) model}
\usage{
mmhp(lambda0, lambda1, alpha, beta, Q = NULL, delta = NULL,
  tau = NULL)
}
\arguments{
\item{lambda0}{parameters for homogeneous Poisson process.}

\item{lambda1}{parameters for Hawkes process.}

\item{alpha}{parameters for Hawkes process.}

\item{beta}{parameters for Hawkes process.}

\item{Q}{transition probability matrix.}

\item{delta}{initial state probability.}

\item{tau}{vector containing the event times. Note that the first event is at time zero. Alternatively, tau could be specified as NULL, meaning that the data will be added later (e.g. simulated).}
}
\value{
mmhp object
}
\description{
Create a Markov-modulated Hawkes Process(MMHP) model according to the given parameters: lambda0, lambda1, alpha, beta, event times and transition probability matrix。
If event time tau is missing, then it means that data will be added later(e.g. simulated)
}
\examples{
Q <- matrix(c(-0.4, 0.4, 0.2, -0.2), ncol = 2, byrow = TRUE)
mmhp(Q, delta = c(1 / 3, 2 / 3), lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2)
}
