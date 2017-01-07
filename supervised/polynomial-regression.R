library(MASS)

plot(Boston$nox, Boston$dis)

fit <- lm(nox ~ dis, data = Boston)

plot(Boston$dis, Boston$nox)
lines(sort(Boston$dis), fit$fitted.values[order(Boston$dis)], col=2, lwd=3)

summary(fit)

# Use the poly() function to come up with the powers of dis

# 2nd degree polynomial
fit_poly_two <- lm(formula=nox ~ poly(dis, 2, raw = TRUE), data=Boston)


summary((fit_poly_two))

plot(Boston$dis, Boston$nox)

lines(sort(Boston$dis), fit_poly_two$fitted.values[order(Boston$dis)], col=2, lwd=3)

# Third degree polynomial
fit_poly_three <- lm(formula=nox ~ poly(dis, 3, raw=TRUE), data=Boston)

summary((fit_poly_three))

coef(summary(fit_poly_three))

plot(Boston$dis, Boston$nox)

lines(sort(Boston$dis), fit_poly_three$fitted.values[order(Boston$dis)], col=2, lwd=3)

#Analysis of variance
anova(fit, fit_poly_two, fit_poly_three)