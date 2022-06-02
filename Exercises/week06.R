source('Q3script.R')

# 1.
# The code chunk at the end of this set of exercises throws an error. 
#Cut-and-paste the error into a google search. Read the first few hits and see if any are informative.

# 2.
# What function was called when the error was triggered?

# the subsetting function for data frames, [.data.frame

# 3.
# Run traceback to see the call stack. What is the last function that you wrote to be called? 
# Which line of recpart_fwd() called this function?
recpart_fwd(y,x,Mmax=9)
traceback()
# 7: stop("undefined columns selected")
# 6: `[.data.frame`(xv, Bm > 0) at Q3script.R#53
# 5: xv[Bm > 0] at Q3script.R#53
# 4: unique(xv[Bm > 0]) at Q3script.R#53
# 3: sort(unique(xv[Bm > 0])) at Q3script.R#53
# 2: split_points(x[, v], B[, m]) at Q3script.R#12
# 1: recpart_fwd(y, x, Mmax = 9)

# split_points(), called at line 12.

# 4.
# Modify the code by removing the for-loop over M and setting M to 1. Does the modified code throw an error?
recpart_fwd <- function(y,x,Mmax){
  N <- length(y) # sample size
  n <- ncol(x) # number of predictors
  B <- init_B(N,Mmax) # Exercise: write init_B()
  splits <- data.frame(m=rep(NA,Mmax),v=rep(NA,Mmax),t=rep(NA,Mmax))
  #---------------------------------------------------
  # Looping for forward selection:
    M <- 1
    lof_best <- Inf
    for(m in 1:M) { # choose a basis function to split
      for(v in 1:n){ # select a variable to split on
        tt <- split_points(x[,v],B[,m]) # Exercise: write split_points() 
        for(t in tt) { 
          Bnew <- data.frame(B[,(1:M)[-m]],
                             Btem1=B[,m]*(x[,v]>t),Btem2=B[,m]*(x[,v]<=t)) 
          gdat <- data.frame(y=y,Bnew)
          lof <- LOF(y~.,gdat) #  Use your LOF() from week 4
          if(lof < lof_best) { 
            lof_best <- lof
            splits[M,] <- c(m,v,t) # will
          } # end if
        } # end loop over splits
      } # end loop over variables
      n <- n-1
    } # end loop over basis functions to split
    m <- splits[M,1]; v <- splits[M,2]; t <- splits[M,3]
    B[,M+1] <- B[,m]*(x[,v]<=t)
    B[,m] <- B[,m]*(x[,v]>t)
  return(list(B=B,splits=splits))
}
recpart_fwd(y,x,Mmax=9)
# NO

# 5. 
# Un-do your modification from question 4. Insert a browser() at line 12 of recpart_fwd() 
# (just inside the for loop over v) and run the function.

# i). When browser() stops the function, print out the value of v and n. 
recpart_fwd <- function(y,x,Mmax){
  N <- length(y) # sample size
  n <- ncol(x) # number of predictors
  B <- init_B(N,Mmax) # Exercise: write init_B()
  splits <- data.frame(m=rep(NA,Mmax),v=rep(NA,Mmax),t=rep(NA,Mmax))
  #---------------------------------------------------
  # Looping for forward selection:
  for(M in 1:Mmax) { # contrast to indexing 2...Mmax in Friedman
    lof_best <- Inf
    for(m in 1:M) { # choose a basis function to split
      for(v in 1:n){ # select a variable to split on
        browser()
        tt <- split_points(x[,v],B[,m]) # Exercise: write split_points() 
        for(t in tt) { 
          Bnew <- data.frame(B[,(1:M)[-m]],
                             Btem1=B[,m]*(x[,v]>t),Btem2=B[,m]*(x[,v]<=t)) 
          gdat <- data.frame(y=y,Bnew)
          lof <- LOF(y~.,gdat) #  Use your LOF() from week 4
          if(lof < lof_best) { 
            lof_best <- lof
            splits[M,] <- c(m,v,t) # will
          } # end if
        } # end loop over splits
      } # end loop over variables
      n <- n-1
    } # end loop over basis functions to split
    m <- splits[M,1]; v <- splits[M,2]; t <- splits[M,3]
    B[,M+1] <- B[,m]*(x[,v]<=t)
    B[,m] <- B[,m]*(x[,v]>t)
  } # end loop over M
  return(list(B=B,splits=splits))
}
recpart_fwd(y,x,Mmax=9)

# > recpart_fwd(y,x,Mmax=9)
# Called from: recpart_fwd(y, x, Mmax = 9)
# Browse[1]> print(n)
# [1] 2
# Browse[1]> v
# [1] 1

# ii). Step through the function with n a few times and then type c to continue execution to the next call to browser(). 
# Print v again.
recpart_fwd(y,x,Mmax=9)

