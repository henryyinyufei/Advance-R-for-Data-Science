# R6 objects are mutable, which means that they are modified in place, and hence have reference semantics.

library(R6)

# 14.2  Classes and methods

# R6 only needs a single function call to create both the class and its methods: R6::R6Class()

# The following example shows the two most important arguments to R6Class():
# 1. The first argument is the classname
# 2. The second argument, public, supplies a list of methods (functions) and fields (anything else) 
#that make up the public interface of the object.

Accumulator <- R6Class("Accumulator", list(
  sum = 0,
  add = function(x = 1) {
    self$sum <- self$sum + x 
    invisible(self)
  })
)

# You should always assign the result of R6Class() into a variable with the same name as the class, 
#because R6Class() returns an R6 object that defines the class:
Accumulator

# You construct a new object from the class by calling the new() method. 
#In R6, methods belong to objects, so you use $ to access new()
x <- Accumulator$new()

# You can then call methods and access fields with $
x$add(4)
x$sum
# In this class, the fields and methods are public, which means that you can get or set the value of any field
# when we¡¯re talking about fields and methods as opposed to variables and functions

# Method chaining
# $add() is called primarily for its side-effect of updating $sum

# Side-effect R6 methods should always return self invisibly. 
#This returns the ¡°current¡± object and makes it possible to chain together multiple method calls:
x$add(10)$add(10)$sum

# For, readability, you might put one method call on each line:
x$
  add(10)$
  add(10)$
  sum
# This technique is called method chaining and is commonly used in languages like Python and JavaScript. 
#Method chaining is deeply related to the pipe

# Important methods
# There are two important methods that should be defined for most classes: $initialize() and $print()

# $initialize() overrides the default behaviour of $new()

# the following code defines an Person class with fields $name and $age
# To ensure that that $name is always a single string, and $age is always a single number, I placed checks in $initialize().
Person <- R6Class("Person", list(
  name = NULL,
  age = NA,
  initialize = function(name, age = NA) {
    stopifnot(is.character(name), length(name) == 1)
    stopifnot(is.numeric(age), length(age) == 1)
    
    self$name <- name
    self$age <- age
  }
))

hadley <- Person$new("Hadley", age = "thirty-eight")
hadley <- Person$new("Hadley", age = 38)

# If you have more expensive validation requirements, implement them in a separate $validate() and only call when needed.

# Defining $print() allows you to override the default printing behaviour. 
#As with any R6 method called for its side effects, $print() should return invisible(self)
Person <- R6Class("Person", list(
  name = NULL,
  age = NA,
  initialize = function(name, age = NA) {
    self$name <- name
    self$age <- age
  },
  print = function(...) {
    cat("Person: \n")
    cat("  Name: ", self$name, "\n", sep = "")
    cat("  Age:  ", self$age, "\n", sep = "")
    invisible(self)
  }
))

hadley2 <- Person$new("Hadley")
hadley2

# This code illustrates an important aspect of R6. 
#Because methods are bound to individual objects, the previously created hadley object does not get this new method:
hadley
hadley$print

# Adding methods after creation
# Add new elements to an existing class with $set(), supplying the visibility, the name, and the component.
Accumulator <- R6Class("Accumulator")
Accumulator$set("public", "sum", 0)
Accumulator$set("public", "add", function(x = 1) {
  self$sum <- self$sum + x 
  invisible(self)
})
# As above, new methods and fields are only available to new objects; they are not retrospectively added to existing objects.

# Inheritance
AccumulatorChatty <- R6Class("AccumulatorChatty", 
                             inherit = Accumulator,
                             public = list(
                               add = function(x = 1) {
                                 cat("Adding ", x, "\n", sep = "")
                                 super$add(x = x)
                               }
                             )
)
x2 <- AccumulatorChatty$new()
x2$add(10)$add(1)$sum
# $add() overrides the superclass implementation, but we can still delegate to the superclass implementation by using super$

# Introspection
# Every R6 object has an S3 class that reflects its hierarchy of R6 classes. 
#This means that the easiest way to determine the class (and all classes it inherits from) is to use class():
class(hadley2)

# You can list all methods and fields with names()
names(hadley2)

# 14.3 Controlling access
# R6Class() has two other arguments that work similarly to public:
# 1. private
# allows you to create fields and methods that are only available from within the class, not outside of it.
# 2. active
# allows you to use accessor functions to define dynamic, or active, fields.

# private
Person <- R6Class("Person", 
                  public = list(
                    initialize = function(name, age = NA) {
                      private$name <- name
                      private$age <- age
                    },
                    print = function(...) {
                      cat("Person: \n")
                      cat("  Name: ", private$name, "\n", sep = "")
                      cat("  Age:  ", private$age, "\n", sep = "")
                    }
                  ),
                  private = list(
                    age = NA,
                    name = NULL
                  )
)

hadley3 <- Person$new("Hadley")
hadley3
hadley3$name

# active 
# Each active binding is a function that takes a single argument: value. 
# If the argument is missing(), the value is being retrieved; otherwise it¡¯s being modified.
Rando <- R6::R6Class("Rando", active = list(
  random = function(value) {
    if (missing(value)) {
      runif(1)  
    } else {
      stop("Can't set `$random`", call. = FALSE)
    }
  }
))
x <- Rando$new()
x$random
x$random
x$random

# Active fields are particularly useful in conjunction with private fields, 
#because they make it possible to implement components that look like fields from the outside but provide additional checks.
Person <- R6Class("Person", 
                  private = list(
                    .age = NA,
                    .name = NULL
                  ),
                  active = list(
                    age = function(value) {
                      if (missing(value)) {
                        private$.age
                      } else {
                        stop("`$age` is read only", call. = FALSE)
                      }
                    },
                    name = function(value) {
                      if (missing(value)) {
                        private$.name
                      } else {
                        stopifnot(is.character(value), length(value) == 1)
                        private$.name <- value
                        self
                      }
                    }
                  ),
                  public = list(
                    initialize = function(name, age = NA) {
                      private$.name <- name
                      private$.age <- age
                    }
                  )
)

hadley4 <- Person$new("Hadley", age = 38)
hadley4$name
hadley4$name <- 10
hadley4$age <- 20

# 14.4 Reference semantics
# One of the big differences between R6 and most other objects is that they have reference semantics. 
#The primary consequence of reference semantics is that objects are not copied when modified:
y1 <- Accumulator$new() 
y2 <- y1

y1$add(10)
c(y1 = y1$sum, y2 = y2$sum)

#  if you want a copy, you¡¯ll need to explicitly $clone() the object:
y1 <- Accumulator$new() 
y2 <- y1$clone()

y1$add(10)
c(y1 = y1$sum, y2 = y2$sum)






