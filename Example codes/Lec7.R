# object-oriented programming (OOP)
# three OOP systems: S3, R6 and S4

# polymorphism: As we¡¯ve seen, functions like plot are generic and behave differently when given different inputs; 
# this is called polymorphism.

# encapsulation: We hide the details of an object behind an interface.

# Example
data(mtcars)
ff <- lm(mpg~disp, data = mtcars)
class(ff)

names(ff)
ff$residuals
residuals(ff)
summary(ff)

# Base objects vs OO objects
x <- 1:4
attr(x,"class") # compare with class(x) -- misleading
class(x)

attr(mtcars,"class")
attr(ff,"class")

# OOP with S3
library(sloop)

# S3 classes
f <- factor(c("cat","dog","mouse"))
typeof(f)
attributes(f) # see also class(f) and inherits(f,"factor")
class(f)
inherits(f,"factor")

otype(f) # from sloop
s3_class(f) # from sloop

# Creating your own class
# Use class() to set the class after the object has been created, or use structure():
new_node <- function(data,childl=NULL,childr=NULL){
  structure(list(data=data,childl=childl,childr=childr),
            class="node")
}
nn <- new_node(data=NULL) # Note: data should be a region object
s3_class(nn)

# Removing the class attribute
print(unclass(f))
otype(unclass(f))

# S3 generic functions and methods
print
ftype(print)
ftype(print.factor)

# Method dispatch: UseMethod()

# Example: print methods
s3_methods_generic("print") # 208!

# Example: print.factor
s3_get_method("print.factor")


# Using inheritance
new_mars <- function(formula,data) {
  ff <- lm(formula,data)
  structure(c(ff,list(ID="Hi, I'm a MARS object")),
            class=c("mars",class(ff)))
}
mm <- new_mars(mpg~cyl,data=mtcars)
s3_dispatch(print(mm))