# > recpart_fwd(y,x,Mmax=9)
# Called from: recpart_fwd(y, x, Mmax = 9)
# Browse[1]> n
# debug at #13: tt <- split_points(x[, v], B[, m])
# Browse[2]> n
# debug at #14: for (t in tt) {
# Bnew <- data.frame(B[, (1:M)[-m]], Btem1 = B[, m] * (x[, 
#                                                        v] > t), Btem2 = B[, m] * (x[, v] <= t))
# gdat <- data.frame(y = y, Bnew)
# lof <- LOF(y ~ ., gdat)
# if (lof < lof_best) {
#   lof_best <- lof
#   splits[M, ] <- c(m, v, t)
# }
# }
# Browse[2]> n
# debug at #15: Bnew <- data.frame(B[, (1:M)[-m]], Btem1 = B[, m] * (x[, v] > 
# t), Btem2 = B[, m] * (x[, v] <= t))
# Browse[2]> c
# debug at #12: browser()
# Browse[2]> v
# [1] 2

# iii). Use f to finish execution of the v-loop. Print v again. Repeat a few times until the function stops. 
# What was the value of v just before the crash?
recpart_fwd(y,x,Mmax=9)

# > recpart_fwd(y,x,Mmax=9)
# Called from: recpart_fwd(y, x, Mmax = 9)
# Browse[1]> f
# Browse[2]> f
# Called from: recpart_fwd(y, x, Mmax = 9)
# Browse[1]> f
# Called from: recpart_fwd(y, x, Mmax = 9)
# Browse[1]> f
# Browse[2]> v
# [1] 0

# 6.
# Remove your browser() and type debug(recpart_fwd). Now run the function under the debugger. 
#Type out the value of a few of the variables as you go. When you are done, type undebug(recpart_fwd) to stop debugging.
recpart_fwd <- function(y,x,Mmax){
  N <- length(y) # sample size
  n <- ncol(x) # number of predictors
  B <- init_B(N,Mmax) # Exercise: write init_B()
  splits <- data.frame(m=rep(NA,Mmax),v=rep(NA,Mmax),t=rep(NA,Mmax))
  #---------------------------------------------------
  # Looping for forward selection:
  for(M in 1:Mmax) { # contrast to indexing 2...Mmax in Friedman
    lof_best <- Inf
    for(m in 1:M) { # choose a basis function to split
      for(v in 1:n){ # select a variable to split on
        tt <- split_points(x[,v],B[,m]) # Exercise: write split_points() 
        for(t in tt) { 
          Bnew <- data.frame(B[,(1:M)[-m]],
                             Btem1=B[,m]*(x[,v]>t),Btem2=B[,m]*(x[,v]<=t)) 
          gdat <- data.frame(y=y,Bnew)
          lof <- LOF(y~.,gdat) #  Use your LOF() from week 4
          if(lof < lof_best) { 
            lof_best <- lof
            splits[M,] <- c(m,v,t) # will
          } # end if
        } # end loop over splits
      } # end loop over variables
      n <- n-1
    } # end loop over basis functions to split
    m <- splits[M,1]; v <- splits[M,2]; t <- splits[M,3]
    B[,M+1] <- B[,m]*(x[,v]<=t)
    B[,m] <- B[,m]*(x[,v]>t)
  } # end loop over M
  return(list(B=B,splits=splits))
}

debug(recpart_fwd)
recpart_fwd(y,x,Mmax=9)
undebug(recpart_fwd)

# 7. Insert print() or cat() statements at around line 12 of recpart_fwd() to print out the values of v and n. Re-run recpart_fwd()
recpart_fwd <- function(y,x,Mmax){
  N <- length(y) # sample size
  n <- ncol(x) # number of predictors
  B <- init_B(N,Mmax) # Exercise: write init_B()
  splits <- data.frame(m=rep(NA,Mmax),v=rep(NA,Mmax),t=rep(NA,Mmax))
  #---------------------------------------------------
  # Looping for forward selection:
  for(M in 1:Mmax) { # contrast to indexing 2...Mmax in Friedman
    lof_best <- Inf
    for(m in 1:M) { # choose a basis function to split
      for(v in 1:n){ # select a variable to split on
        cat("--------------------\n")
        cat("v is:", v, "\n")
        cat("n is:", n, "\n")
        tt <- split_points(x[,v],B[,m]) # Exercise: write split_points() 
        for(t in tt) { 
          Bnew <- data.frame(B[,(1:M)[-m]],
                             Btem1=B[,m]*(x[,v]>t),Btem2=B[,m]*(x[,v]<=t)) 
          gdat <- data.frame(y=y,Bnew)
          lof <- LOF(y~.,gdat) #  Use your LOF() from week 4
          if(lof < lof_best) { 
            lof_best <- lof
            splits[M,] <- c(m,v,t) # will
          } # end if
        } # end loop over splits
      } # end loop over variables
      n <- n-1
    } # end loop over basis functions to split
    m <- splits[M,1]; v <- splits[M,2]; t <- splits[M,3]
    B[,M+1] <- B[,m]*(x[,v]<=t)
    B[,m] <- B[,m]*(x[,v]>t)
  } # end loop over M
  return(list(B=B,splits=splits))
}

recpart_fwd(y,x,Mmax=9)

# > recpart_fwd(y,x,Mmax=9)
# --------------------
#   v is: 1 
# n is: 2 
# --------------------
#   v is: 2 
# n is: 2 
# --------------------
#   v is: 1 
# n is: 1 
# --------------------
#   v is: 1 
# n is: 0 
# --------------------
#   v is: 0 
# n is: 0 
# Error in `[.data.frame`(xv, Bm > 0) : undefined columns selected