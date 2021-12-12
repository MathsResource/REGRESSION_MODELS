# Prediction Intervals

# Confidence intervals for Regression Coefficients
# RMSE
# http://stats.lse.ac.uk/knott/tiger.links/stats2/st2.pdf
# Confidence intervals for Fitted Values
# Prediction Intervals for Fitted Values

require(graphics)

#####################################################################
## Predictions
x <- rnorm(15)
y <- x + rnorm(15)
predict(lm(y ~ x))
new <- data.frame(x = seq(-3, 3, 0.5))
predict(lm(y ~ x), new, se.fit = TRUE)

pred.w.plim <- predict(lm(y ~ x), new, interval="prediction")
pred.w.clim <- predict(lm(y ~ x), new, interval="confidence")

matplot(new$x,cbind(pred.w.clim, pred.w.plim[,-1]),
        lty=c(1,2,2,3,3), type="l", ylab="predicted y")
####################################################################
