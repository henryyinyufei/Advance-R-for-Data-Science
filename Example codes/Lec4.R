# Scoping

# R has four rules:
# Name masking
# Functions versus variables
# A fresh start
# Dynamic lookup

# Name masking
# search order for objects is that names defined inside a function mask names defined outside
x <- y <- 200
z <- 30 # defined in global environment
f <- function() { # f's env enclosed by global
  x <- 100 # defined in f's environment
  y <- 20
  g <- function() { #g's env enclosed by f's
    x <- 10 # defined in g's environment
    c(x,y,z)
  }
  g()
}
f()

# Each function call gets a new environment
# All objects created within the function disappear when the function exits.
x <- 100
f <- function(){
  print(environment())
  x <- x+1
  x
}
f()
f()

# Dynamic lookup
y <- 100
f <- function(x) {
  x + y
}
f(1)
y <- 200
f(1)

# Lazy evaluation
# Function arguments are only evaluated when needed
f<-function(xx,yy) {
  xx
}
f(1) # no value for yy, but OK since yy not used
try(f(yy=1)) # xx is needed

# Variable arguments with . . .
myplot <- function(x,...) {
  plot(x,x^2,...) # pass any args not named x to plot
}
myplot((-5:5),col="red",pch=16)

# Exiting a function
# Functions can exit explicitly with return()
# or implicitly, where the last expression in the function is its return value
# When a function returns, explicitly or implicitly, the default is to print the return value.
ff <- function(x) { x }
ff(1)
# suppress this with invisible().
ff_invis <- function(x) { invisible(x) }
ff_invis(1) # but x <- ff_invis(1) same as x <- ff(1)

# Signalling conditions
# Functions can signal error, warning or message conditions with stop(), warning() and message(), respectively.
# These signals can be ¡°handled¡± by ignoring them, as we have been doing with try(), or implementing a custom handler.

# stop()
centre <- function(x,method) {
  switch(method,
         mean=mean(x),
         median=median(x),
         stop("method ",method," not implemented"))
}
try(centre(1:10,"mymean"))

# warning()
centre <- function(x,method) {
  switch(method,
         mean=mean(x),
         median=median(x),
         {warning("\nmethod ",method,
                  " not implemented, using mean\n");
           mean(x)})
}
centre(1:10,"mymean")

# message()
centre <- function(x,method) {
  switch(method,
         mean=mean(x),
         median=median(x),
         {message("\nmethod ",method,
                  " not implemented, using mean\n");
           mean(x)})
}
centre(1:10,"mymean")

# Exit handlers
# use an exit handler to re-set, even if your function stops
# Use add=TRUE to add more than one handler
rplot <- function(y,x){
  opar <- par(mfrow=c(2,2))
  on.exit(par(opar),add=TRUE) # add=TRUE not nec. in this ex.
  plot(lm(y~x)) #could throw an error
}
y<- rnorm(100); x <- rnorm(10) # different length
try(rplot(y,x)) # Fails, but re-sets par mfrow

# Function forms

# Infix functions
# An infix function has two arguments and is called by putting the name between arguments
`%-%` <- function(set1,set2){
  setdiff(set1,set2)
}
s1 <- 1:10; s2 <- 4:6
s1 %-% s2 # same as `%-%`(s1,s2)

# Replacement functions
# Replacement functions are called to change values
# Must have arguments x and value, and must return the modified object.
x <- c(a=1,b=2)
names(x)

names(x) <- c("aa","bb")
x

x <- `names<-`(x,c("aaa","bbb"))
x

# You can write your own relacement functions if you end the function name with <-
`st360names<-` <- function(x,value){
  names(x) <- paste0(value,"360",names(x))
  x
}
st360names(x) <- c("a","b")
x

# Special functions
dd <- data.frame(x=1:2,y=3:4)
`[[`(dd,1) # compare to dd[[1]]
dd[[1]]

dd <- `[[<-`(dd,1,value=5:6) #cf dd[[1]] <- 5:6
dd

# It can be useful to know functions by name so that we can call them in lapply-like functions.
sapply(dd,`[[<-`,2,value=10)






