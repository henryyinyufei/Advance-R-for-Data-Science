# R6

library(R6)

# Example from the text
Accumulator <- R6Class(classname="Accumulator",
                       public = list(
                         sum = 0,
                         add = function(x = 1) {
                           self$sum <- self$sum + x
                           invisible(self)
                         }
                       )
)
# Accumulator
Accumulator
x <- Accumulator$new() # create an Accumulator object
x
x$sum
x$add(1) # method
x
x$sum
x$add(2)$add(3)$add(4) # methods can be "chained"

x
x$sum # field



# Side-effect methods
Accumulator <- R6Class(classname="Accumulator",
                       public = list(
                         sum = 0,
                         add = function(x = 1) {
                           self$sum <- self$sum + x
                           self  # Side-effect methods should return invisibly
                         }
                       )
)
# Accumulator
x <- Accumulator$new()
x$add(1)

# reset 
Accumulator <- R6Class(classname="Accumulator",
                       public = list(
                         sum = 0,
                         add = function(x = 1) {
                           self$sum <- self$sum + x
                           invisible(self)
                         }
                       )
)

# version without initialize and new
Person <- R6Class("Person", list(
  name = NULL,
  age = NA
))
brad <- Person$new()
brad$name = "Brad"
brad$age = 54
brad

# version with initialize and print
Person <- R6Class("Person", list(
  name = NULL,
  age = NA,
  initialize = function(name, age = NA) {
    stopifnot(is.character(name), length(name) == 1)
    stopifnot(is.numeric(age), length(age) == 1)
    self$name <- name
    self$age <- age
  },
  print = function(...) {
    cat("Person: \n")
    cat("Name:", self$name, "\n")
    cat("Age:", self$age, "\n")
    invisible(self)
  }
))
brad <- Person$new("Brad", age = 54)
brad

# Inheritance
AccumulatorChatty <- R6Class("AccumulatorChatty",
                             inherit = Accumulator,
                             public = list(
                               add = function(x = 1) {
                                 cat("Adding ", x, "\n", sep = "")
                                 super$add(x = x) # use the superclass implementation of add
                               }
                             )
)
x2 <- AccumulatorChatty$new()
x2$add(10)$add(1)$sum

# class() and names()
class(x2)
names(x2)


# Making copies
x3 <- x2 # Are we copying x2? NO
x3$add(100)
x3$sum
x2$sum # !!

# clone
x3 <- x2$clone()
x3$add(-100)
x3$sum
x2$sum


# S4

# Creating classes
library(methods)
setClass("Person",
         slots = c(
           name = "character",
           age = "numeric"
         )
)
brad <- new("Person", name = "Brad", age = 54)

# Class prototype
setClass("Person",
         slots = c(
           name = "character",
           age = "numeric"
         ),
         prototype = list(
           name = NA_character_,
           age = NA_real_
         )
)
brad <- new("Person", name = "Brad")
str(brad)

# use is() to see an S4 object¡¯s class
is(brad)

# @ or slot() to access slots
brad@name
slot(brad,"name")

brad@name <- "Brad McNeney"
brad

# Inheritance
setClass("Employee",
         contains = "Person",
         slots = c(
           boss = "Person"
         ),
         prototype = list(
           boss = new("Person")
         )
)
brad <- new("Employee",name="Brad",boss=new("Person",name="Catherine"))
is(brad,"Employee")
is(brad,"Person")

# Helpers
Person <- function(name, age = NA) {
  age <- as.double(age)
  new("Person", name = name, age = age)
}
Person("Brad")

# Validators
setValidity("Person", function(object) {
  if (length(object@name) != length(object@age)) {
    "@name and @age must be same length"
  } else {
    TRUE
  }
})

# two error examples
# new("Person",name="Brad",age=54:55)
# new("Employee",name=c("Brad","McNeney"))

# Generics and methods
# Note: Don't use {} in the function definition of setGeneric.
# get values with a prefix function
setGeneric("age", function(x) standardGeneric("age"))
setMethod("age", "Person", function(x) x@age)

# set values with a replacement function
setGeneric("age<-", function(x, value) standardGeneric("age<-"))
setMethod("age<-", "Person", function(x, value) {
  x@age <- value
  validObject(x) # check object validity
  x
})
age(brad) <- 55
age(brad)


# Signature
setGeneric("age<-",function(x,value,...,verbose=TRUE) standardGeneric("age<-"),
           signature = "x") # dispatch on first arg only
setMethod("age<-", "Person", function(x,value,...,verbose=TRUE) {
  x@age <- value
  if(verbose) cat("Setting age to",value,"\n")
  x
})
age(brad) <- 56

# show method
setMethod("show", "Employee", function(object) {
  cat(is(object)[[1]], "\n",
      " Name: ", object@name, "\n",
      " Age: ", object@age, "\n",
      " Boss: ", object@boss@name, "\n",
      sep = ""
  )
})
brad

# List methods
methods("age")
methods(class = "Employee")
methods(class = "Person")
