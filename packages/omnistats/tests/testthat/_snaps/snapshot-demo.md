# print method output is stable (snapshot demo)

    Code
      fit
    Output
      omni_linreg fit on 5 observations
      Formula: y ~ x 
      Coefficients:
      (Intercept)           x 
             0.14        1.96 

---

    Code
      tidy_linreg(fit$fit)
    Condition
      Error:
      ! `fit` must be a `omni_linreg` object; call `fit_linreg()` first.

