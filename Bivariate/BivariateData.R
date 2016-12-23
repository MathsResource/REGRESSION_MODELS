# R code to demonstrate simple bivariate techniques
# 1) Constructing a simple scatterplot
# 2) Computing Correlation Coefficients
# 3) Fitting a sinmple linear regression model
################################################################

X <- rnorm(14, mean =10, sd = 2)
Y <- rnorm(14, mean =100, sd = 2)

################################################################

cor(X,Y)

plot(X,Y)

plot(X,Y,pch=16,col="red")
title("Scatterplot")

################################################################
