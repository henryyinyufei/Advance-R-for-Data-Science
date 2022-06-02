import pandas as pd
import numpy as np
from sklearn import linear_model

flights = pd.read_csv("week11_flights.csv")
flights = flights.dropna()

carrier = pd.get_dummies(flights['carrier'])
dep_delay = flights['dep_delay']
dep_time = flights['dep_time']

x = pd.concat([carrier, dep_time], axis = 1)
y = dep_delay

# fits a regression of dep_delay on carrier and dep_time.
regr = linear_model.LinearRegression()
regr.fit(x, y)

# Save the residuals and fitted values from the regression.
fitted_values = regr.predict(x)
residuals = y - fitted_values
