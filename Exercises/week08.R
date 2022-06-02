# 1.
# (text, ex. 14.2.1) Create a BankAccount R6 class that stores a balance and allows you to withdraw and deposit money. 
#Write an initializer that initializes the balance, with default balance zero. 
#Test your implementation by 
# (i) creating an instance of your class, and 
# (ii) chaining a deposit of 100, a withdrawl of 50 and then a report of the balance.

library(R6)
BankAccount <- R6Class("BankAccount", list(
  balance = 0,
  initialize = function(balance = 0) {
    stopifnot(is.numeric(balance), length(balance) == 1)
    

    self$balance <- balance
  }
))
BankAccount$set("public","withdraw", function(draw){
  self$balance <- self$balance - draw
  invisible(self)
})
BankAccount$set("public","deposit", function(dep){
  self$balance <- self$balance + dep
  invisible(self)
})

my_account <- BankAccount$new()
my_account$
  deposit(100)$
  withdraw(50)$
  balance

# -----------------------------------------
BankAccount <- R6Class(
  classname = "BankAccount", 
  public = list(
    balance = 0,
    deposit = function(dep = 0) {
      self$balance <- self$balance + dep
      invisible(self)
    },
    withdraw = function(draw) {
      self$balance <- self$balance - draw
      invisible(self)
    }
  )
)
# --------------------------------------------

# 2.
# Create a subclass of BankAccount that throws an error if you overdraft; i.e., if you attempt to withdraw more than the balance.
BankAccountStrict <- R6Class(
  classname = "BankAccountStrict",
  inherit = BankAccount,
  public = list(
    withdraw = function(draw = 0){
      if(self$balance - draw < 0){
        stop("Your `withdraw` must be smaller ",
             "than your `balance`.",
             call. = FALSE
             )
      }
      super$withdraw(draw = draw)
    }
  )
)

my_strict_account <- BankAccountStrict$new()
my_strict_account$balance

my_strict_account$
  deposit(5)$
  withdraw(15)
my_strict_account$balance

# 3. 
# Create a subclass of BankAccount that allows overdraft, but charges a $10 fee.
BankAccountCharging <- R6Class(
  classname = "BankAccountCharging",
  inherit = BankAccount,
  public = list(
    withdraw = function(draw = 0){
      if(self$balance - draw < 0){
        draw = draw + 10
      }
      super$withdraw(draw = draw)
    }
  )
)

my_charging_account <- BankAccountCharging$new()
my_charging_account$balance

my_charging_account$
  deposit(5)$
  withdraw(15)$
  withdraw(0)
my_charging_account$balance


# 4.
# Implement the bank account as an S4 class called BankAccount4.
# i. 
# In your class definition include a prototype that sets the balance to NA_real_ (a missing value of type double).

# ii.
# Write a helper that creates objects of class BanKAccount4 and 
#allows the user to set the initial balance, with default zero. 
#Have the helper function coerce the balance to a double before creating the object.

# iii.
# Write a show()` method that prints the object nicely.

# iv.
# Define generics and methods for making deposits and withdrawls; 
#because these methods modify the balance they should include calls to validObject().

# v.
#Use methods() to find all methods for objects of class BankAccount4.

library(methods)
# i.
setClass("BankAccount4",
         slot = c(balance = "numeric",
                  deposits = "numeric",
                  withdrawls = "numeric"),
         prototype = list(balance = NA_real_,
                          deposits = NA_real_,
                          withdrawls = NA_real_))

# ii. 
BankAccount4 <- function(balance = 0){
  balance <- as.double(balance)
  
  new("BankAccount4", balance = balance)
} 


# iii.
args(getGeneric("show"))
setMethod("show", "BankAccount4", function(object){
  cat(is(object)[[1]], "\n",
      "  Balance: ", object@balance, "\n",
      "  Deposits:  ", object@deposits, "\n",
      "  Withdrawls:  ", object@withdrawls, "\n",
      sep = ""
  )
})

### iv.
setGeneric("deposits", function(x, value) standardGeneric("deposits"))
setMethod("deposits", "BankAccount4", function(x, value) {
  x@deposits = value
  x@balance = x@balance + x@deposits
  validObject(x)
  x
})

setGeneric("withdrawls", function(x, value) standardGeneric("withdrawls"))
setMethod("withdrawls", "BankAccount4", function(x, value){
  x@withdrawls = value
  x@balance = x@balance - x@withdrawls
  validObject(x)
  x
})

# ------------------------------------------------------------------------------------------------
setGeneric("deposits<-", function(x, value, ... , verbose = TRUE) standardGeneric("deposits<-"),
           signature = "x")
setMethod("deposits<-", "BankAccount4", function(x, value, ..., verbose = TRUE){
  x@deposits = value
  x@balance = x@balance + x@deposits
  if(verbose) cat("Setting deposits to",value,"\n")
  validObject(x)
  x
})

setGeneric("withdrawls<-", function(x, value, ... , verbose = TRUE) standardGeneric("withdrawls<-"),
           signature = "x")
setMethod("withdrawls<-", "BankAccount4", function(x, value, ... , verbose = TRUE){
  x@withdrawls = value
  x@balance = x@balance - x@withdrawls
  if(verbose) cat("Setting withdrawls to",value,"\n")
  validObject(x)
  x
})
# ------------------------------------------------------------------------------------------------
# v.

methods("deposits")
methods("withdrawls")
methods("deposits<-")
methods("withdrawls<-")
methods(class = "BankAccount4")
