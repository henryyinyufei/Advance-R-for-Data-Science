# week02b exercise

# 1. The following simulation function simulates n replicates of an explanatory variable X and a response variable Y=¦ÂX+E, 
#where ¦Â is a regression coefficient between ???1 and 1 and E¡«N(0,1) is random noise. 
#Run the code chunk and then use the function to simulate one dataset of size n=1000 and save the result in an object called dd
simdat <- function(n) {
  beta <- runif(1,min=-1,max=1)
  x <- rnorm(n)
  y <- beta * x + rnorm(n)
  data.frame(x=x,y=y)
}
dd <- simdat(1000)

# 2. Create a larger dataset by calling simdat() N=500 times over and stacking the results. 
#The larger dataset should have 500*1000 rows and 2 columns. 
#Call your stacked dataset bigd11. 
#To create the stacked dataset, initialize with bigd1 <- NULL and use a for loop to build up bigd1 one layer at a time. 
#Time this code using the system.time() function. An example use of system.time() to time an R command, 
#e.g., x <- rnorm(100000) is:
system.time({
  x <- rnorm(100000) # Could put multiple lines of R code here
})

bigd1 <- function(N=500,n=1000) {
  out <- NULL
  for(i in 1:N){
    ss <- simdat(n)
    out <- rbind(out,ss)
  }
  return(NULL)
}
system.time({
  bigd1()
})

# 3. Repeat 2, but this time, instead of stacking the output of simdat(), coerce the output of simdat() to a matrix, 
#and stack the matrices. Use system.time() to time your code and compare the timing from question (2).

bigd2 <- function(N=500,n=1000) {
  out <- NULL
  for(i in 1:N){
    ss <- as.matrix(simdat(n))
    out <- rbind(out,ss)
  }
  return(NULL)
}

system.time({
  bigd2()
})

# 4.Now build bigd2 by 
# (i) initializing an empty matrix of appropriate dimension, and 
# (ii) looping 500 times and inserting simulated datasets of size n=1000, coerced to matrices, into successive layers of bigd2. 
#Time this code and compare the timing to that of part (3). You may find the following R function useful:
layerInds <- function(layerNum,nrow) {
  ((layerNum-1)*nrow + 1):(layerNum*nrow) 
}
# Example use:
inds <- layerInds(layer=1,nrow=1000)
range(inds)

bigd3 <- function(N=500,n=1000) {
  out <- matrix(NA,nrow=N*n,ncol=2)
  for(i in 1:N){
    inds <- layerInds(layer=i,nrow=n)
    ss <- as.matrix(simdat(n))
    out[inds,] <- ss
  }
  return(NULL)
}


system.time({
  bigd3()
})

# ------------------------------------------------------------
simdat <- function(n) {
  beta <- runif(1,min=-1,max=1)
  x <- rnorm(n)
  y <- beta * x + rnorm(n)
  data.frame(x=x,y=y)
}

bigd1 <- function(N=500,n=1000) {
  out <- NULL
  for(i in 1:N){
    ss <- simdat(n)
    out <- rbind(out,ss)
  }
  return(NULL)
}

bigd2 <- function(N=500,n=1000) {
  out <- NULL
  for(i in 1:N){
    ss <- as.matrix(simdat(n))
    out <- rbind(out,ss)
  }
  return(NULL)
}

layerInds <- function(layerNum,nrow) {
  ((layerNum-1)*nrow + 1):(layerNum*nrow) 
}

bigd3 <- function(N=500,n=1000) {
  out <- matrix(NA,nrow=N*n,ncol=2)
  for(i in 1:N){
    inds <- layerInds(layer=i,nrow=n)
    ss <- as.matrix(simdat(n))
    out[inds,] <- ss
  }
  return(NULL)
}
