# Week3 exercises
# Control flow
# 1 What type of vector does each of the following return?
ifelse(TRUE, 1, "no")    # double
ifelse(FALSE, 1, "no")   # character
ifelse(NA, 1, "no")      # logical

# 
typeof(ifelse(TRUE, 1, "no"))
typeof(ifelse(FALSE, 1, "no"))
typeof(ifelse(NA, 1, "no"))

# 2. Re-write the following using switch
IQR_mid <- function(x) mean(quantile(x,c(.25,.75)))
cc <- function(x,method) {
  if(method=="mean") {
    mean(x)
  } else if(method=="median") {
    median(x)
  } else if(method=="IQR_mid") {
    IQR_mid(x)
  } else stop("entering method ",method," not implemented")
}
set.seed(123)
x <- c(-3,rnorm(100),1000)
cc(x,"mean")
cc(x,"median")
cc(x,"IQR_mid")
try(cc(x,"cat"))

#
Q2 <- function(x,method) {
  switch(method,
         mean = mean(x),
         median = median(x),
         IQR_mid = IQR_mid(x),
         stop("entering method ",method," not implemented"))
}
set.seed(123)
x <- c(-3,rnorm(100),1000)
Q2(x,"mean")
Q2(x,"median")
Q2(x,"IQR_mid")
try(Q2(x,"cat"))

# 3. Rewrite the following function so that it uses a while() loop instead of the for() loop and break statement. 
#Your while-approach will not require the maxit upper limit on the number of iterations.
rtruncNormal <- function(thresh = 2, maxit=1000) {
  x<-NULL
  for(i in 1:maxit) {
    xnew <- rnorm(n=1)
    if(xnew>thresh) {
      break
    }
    x <- c(x,xnew)
  }
  x
}
set.seed(1234)
rtruncNormal()

#
Q3 <- function(thresh = 2) {
  x <- NULL
  flag <- FALSE
  while (!flag) {
    xnew = rnorm(n=1)
    flag <- xnew > 2
    if (xnew > 2) break
    x <- c(x,xnew)
  }
  x 
}
set.seed(1234)
Q3()

# Functions
# 4. The following code chunk is typed into the R Console.
# What is the output of the function call f(5)?
#  What is the enclosing environment of f()?
#  What is the enclosing environment of g()?
#  What search order does R use to find the value of x when it is needed in g()?
x <- 1
f <- function(y) {
  g <- function(z) {
    (x+z)^2
  }
  g(y)
}
f(5) # 36

# The enclosing environment of f() is .GlobalEnv.
# The enclosing environment of g() is the environment of f().
# R searches for the value of x when it is needed in g() first in the environment of g(), 
#then the environment of f() and finally .GlobalEnv
