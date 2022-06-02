library(lobstr)

# Names and values
x <- c(1,2,3)
ls()
obj_addr(x) # changes eveery time this code chunk is run

# Syntactic vs non-syntactic
x <- 1
.x <- 1
`_x` <- 1
ls()

# Modifying, copying, binding
x <- c(1,2,3) ; y <- x
c(obj_addr(x), obj_addr(y))

x[[2]] <- 10 # Note: x[2] <- 10 has the same effect
c(obj_addr(x), obj_addr(y))

x
y

# Tracing copy 
x <- c(1,2,3)
tracemem(x)
x[[2]] <- 10
x <- 5 # removes the trace on the object
x[[1]] <-1

# More on tracemem()
# the trace is on the object, not the name
x <- c(1,2,3)
tracemem(x)
y <- x
c(obj_addr(x), obj_addr(y))
y[[2]] <- 10
c(obj_addr(x), obj_addr(y))

# Funtion calls
f <- function(arg) { return(arg) }
x <- c(1,2,3)
y <- f(x) # no copy made
c(obj_addr(x), obj_addr(y))

f <- function(arg) { arg <- 2*arg; return(arg) }
y <- f(x) # copy made
c(obj_addr(x), obj_addr(y))

# Lists
l1 <- list(1,2,3)
c(obj_addr(l1), obj_addr(l1[[1]]), obj_addr(l1[[2]]), obj_addr(l1[[3]]))
# # Note: ref() will print the above, formatted
ref(l1)

# Copy-on-modify in lists
l1 <- list(c(1,2), c(3,4), c(5,6,7))
c(obj_addr(l1),obj_addr(l1[[1]]),obj_addr(l1[[2]]),obj_addr(l1[[3]]))
tracemem(l1)
l1[[1]] <- 55
c(obj_addr(l1),obj_addr(l1[[1]]),obj_addr(l1[[2]]),obj_addr(l1[[3]]))

# Copies of lists are "shallow"
l2 <- l1
l2[[3]] <- 111
c(obj_addr(l1),obj_addr(l1[[1]]),obj_addr(l1[[2]]),obj_addr(l1[[3]]))
c(obj_addr(l2),obj_addr(l2[[1]]),obj_addr(l2[[2]]),obj_addr(l2[[3]]))

# Data frames are lists
dd <- data.frame(x=1:3, y=4:6)
c(obj_addr(dd[[1]]), obj_addr(dd[[2]]))

dd[,2] <- 7:9
c(obj_addr(dd[[1]]), obj_addr(dd[[2]]))

dd[1,] <- c(11,22)
c(obj_addr(dd[[1]]),obj_addr(dd[[2]]))

dd[1,2] <- 111
c(obj_addr(dd[[1]]),obj_addr(dd[[2]]))

# Beware of data frame overhead
dd <- data.frame(x=rnorm(100))
tracemem(dd)
dmed <- lapply(dd, median)
dd[[1]] <- dd[[1]] - dmed[[1]] # same as dd[,1] - dmed[[1]]

# Fewer copies if we do the same with list 
ll <- list(x=rnorm(100))
tracemem(ll)
lmed <- lapply(ll, median)
ll[[1]] <- ll[[1]] - lmed[[1]]

# Modify-in-place
e1 <- rlang::env(a = 1, b = 2, c = 3)
e2 <- e1
e1$c <- 4
e2$c



