library(sloop)

source('recpart.R')
# 1. 
# Using OOP terminology, what is the difference between t.test() and t.data.frame(). When is each function called?
ftype(t.test)
# [1] "S3"      "generic"
ftype(t.data.frame)
# [1] "S3"     "method"

# t.test() is a generic function that performs a t-test.
# t.data.frame() is a method that gets called by the generic t() to transpose data frame input.

# 2.
# Describe the difference in behaviour in the following two calls to mean().
set.seed(1014)
some_days <- as.Date("2017-01-31") + sample(10, 5)

mean(some_days)
mean(unclass(some_days))
# mean() is a generic function, which will select the appropriate method based on the class of the input. 
# some_days has the class Date and 
# mean.Date(some_days) will be used to calculate the mean date of some_days

# After unclass() has removed the class attribute from some_date, the default method is chosen. 
# mean.default(unclass(some_days)) then calculates the mean of the underlying double.

# 3.
# Refer to the lecture 7 notes. 
# Write a validator and helper for the node class discussed on page 14. 
# Have the validator check that the node¡¯s data is a region object. 
# The helper should take the x and y data as input and should call the validator.
new_node <- function(data,childl=NULL,childr=NULL){
  structure(list(data=data,childl=childl,childr=childr),
            class="node")
}

# ----------------------------------------------------------------------
new_region <- function(coords=NULL,x,y){
  if(is.null(coords)) {
    coords <- sapply(x,range)
  }
  out <- list(coords=coords,x=x,y=y)
  class(out) <- "region"
  out
}
# ----------------------------------------------------------------------

# validator ------------------------------------------------------------
validate_node <- function(node){
  x <- as.data.frame(node$data$x)
  y <- as.data.frame(node$data$y)
  if (!all((nrow(x) > 0) & nrow(y) > 0))
    stop(
      "Length of x and length of y must be larger than 0",
      call. = FALSE
    )
  if (nrow(x) != nrow(y))
    stop(
      "Length of x and length of y must be equal to make it a region",
      call. = FALSE
    )
  return(node)
}
# test
set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- rnorm(n)
nr <- new_region(x=x,y=y)
nr
validate_node(new_node(nr))

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n-1),x2=rnorm(n-1))
y <- rnorm(n)
nr <- new_region(x=x,y=y)
nr
validate_node(new_node(nr))

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- NULL
nr <- new_region(x=x,y=y)
nr
validate_node(new_node(nr))
# ----------------------------------------------------------------------


# helper ---------------------------------------------------------------
node <- function(x,y){
  nr <- new_region(x=x,y=y)
  validate_node(new_node(nr))
}

# test
set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- rnorm(n)
node(x,y)

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n-1),x2=rnorm(n-1))
y <- rnorm(n)
node(x,y)

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- NULL
node(x,y)
# ----------------------------------------------------------------------

# 4.
# Write a generic function plot_regions that plots regions from the recursive partitioning algorithm in lab 2. 
# Write methods for this generic for objects of class tree and of class node.
plot_regions <- function(x, ...) UseMethod("plot_regions")
plot_regions.tree <- function(tree){
  # set up empty plot
  plot(tree$data$x[,1],tree$data$x[,2],xlab="X1",ylab="X2") 
  plot_regions.node(tree$childl)
  plot_regions.node(tree$childr)
}
plot_regions.node<- function(node) {
  if(is.null(node)) return(NULL)
  x <- node$data$coords[,1]
  y <- node$data$coords[,2]
  lines(c(x[1],x[2],x[2],x[1],x[1]),c(y[1],y[1],y[2],y[2],y[1]),
        col="red")
  plot_regions.node(node$childl)
  plot_regions.node(node$childr)
}

# 5. 
# What generics does the table class have methods for? What generics does the ecdf class have methods for?
s3_methods_class("table")
s3_methods_class("ecdf")

#############################
s3_methods_generic("print")
x <- "hello world"
s3_dispatch(print(x))
s3_get_method(plot_regions.node)
s3_class(nr)


