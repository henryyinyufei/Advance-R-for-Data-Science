library(Rcpp)

# 1.
# Which base R function does each of the following C++ functions correspond to?

cppFunction("double f1(NumericVector x) {
  int n = x.size();
  double y = 0;

  for(int i = 0; i < n; ++i) {
    y += x[i] / n;
  }
  return y;
}")
x <- c(1,2,3,4,5)
f1(x)
mean(x)
# mean()

cppFunction("NumericVector f2(NumericVector x) {
  int n = x.size();
  NumericVector out(n);

  out[0] = x[0];
  for(int i = 1; i < n; ++i) {
    out[i] = out[i - 1] + x[i];
  }
  return out;
}")
x <- c(1,2,3,4,5)
f2(x)
cumsum(x)
# cumsum()

cppFunction("bool f3(LogicalVector x) {
  int n = x.size();

  for(int i = 0; i < n; ++i) {
    if (x[i]) return true;
  }
  return false;
}")
x <- c(TRUE, FALSE, TRUE)
y <- c(FALSE, FALSE)
f3(x)
any(x)
f3(y)
any(y)
# any()

cppFunction("NumericVector f5(NumericVector x, NumericVector y) {
  int n = std::max(x.size(), y.size());
  NumericVector x1 = rep_len(x, n);
  NumericVector y1 = rep_len(y, n);

  NumericVector out(n);

  for (int i = 0; i < n; ++i) {
    out[i] = std::min(x1[i], y1[i]);
  }

  return out;
}")
x <- c(1,3,3,5,5)
y <- c(2,2,4,4,6)
f5(x,y)
pmin(x,y)
# pmin()

# 2
# Implement the following in C++:
#  the base R function all(),
cppFunction("bool allC(LogicalVector x) {
  int n = x.size();

  for (int i = 0; i < n; ++i) {
    if (!x[i]) return false;
  }
  return true;
}")
x <- c(TRUE, TRUE, TRUE)
y <- c(TRUE, FALSE)
all(x)
allC(x)
all(y)
allC(y)

#  the base R function range() and
cppFunction("NumericVector rangeC(NumericVector x) {
  double omin = x[0], omax = x[0];
  int n = x.size();
  
  for (int i = 1; i < n; i++) {
    omin = std::min(x[i], omin);
    omax = std::max(x[i], omax);
  }

  NumericVector out(2);
  out[0] = omin;
  out[1] = omax;
  return out;
}")
x <- c(1,2,3,4,5)
range(x)
rangeC(x)

#  the function over10 <- function(x) { sum(x>10) }. For (c), have your function return an integer.
over10 <- function(x) {sum(x>10)}
cppFunction("int over10C(NumericVector x) {
  int count = 0;
  int n = x.size();
            
  for (int i = 0; i < n; i++) {
    if (x[i] > 10) { count += 1; }
  }
  return count;
}")
x <- c(9,11,12,13)
over10(x)
over10C(x)
