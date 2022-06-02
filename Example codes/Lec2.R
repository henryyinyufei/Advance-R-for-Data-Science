# Types of objects
x <- 6 # stores as double by default
typeof(x)
y <- 6L # The "L" suffix forces storage as integer
typeof(y)

# Type versus Mode
mode(x)
mode(y)

# Vectors
# help("vector")
avec <- vector(mode="numeric",length=4)
lvec <- vector(mode="list",length=4)

avec <- c(54,210,77)
lvec <- list(54,210,77,c("grey","thin"))

# Combining vectors
c(avec,c(100,101))
c(lvec,TRUE)

# Vector attributes
typeof(avec)
length(avec)
str(avec)

typeof(lvec)
length(lvec)
names(lvec) = c("age","weight","height","hair")
str(lvec)
# We can specify element names when creating a vector
lvec <- list(age=54,weight=210,height=77,hair=c("grey","thin"))

# Factors
trt <- factor(c("drug1","placebo","placebo","drug2"))
attributes(trt)
str(trt)
# You can specify an order to the factors with the level argument:
trt <- factor(c("drug1","placebo","placebo","drug2"),
              levels=c("placebo","drug1","drug2"))
trt

# More on object class
# create your own class
class(lvec) <- "prof"
lvec

# Subsetting vectors and extracting elements
# Subset with [ or by name:
lvec[c(1,3)] # same as lvec[c("age","height")]
# Extract individual elements with [[, or $ for named objects:
lvec[[4]]
lvec$hair

# Subsetting factors
trt[1:3]
trt[1:3,drop=TRUE]

# Subsetting and assignment
avec
avec[2] <- 200
avec

# Assignment to vector elements
lvec[3:4] <- c("Hi","there")
lvec[3:4]
# for lists, assignment with [ requires that the replacement element be of length 1;
# [[ does not have this restriction
lvec[4] <- c("All","of","this")
lvec[4] # Only used first element of replacement vector
lvec[[4]] <- c("All","of","this")
lvec[3:4]

# Coercion: atomic vectors to lists
avec = c(age=54,weight=210,height=77)
avec
as.list(avec)

# Coercion: lists to atomic vectors
unlist(lvec)

# Coercion: factors to atomic vectors
# use factor() to coerce an atomic vector to a factor.
a <- factor(c(2,1,1,2))
# Use as.vector() to coerce a factor back to an atomic vector. The result is a character vector
as.vector(a)
# need to use as.numeric() to coerce to numeric, if required.
as.numeric(a)

# Matrices and data frames
A <- matrix(1:4,nrow=2,ncol=2)
A
# Here 1:4 is the same as c(1,2,3,4)
A <- matrix(c(1,2,3,4), nrow=2,ncol=2)
A
# To read row-by-row instead use the byrow=TRUE argument:
A <- matrix(c(1,2,3,4), nrow=2,ncol=2,byrow=TRUE)
A

# Combining matrices
rbind(A,matrix(c(5,6),nrow=1,ncol=2))
cbind(A,A)

# Matrix attributes
typeof(A)
dim(A)
colnames(A) <- c("var1","var2")
rownames(A) <- c("subj1","subj2")
A
str(A)

# Subsetting matrices
A
A[1,1]
A[1,]
A[,1]
A[1,,drop=FALSE]

# Extracting elements from matrices
A[[1,1]]
A[1,1]

# Coercion: Matrices to/from vectors
A
as.vector(A)

# Data frames
set.seed(1)
n <- 4
x <- 1:n; y <- rnorm(n,mean=x,sd=1) # multiple commands separated by ;
dd <- data.frame(x=x,y=y) # like making a list
str(dd)

# Subsetting and combining data frames like a list
dd$x
dd[[1]]

# Subsetting and combining data frames like a matrix
dd[1:2,]
zz = data.frame(z=runif(4))
cbind(dd,zz)

# Logical and relational operators
x <- c(TRUE,TRUE,FALSE); y <- c(FALSE,TRUE,TRUE)
!x ; x&y ; x&&y ; x|y ; x||y

# Relational operators
x <- 1:3; y <- 3:1
x>y ; x>=y ; x<y ; x<=y ; x==y ; x!=y

# Subsetting vectors with logical expressions
avec
avec > 100
avec[avec>100]
avec[avec>54 & avec<100]

# Subsetting matrices with logical expressions
A
A>1
A[A>1] # coerces to a vector

# Subset and assign with logical expressions
A[A>1] <- 9
A

# Be careful about recycling:
A[A>1] <- c(-10,10) # Throws a warning
A # R used c(-10,10), then just the -10

# Aside: Special values
# Missing values
avec
is.na(avec)
is.na(avec) <- 2
avec

# Infinite and undefined values
# Infinite(Inf)
ii <- 1/0
ii
is.infinite(ii)
# undefined values(NaN)
nn <- 0/0
nn
is.nan(nn)

# The null object
x <- NULL; is.null(x)
x <- c(x,1); x <- c(x,2); x
# etc., or as a loop (more on these later)
x <- NULL
for(i in 1:2) {
  x <- c(x,i)
}
x
