library(sloop)

# 13.2 Basic

f <- factor(c("a", "b", "c"))
# base type is the integer vector
typeof(f)
# it has a class attribute of ¡°factor¡±, and a levels attribute that stores the possible levels
attributes(f)
# strips the class attribute, causing it to lose its special behaviour:
unclass(f)

# The easiest way to tell if a function is a generic is to use sloop::ftype() and look for ¡°generic¡± in the output:
ftype(print)
ftype(str)
ftype(unclass)

# Many base R functions are generic, including the important print()
print(f)
print(unclass(f))

# the POSIXlt class used to represent date-time data is actually built on top of a list, a fact which is hidden by its str() method:
time <- strptime(c("2017-01-01", "2020-05-04 03:21"), "%Y-%m-%d")
str(time)
str(unclass(time))

# The implementation for a specific class is called a method, and the generic finds that method by performing method dispatch
# You can use sloop::s3_dispatch() to see the process of method dispatch:
s3_dispatch(print(f))

# note that S3 methods are functions with a special naming scheme, generic.class()

# Generally, you can identify a method by the presence of . in the function name
# but there are a number of important functions in base R that were written before S3, 
# and hence use . to join words. If you¡¯re unsure, check with sloop::ftype():
ftype(t.test)
ftype(t.data.frame)

# Unlike most functions, you can¡¯t see the source code for most S3 methods68 just by typing their names
# Instead, you can use sloop::s3_get_method(), which will work regardless of where the method lives:
weighted.mean.Date
s3_get_method(weighted.mean.Date)

# 13.3 classes

#  you simply set the class attribute. You can do that during creation with structure(), or after the fact with class<-():
x <- structure(list(), class = "my_class")

x <- list()
class(x) <- "my_class"

# You can determine the class of an S3 object with class(x), 
# and see if an object is an instance of a class using inherits(x, "classname").
class(x)
inherits(x, "my_class")
inherits(x, "your_class")

# S3 has no checks for correctness which means you can change the class of existing objects:
# Create a linear model
mod <- lm(log(mpg) ~ log(disp), data = mtcars)
class(mod)

print(mod)

# Turn it into a date (?!)
class(mod) <- "Date"
# Unsurprisingly this doesn't work very well
print(mod)

# recommend that you usually provide three functions:

# 1. constructor 
# new_myclass(), that efficiently creates new objects with the correct structure.

# 2. validator 
# validate_myclass(), that performs more computationally expensive checks to ensure that the object has correct values.

# 3. helper
# myclass(), that provides a convenient way for others to create objects of your class.

# The constructor:
# 1. Be called new_myclass()
# 2. Have one argument for the base object, and one for each attribute.
# 3. Check the type of the base object and the types of each attribute.
new_Date <- function(x = double()) {
  stopifnot(is.double(x))
  structure(x, class = "Date")
}
new_Date(c(-1, 0, 1))

# A slightly more complicated constructor is that for difftime, which is used to represent time differences
# built on a double, but has a units attribute that must take one of a small set of values:
new_difftime <- function(x = double(), units = "secs") {
  stopifnot(is.double(x))
  units <- match.arg(units, c("secs", "mins", "hours", "days", "weeks"))
  
  structure(x,
            class = "difftime",
            units = units
  )
}
new_difftime(c(1, 10, 3600), "secs")
new_difftime(52, "weeks")

# The validators:

# Take factors, for example. 
# A constructor only checks that types are correct, making it possible to create malformed factors:
new_factor <- function(x = integer(), levels = character()) {
  stopifnot(is.integer(x))
  stopifnot(is.character(levels))
  
  structure(
    x,
    levels = levels,
    class = "factor"
  )
}
new_factor(1:5, "a")
new_factor(0:1, "a")

# Rather than encumbering the constructor with complicated checks, 
# it¡¯s better to put them in a separate function
validate_factor <- function(x) {
  values <- unclass(x)
  levels <- attr(x, "levels")
  
  if (!all(!is.na(values) & values > 0)) {
    stop(
      "All `x` values must be non-missing and greater than zero",
      call. = FALSE
    )
  }
  
  if (length(levels) < max(values)) {
    stop(
      "There must be at least as many `levels` as possible values in `x`",
      call. = FALSE
    )
  }
  
  x
}
validate_factor(new_factor(1:5, "a"))
validate_factor(new_factor(0:1, "a"))
# This validator function is called primarily for its side-effects (throwing an error if the object is invalid)

# The helpers
# 1. Have the same name as the class, e.g. myclass()
# 2. Finish by calling the constructor, and the validator, if it exists.
# 3. Create carefully crafted error messages tailored towards an end-user.
# 4. Have a thoughtfully crafted user interface with carefully chosen default values and useful conversions.

# Sometimes all the helper needs to do is coerce its inputs to the desired type
new_difftime(1:10)
difftime <- function(x = double(), units = "secs") {
  x <- as.double(x)
  new_difftime(x, units = units)
}
difftime(1:10)

# Often, the most natural representation of a complex object is a string.
# a simple version of factor(): it takes a character vector, and guesses that the levels should be the unique values. 
# This is not always correct (since some levels might not be seen in the data), but it¡¯s a useful default.
factor <- function(x = character(), levels = unique(x)) {
  ind <- match(x, levels)
  validate_factor(new_factor(ind, levels))
}

