# similar to S3, but implementation is much stricter and makes use of specialised functions 
# for creating classes (setClass()), 
# generics (setGeneric()), and 
# methods (setMethod())

#  S4 provides both multiple inheritance and multiple dispatch

# An important new component of S4 is the slot, 
# a named component of the object that is accessed using the specialised subsetting operator @ (pronounced at). 
# The set of slots, and their classes, forms an important part of the definition of an S4 class.

library(methods)

# 15.2 Basics
# You define an S4 class by calling setClass() 
# with the class name and a definition of its slots, and the names and classes of the class data:
setClass("Person", 
         slots = c(
           name = "character", 
           age = "numeric"
         )
)
# Once the class is defined, 
# you can construct new objects from it by calling new() with the name of the class and a value for each slot:
john <- new("Person", name = "John Smith", age = NA_real_)
# Given an S4 object 
# you can see its class with is() and 
# access slots with @ (equivalent to $) and 
# slot() (equivalent to [[)
is(john)
john@name
slot(john, "age")

# Accessors are typically S4 generics allowing multiple classes to share the same external interface.

# Here we¡¯ll create a setter and getter for the age slot by first creating generics with setGeneric():
setGeneric("age", function(x) standardGeneric("age"))
setGeneric("age<-", function(x, value) standardGeneric("age<-"))
# And then defining methods with setMethod()
setMethod("age", "Person", function(x) x@age)
setMethod("age<-", "Person", function(x, value) {
  x@age <- value
  x
})

# Finally, you can use sloop functions to identify S4 objects and generics found in the wild:
sloop::otype(john)
sloop::ftype(age)

# 15.3 Classes
# To define an S4 class, call setClass() with three arguments:
# 1. The class name. By convention, S4 class names use UpperCamelCase
# 2. A named character vector that describes the names and classes of the slots (fields).
# 3. A prototype, a list of default values for each slot. Technically, the prototype is optional80, but you should always provide it.
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

me <- new("Person", name = "Hadley")
str(me)

# Inheritance
# There is one other important argument to setClass(): contains. 
#This specifies a class (or classes) to inherit slots and behaviour from
setClass("Employee", 
         contains = "Person", 
         slots = c(
           boss = "Person"
         ),
         prototype = list(
           boss = new("Person")
         )
)

str(new("Employee"))

# Introspection
# To determine what classes an object inherits from, use is():
is(new("Person"))
is(new("Employee"))
# To test if an object inherits from a specific class, use the second argument of is():
is(john, "Person")


# Redefinition

# It¡¯s possible to create invalid objects if you redefine a class after already having instantiated an object:
setClass("A", slots = c(x = "numeric"))
a <- new("A", x = 10)
setClass("A", slots = c(a_different_slot = "numeric"))
a

# Helper

# new() is a low-level constructor suitable for use by you, the developer. 
# User-facing classes should always be paired with a user-friendly helper. A helper should always:
# 1. Have the same name as the class, e.g. myclass()
# 2. Have a thoughtfully crafted user interface with carefully chosen default values and useful conversions.
# 3. Create carefully crafted error messages tailored towards an end-user.
# 4. Finish by calling methods::new()
Person <- function(name, age = NA) {
  age <- as.double(age)
  
  new("Person", name = name, age = age)
}

Person("Hadley")

# Validator
# The constructor automatically checks that the slots have correct classes:
Person(mtcars)

Person("Hadley", age = c(30, 37))

#  setValidity(). 
# It takes a class and a function that returns TRUE if the input is valid, 
# and otherwise returns a character vector describing the problem(s):
setValidity("Person", function(object) {
  if (length(object@name) != length(object@age)) {
    "@name and @age must be same length"
  } else {
    TRUE
  }
})
Person("Hadley", age = c(30, 37))

alex <- Person("Alex", age = 30)
alex@age <- 1:10
validObject(alex)

# 15.4 Generics and methods
# To create a new S4 generic, call setGeneric() with a function that calls standardGeneric():
setGeneric("myGeneric", function(x) standardGeneric("myGeneric"))

#  Signature
# allows you to control the arguments that are used for method dispatch
setGeneric("myGeneric", 
           function(x, ..., verbose = TRUE) standardGeneric("myGeneric"),
           signature = "x"
)

# Methods
# in S4 you define methods with setMethod(). 
# There are three important arguments: 
# the name of the generic, 
# the name of the class, 
# and the method itself.
setMethod("myGeneric", "Person", function(x) {
  # method implementation
})

# Show method
# The most commonly defined S4 method that controls printing is show(), which controls how the object appears when it is printed

# To define a method for an existing generic, you must first determine the arguments. 
# You can get those from the documentation or by looking at the args() of the generic:
args(getGeneric("show"))

setMethod("show", "Person", function(object) {
  cat(is(object)[[1]], "\n",
      "  Name: ", object@name, "\n",
      "  Age:  ", object@age, "\n",
      sep = ""
  )
})
john

# Accessors
# Slots should be considered an internal implementation detail: 
# they can change without warning and user code should avoid accessing them directly.

# all user-accessible slots should be accompanied by a pair of accessors. If the slot is unique to the class, this can just be a function:
person_name <- function(x) x@name

setGeneric("name", function(x) standardGeneric("name"))
setMethod("name", "Person", function(x) x@name)
name(john)

# If the slot is also writeable, you should provide a setter function. 
# You should always include validObject() in the setter to prevent the user from creating invalid objects.
setGeneric("name<-", function(x, value) standardGeneric("name<-"))
setMethod("name<-", "Person", function(x, value) {
  x@name <- value
  validObject(x)
  x
})

name(john) <- "Jon Smythe"
name(john)

name(john) <- letters


