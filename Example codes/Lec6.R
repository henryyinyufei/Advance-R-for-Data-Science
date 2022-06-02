# Tracing execution
f <- function(x) { g(h(x)) }
g <- function(x) {
  x
}
h <- function(x) {
  if(!is.numeric(x)) stop("x must be numeric")
}
#f("cat") # uncomment to run
# traceback()

# f("cat")
# Error in h(x) : x must be numeric 

# traceback()
# 4: stop("x must be numeric") at #2
# 3: h(x) at #2
# 2: g(h(x)) at #1
# 1: f("cat")

# Interactive debugging
h <- function(x) {
  browser()
  if(!is.numeric(x)) stop("x must be numeric")
}
#f("cat")

h <- function(x) {
  if(!is.numeric(x)) stop("x must be numeric")
}

# debug(f)
# f("cat")
# undebug(f)
# debug(g)
# f("cat")
# undebug(g)
# debug(h)
# f("cat")
# undebug(h)

# Test cases
f <- function(x) { x + 3 }
# test
f(3) # should return 6


# Measuring performance
library(profvis) #visualize profiling data
library(bench) # benchmarking tools

# Profiling
f <- function() {pause(0.1);g();h()} # pause() is from profvis
g <- function() {pause(0.1);h()}
h <- function() {pause(0.1)}
Rprof()
f()

Rprof(NULL) # Now view Rprof.out

# Summary of profile
# summaryRprof() # uncomment and run
summaryRprof()

# Visualize profile
source("lec6profiling.R") # profiler will refer to this source file
# profvis({ f() }) # Or choose Profile from RStudio

# Memory profiling
# profvis({ bigd1() })
# profvis({ bigd2() })
# profvis({ bigd3() })

# Microbenchmarking

# bench
library(bench)
x <- runif(100)
lb <- mark(
  sqrt(x),
  x ^ 0.5
)
lb

plot(lb,type="violin")