# Some complex objects are most naturally specified by multiple simple components.
# it¡¯s natural to construct a date-time by supplying the individual components (year, month, day etc). 
# That leads me to this POSIXct() helper that resembles the existing ISODatetime() function
POSIXct <- function(year = integer(), 
                    month = integer(), 
                    day = integer(), 
                    hour = 0L, 
                    minute = 0L, 
                    sec = 0, 
                    tzone = "") {
  ISOdatetime(year, month, day, hour, minute, sec, tz = tzone)
}
POSIXct(2020, 1, 1, tzone = "America/New_York")

# 13.4 Generics and methods

# Method dispatch is performed by UseMethod(), which every generic calls. 
# UseMethod() takes two arguments: 
# the name of the generic function (required), 
# and the argument to use for method dispatch (optional)
mean
my_new_generic <- function(x) {
  UseMethod("my_new_generic")
}

x <- Sys.Date()
s3_dispatch(print(x))
# => indicates the method that is called, here print.Date()
# * indicates a method that is defined, but not called, here print.default().

x <- matrix(1:10, nrow = 2)
s3_dispatch(mean(x))
s3_class(x)

s3_dispatch(sum(Sys.time()))

# sloop::s3_dispatch() lets you find the specific method used for a single call
# want to find all methods defined for a generic or associated with a class 
# sloop::s3_methods_generic() and sloop::s3_methods_class():
s3_methods_generic("mean")
s3_methods_class("ordered")

# Creating methods
# First, you should only ever write a method if you own the generic or the class
# A method must have the same arguments as its generic
# There is one exception to this rule: if the generic has ..., the method can contain a superset of the arguments. 

# 13.5 Object styles

# Record style objects 
x <- as.POSIXlt(ISOdatetime(2020, 1, 1, 0, 0, 1:3))
x
length(x)
length(unclass(x))
x[[1]] # the first date time
unclass(x)[[1]] 
unclass(x)[[1]] # the first component, the number of seconds

# Data frames
x <- data.frame(x = 1:100, y = 1:100)
length(x)
nrow(x)

# Scalar objects
mod <- lm(mpg ~ wt, data = mtcars)
length(mod)

# 13.6  Inheritance

# S3 classes can share behaviour through a mechanism called inheritance. Inheritance is powered by three ideas:
# 1. The class can be a character vector
class(ordered("x"))
class(Sys.time())
# 2. If a method is not found for the class in the first element of the vector, 
# R looks for a method for the second class (and so on):
s3_dispatch(print(ordered("x")))
s3_dispatch(print(Sys.time()))
# 3. A method can delegate work by calling NextMethod()
# note that s3_dispatch() reports delegation with ->
s3_dispatch(ordered("x")[1])
s3_dispatch(Sys.time()[1])

#  ordered is a subclass of factor because it always appears before it in the class vector, and, 
# conversely, we¡¯ll say factor is a superclass of ordered.

# recommend that you adhere to two simple principles when creating a subclass:
# 1. The base type of the subclass should be that same as the superclass.
# 2. The attributes of the subclass should be a superset of the attributes of the superclass.

# NextMethod()
# we¡¯ll start with a concrete example for the most common use case: [. We¡¯ll start by creating a simple toy class: 
# a secret class that hides its output when printed:
new_secret <- function(x = double()) {
  stopifnot(is.double(x))
  structure(x, class = "secret")
}
print.secret <- function(x, ...) {
  print(strrep("x", nchar(x)))
  invisible(x)
}
x <- new_secret(c(15, 1, 456))
x

# the default [ method doesn¡¯t preserve the class:
s3_dispatch(x[1])
x[1]

# provide a [.secret method
`[.secret` <- function(x, i) {
  new_secret(x[i])
}
x[1]

# we need some way to call the underlying [ code,
# One approach would be to unclass() the object:
`[.secret` <- function(x, i) {
  x <- unclass(x)
  new_secret(x[i])
}
x[1]

# A better approach is to use NextMethod(), 
# which concisely solves the problem of delegating to the method that would have been called if [.secret didn¡¯t exist:
`[.secret` <- function(x, i) {
  new_secret(NextMethod())
}
x[1]
s3_dispatch(x[1])
# The => indicates that [.secret is called, 
# but that NextMethod() delegates work to the underlying internal [ method, as shown by the ->.

# Allowing subclassing
# To allow subclasses, the parent constructor needs to have ... and class arguments
new_secret <- function(x, ..., class = character()) {
  stopifnot(is.double(x))
  
  structure(
    x,
    ...,
    class = c(class, "secret")
  )
}
# Then the subclass constructor can just call to the parent class constructor with additional arguments as needed
new_supersecret <- function(x) {
  new_secret(x, class = "supersecret")
}

print.supersecret <- function(x, ...) {
  print(rep("xxxxx", length(x)))
  invisible(x)
}

x2 <- new_supersecret(c(15, 1, 456))
x2

# we need to revise the [.secret method. Currently it always returns a secret(), even when given a supersecret:
`[.secret` <- function(x, ...) {
  new_secret(NextMethod())
}

x2[1:3]

