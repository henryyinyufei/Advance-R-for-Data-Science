library(Rcpp)

# Example from section 25.2 of text
cppFunction('int add(int x, int y, int z) {
  int sum = x + y + z;
  return sum;
}')

# add works like a regular R function
add

add(1, 2, 3)

# No inputs, scalar output

# R
one <- function() 1L

# Rcpp
cppFunction('int one() {
  return 1;
}')
one()

# Scalar input and output

# R
signR <- function(x) {
  if (x > 0) { 1 } else if (x == 0) { 0 } else { -1 }
}

# Rcpp
cppFunction('int signC(int x) {
  if (x > 0) {
    return 1;
  } else if (x == 0) {
    return 0;
  } else {
    return -1;
  }
}')
signC(-100)

# Vector input and scalar output

# R
sumR <- function(x) {
  total <- 0
  for (i in seq_along(x)) {
    total <- total + x[i]
  }
  total
}

# Rcpp
cppFunction('double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; i++) {
    total += x[i];
  }
  return total;
}')
set.seed(1)
x <- rnorm(1e5)
bench::mark(sumR(x),sumC(x),sum(x))

# Vector input, vector output

# R
pdistR <- function(x, ys) { sqrt((x - ys) ^ 2) }

# Rcpp
cppFunction('NumericVector pdistC(double x, NumericVector ys) {
  int n = ys.size();
  NumericVector out(n);
  for(int i = 0; i < n; ++i) {
    out[i] = sqrt(pow(ys[i] - x, 2.0)); // pow() vs ^{}
  }
  return out;
}')
pdistC(10,6:15)

# Using sourceCpp
sourceCpp("lec10_1.cpp")
timesTwo(42)

# List input, including S3 classes
sourceCpp("lec10_2.cpp") 
mod <- lm(mpg ~ wt, data = mtcars)
mpe(mod)

# Functions
sourceCpp("lec10_3.cpp")
set.seed(123)
x <- rnorm(100)
callFunction(x,fivenum)

callWithOne(function(x) x+1)

fit <- lm_in_C(formula(mpg~disp),mtcars,lm)
summary(fit)$coef

# Attributes
sourceCpp("lec10_4.cpp") 
attribs()


