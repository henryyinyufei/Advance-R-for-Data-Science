# Week2 Exercises

# 1. Predict the outcome of the following:
c(1, FALSE)
c("a",1)
c(list(1),"a")
c(TRUE, 1)

# 2. If vv <- list(a=1,b=2), why doesn¡¯t as.vector(vv) work to coerce vv into an atomic vector?
vv <- list(a=1,b=2)
as.vector(vv)
# Lists are already vectors 

# 3. What do dim(), nrow() and ncol() return when applied to a 1-dimensional vector? What about NROW() or NCOL()?
# return NULL
# A 1-dimensional vector has no dim attribute

# 4. What is dim(cbind(A,A)) if A = matrix(1:4,2,2)?
# 2 rows 4 columns (2,4)
A = matrix(1:4, 2, 2)
dim(cbind(A, A))

# 5. What do the following return? Understand why.
TRUE | FALSE # TRUE OR FALSE return TRUE
c(TRUE,TRUE) & c(FALSE,TRUE) # TRUE AND FALSE, TRUE AND TRUE return FALSE TRUE  
c(TRUE,TRUE) && c(FALSE,TRUE) # return FALSE, The comparison is only made on the first element of each vector

# 6. What sort of object does table() return? 
# What is its type? 
# What attributes does it have? 
# How does the dimensionality change as you tabulate more variables?
t <- table(rep(1:2,times=3),rep(1:2,each=3))
attributes(t)
dim(t)
# it is an object of class table
# it has dimension 2 2
# its dimnames are a list 

# 7. What happens to a factor when you modify its levels? How do f2 and f3 differ from f1?
f1 <- factor(letters) 
f1
levels(f1) <- rev(levels(f1))
f1
f2 <- rev(factor(letters))          
f2
f3 <- factor(letters, levels = rev(letters))
f3

# 8. Fix each of the following common data frame subsetting errors:
#mtcars[mtcars$cyl = 4, ]
mtcars[mtcars$cy == 4,]

#mtcars[-1:4, ]
mtcars[-(1:4),]

#mtcars[mtcars$cyl <= 5]
mtcars[mtcars$cyl <=5,]

#mtcars[mtcars$cyl == 4 | 6, ]
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6,]
# Or
mtcars[mtcars$cyl %in% c(4,6),]



