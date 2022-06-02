# Week 4 exercises

# 1. Explain the output of the following code chunk.
f <- function() {
  fe <- environment(f)
  ee <- environment()
  pe <- parent.env(ee)
  list(fe=fe,ee=ee,pe=pe)
}
f()

# 2. Read the help files on the exists() and get() functions. Explain the output of the following code chunk.
f <- function(xx) {
  xx_parent <- if(exists("xx",envir=environment(f))) {
    get("xx",environment(f))
  } else {
    NULL
  }
  list(xx,xx_parent)
}

f(2)

xx <- 1
f(2)

rm(xx)

# 3. Write a function with argument xx that tests whether xx exists in the parent environment and, 
#if so, assigns the value of xx in the parent environment to the variable xx_parent, 
#and tests whether xx and xx_parent are equal. 
#If the test is FALSE, throw a warning to alert the user to the fact that the two are not equal.
Q3 <- function(xx) {
  xx_parent <- if(exists("xx", envir = environment(Q3))) {
    get("xx", envir = environment(Q3))
  } else { 
    NULL
  } 
  if (isTRUE(xx == xx_parent)){
    print("The two are equal")
  } else {
    warning("The two are not equal")
  }
  list(xx,xx_parent)
}

# 4. Write an infix version of c() that concatenates two vectors.
`%c%` <- function(vec1, vec2) {
  c(vec1, vec2)
}
a <- 1:10
b <- 11:20
`%c%`(a,b)




















