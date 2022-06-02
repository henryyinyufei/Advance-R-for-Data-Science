# Control Flow

# if and if-else
if("cat" == "dog") {
  print("cat is dog")
} else {
  print("cat is not dog")
}

# if returns a value
cnd <- if("cat" == "dog") "cat is dog" else "cat is not dog"
cnd

# if expects a single logical
try(if("cat") print("cat"))
if(c("cat"=="dog","cat" == "cat")) print("hello world")

# ifelse(): vectorized if
# syntax is 
# condition, 
# what to return if expression true, 
# what to do if expression false
x <- 1:10
ifelse(x %% 2 == 0, "even","odd")

# switch
x <- 2 # numeric argument
switch(x,"cat","dog","mouse") # evaluate the x'th element

x <- "dog" #character argument
switch(x,cat="hi cat",dog="hi dog",mouse="hi mouse",
       warning("unknown animal")) # if we make it to the last condition

switch("kangaroo",cat="hi cat",dog="hi dog",mouse="hi mouse",
       warning("unknown animal"))

# for loops
n <- 10 
nreps <- 100
x <- vector(mode="numeric",length=nreps)
for(i in 1:nreps) {
  # Code you want to repeat nreps times
  x[i] <- mean(rnorm(n))
}
summary(x)
print(i)

# for loop index set
ind <- c("cat","dog","mouse")
for(i in ind) {
  print(paste("There is a",i,"in my house"))
}

# seq_along
# Creating the index set will not be what you 1:length(x) expect when x has length 0
x <- NULL
for(i in 1:length(x)) print(x[i])

for(i in seq_along(x)) print(x[i])

# while loops
# Use a while loop when you want to continue until some logical condition is met.
set.seed(1)
# Number of coin tosses until first success (geometric distn)
p <- 0.1; counter <- 0; success <- FALSE
while(!success) {
  success <- as.logical(rbinom(n=1,size=1,prob=p))
  counter <- counter + 1
}
counter

# break
for(i in 1:100) {
  if(i>3) break
  print(i)
}

# R Functions
# Example function
f <- function(x) {
  return(x^2)
}
f

# The function body
body(f)

# The function formals
f <- function(x=0) { x^2}
f <- function(x=0,y=3*x) { x^2 + y^2 }
f()
f(x=1)
f(y=1)
formals(f)

# Argument matching when calling a function
# the arguments are matched first by name, then by “prefix�? matching and finally by position
f <- function(firstarg,secondarg) {
  firstarg^2 + secondarg
}
f(firstarg=1,secondarg=2)
f(s=2,f=1)
f(2,f=1)
f(1,2)

# The function environment
f <- function(x) {
  y <- x^2
  ee <- environment() # Returns ID of environment w/in f
  print(ls(ee)) # list objects in ee
  ee
}
f(1) # function call
environment(f)

# Enclosing environments
search()

# R packages and the search list
# install.packages("hapassoc")
library(hapassoc)
search()

# Detaching packages
detach("package:hapassoc")
search()

# Package namespaces
# You can access functions in a package’s namespace without loading the package using the :: operator.
set.seed(321)
n<-30; x<-(1:n)/n; y<-rnorm(n,mean=x); ff<-lm(y~x)
car::sigmaHat(ff)






