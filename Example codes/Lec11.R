library(reticulate)

conda_create("r-reticulate")

use_python("D://Simon Fraser University//2020 spring//CMPT 120//python//python.exe")

use_condaenv("r-reticulate")

npr <- import("numpy.random")
pd <- import("pandas") # import is from reticulate
df <- pd$DataFrame(npr$randn(3L,4L),columns=c('A','B','C','D'))
df

source_python("lec11_1.py")
ls(py) # is.environment(py)
names(py)
py$df

source_python("lec11_2.py")
py$MSE
ddat <- data.frame(Y=py$diabetes_y,py$diabetes_X)
library(ggplot2)
ggplot(ddat,aes(x=X1,y=Y)) + geom_point() + geom_smooth()
