# Recursive partitioning
# The following code chunk is the start of an implementation of recursive partitioning 
#using a binary tree data structure to store the partition.

# Binary trees can be implemented as a linked list of nodes that contain

# data
# a pointer to the left child
# a pointer to the right child

# For our recursive partitioning example, the data will be a region of the original covariate space 
#and the response/covariate data in that region.

# The following code chunk establishes node and region data structure.
# Constructor for the node data structure:
new_node <- function(data,childl=NULL,childr=NULL){
  nn <- list(data=data,childl=childl,childr=childr)
  class(nn) <- "node"
  return(nn)
}

# The data stored in the node are a partition, or region of the covariate space. 

# Constructor for region data structure:
new_region <- function(coords=NULL,x,y){
  if(is.null(coords)) {
    coords <- sapply(x,range)
  }
  out <- list(coords=coords,x=x,y=y)
  class(out) <- "region"
  return(out)
}

# Some tests of the above constructors are given in the next code chunk.
set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- rnorm(n)
new_region(x=x,y=y)

new_node(new_region(x=x,y=y))

# The recursive partitioning function is shown below. We??ll discuss this in class.
#---------------------------------------------------#
# Recursive partitioning function.
recpart <- function(x,y){
  init <- new_node(new_region(x=x,y=y))
  tree <- recpart_recursive(init)
  class(tree) <- c("tree",class(tree))
  return(tree)
}

recpart_recursive <- function(node) {
  R <- node$data
  # stop recursion if region has a single data point
  if(length(R$y) == 1) { return(NULL) }
  # else find a split that minimizes a LOF criterion
  # Initialize
  lof_best  <- Inf
  # Loop over variables and splits
  for(v in 1:ncol(R$x)){ 
    tt <- split_points(R$x[,v]) # Exercise: write split_points()
    for(t in tt) { 
      gdat <- data.frame(y=R$y,x=as.numeric(R$x[,v] <= t))
      lof <- LOF(y~.,gdat) # Exercise: write LOF()
      if(lof < lof_best) { 
        lof_best <- lof
        childRs <- split(R,xvar=v,spt=t) # Exercises: write split.region()
      }
    }
  } 
  # Call self on best split
  node$childl <- recpart_recursive(new_node(childRs$Rl))
  node$childr <- recpart_recursive(new_node(childRs$Rr))
  return(node)
}

# Exercises

# 1.
# Write split_points(). 
# The function should take a vector of covariate values as input and return the sorted unique values. 
# You will need to trim off the maximum unique value, because this can??t be used as a split point. (As yourself why not.) 
# Write a snippet of R code that tests your function.
split_points <- function(vec) {
  unique <- unique(vec)
  out <- sort(unique)[-length(unique)]
  return(out)
}

# 2.
# Write the function LOF() that returns the lack-of-fit criterion for a model. 
# The function should take a model formula and data frame as input, pass these to lm() and return the residual sum of squares. 
# Write a snippet of R code that tests your function.
LOF <- function(formula, dataframe) {
  mdl <- lm(formula = formula, data = dataframe)
  RSS <- sum(resid(mdl)^2)
  return(RSS)
}

# 3.
# Write split.region(). The function should take a region R, the variable to split on, v, and the split point, t, as arguments. 
# Split the region into left and right partitions and return a list of two regions labelled Rl and Rr. 
# Note: It is tempting to split the x and y data and calculate the coordinates matrix from the x??s, 
# as the constructor does when not passed a coordinates matrix. 
# However, this will leave gaps in the covariate space. (Ask yourself why.) 
# Write a snippet of R code that tests your function.

split.region <- function(R,xvar,spt){
  r1_ind <- (R$x[,xvar] <= spt)
  c1 <- c2 <- R$coords
  c1[2,xvar] <- spt; c2[1,xvar] <- spt 
  Rl <- new_region(c1,R$x[r1_ind,,drop=FALSE],R$y[r1_ind])
  Rr <- new_region(c2,R$x[!r1_ind,,drop=FALSE],R$y[!r1_ind])
  return(list(Rl=Rl,Rr=Rr))
}
# 4. 
# Run recpart() with your versions of split_points(), LOF() and split.region(). 
# Use the test data x and y defined in the testing code chunk. At this point you do not need to check that the output is correct;
# you will get a chance to to that in lab 2.

set.seed(123); n <- 10
x <- data.frame(x1=rnorm(n),x2=rnorm(n))
y <- rnorm(n)
recpart(x = x, y = y)
