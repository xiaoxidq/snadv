object <- list(lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2, q1 = 0.4, q2 = 0.2, delta = c( 1/3, 2/3))
Q <- matrix(c(-0.4,0.4,0.2,-0.2),ncol=2,byrow=TRUE)

#object <- list(lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2, q1 = 0.4, q2 = 0.2, delta = c( 1, 0))

simulation<-simulate.mmhp(object)
state<-simulation$z
state_time<-simulation$x
tau<-simulation$tau
mmhp(Q,delta = c( 1/3, 2/3),lambda0 = 0.9, lambda1 = 1.1, alpha = 0.8, beta = 1.2)->x
simulatemmhp(x)->y
drawUniMMHPIntensity(x,y)

Q = matrix(c(-0.4,0.4,0.2,-0.2),ncol = 2,byrow = TRUE)
x1<-mmhp(Q, delta = c( 1/3, 2/3), lambda0 = 1, lambda1 = 1.6, alpha = 0.8, beta = 1.2)
par(mfrow=c(1,2))
simulatemmhp(x1,nsim=5)->y1
drawUniMMHPIntensity(x1,y1)
UniMMHPIntensity(x1,y1)->z
m<-length(y1$x)
curve(z,y1$x[1],y1$x[m])
integrate(z,0,y1$tau[2])$value
rescaled(z,y1$tau)
y1

t <- y$tau
state <- y$z
state_time <- y$x
lambda0 <- x$lambda0
lambda1 <- x$lambda1
alpha <- x$alpha
beta <- x$beta