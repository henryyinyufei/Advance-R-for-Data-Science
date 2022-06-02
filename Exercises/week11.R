library(nycflights13)
library(tidyverse)

# Install the R package nyclfights13, and use the following commands to save a subset of the flights dataframe as a .csv file.
set.seed(123)
flights <- sample_n(flights,size=5000) %>% select(dep_delay,carrier,dep_time)
write.csv(flights,file="week11_flights.csv")

# Write a Python script that reads in the data, 
# drops observations with missing values and 
# fits a regression of dep_delay on carrier and dep_time. 
# Save the residuals and fitted values from the regression. 
# In R, plot the residuals vs fitted values. 
# Compare this to a plot of residuals vs fitted values when you fit the model in R.

# Notes:

# The variable carrier is a categorical variable that will need to be converted to dummy variables before you fit the model.
# Depending on your approach, reticulate may return the fitted values and residuals as matrices.

# Some suggested sources of information are:
# 1.
# The reticulate website at https://rstudio.github.io/reticulate/. 
# The script in the first code chunk reads data in from a file called flights.csv, 
# extracts a subset of rows, a subset of variables and then drops observations with missing values.

# 2.
# The pandas documentation for the get_dummies() function https://pandas.pydata.org/docs/reference/api/pandas.get_dummies.html

# 3.
# The lec11_2.py Python script, which uses the linear_model() function from sklearn to fit a regression.

library(reticulate)
use_python("D://Simon Fraser University//2020 spring//CMPT 120//python//python.exe")

flights <- drop_na(flights)

mdl <- lm(formula = dep_delay ~ carrier + dep_time, data = flights)

data = data.frame(mdl$fitted.values, mdl$residuals)
names(data) = c("fitted", "residuals")
p1 = ggplot(data, aes(x = fitted, y = residuals)) + geom_point()

source_python('week11.py')
ddat <- data.frame(x = py$fitted_values, y = py$residuals)
p2 = ggplot(ddat, aes(x = x, y = y)) + geom_point()

p1
p2
