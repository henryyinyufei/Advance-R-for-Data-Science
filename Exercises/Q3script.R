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
H <- function(x) { 
  return(as.numeric(x>=0)) 
}
LOF <- function(form,data) {
  ff <- lm(form,data)
  return(sum(residuals(ff)^2))
}
#-------------------------------------

#if(Mmax<2) {
#  warning("Input Mmax must be >= 2; setting to 2")
#  Mmax <- 2
# } 

init_B <- function(N,Mmax) {
  B <- data.frame(matrix(NA,nrow=N,ncol=(Mmax+1)))
  B[,1] <- 1
  names(B) <- c("B0",paste0("B",1:Mmax))
  return(B)
}
split_points <- function(xv,Bm) {
  out <- sort(unique(xv[Bm>0]))
  return(out[-length(out)])
}

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- rnorm(n)