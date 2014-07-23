This is an R package for estimation and prediction of the cosinor model
for periodic data. It allows for covariate effects and provides tools
for inference on the mean shift, amplitude, and acrophase. To install
from github, you must first have the `devtools` package installed. Then
run this command to install the latest version:

    devtools::install_github("cosinor", "sachsmc")

Load the package into your library:

    library(cosinor)

The package comes with an example dataset called `vitamind` to
illustrate the usage. Fit a basic cosinor model with covariates:

    fit <- cosinor.lm(Y ~ time(time) + X + amp.acro(X), data = vitamind, period = 12)

The time variable is indicated by the `time` function in the formula. By
default, the period length is 12. Covariates can be included directly in
the formula to allow for mean shifts. To allow for differences in
amplitude and acrophase by covariate values, include the covariate
wrapped in the `amp.acro` function in the formula. Let's summarize the
model.

    summary(fit)

    ## Raw model coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)  30.0014         0.0026  29.9963   30.006  0.0000
    ## X             2.0033         0.0026   1.9981    2.009  0.0000
    ## rrr           1.0057         0.0036   0.9986    1.013  0.0000
    ## sss           5.9966         0.0037   5.9893    6.004  0.0000
    ## X:rrr         0.9979         0.0037   0.9906    1.005  0.0000
    ## X:sss        -0.0024         0.0038  -0.0097    0.005  0.5266
    ## ***********************
    ## Transformed coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)   30.001         0.0026   29.996   30.006       0
    ## [X = 1]        2.003         0.0026    1.998    2.009       0
    ## amp            6.080         0.0074    6.066    6.095       0
    ## [X = 1]:amp    6.320         0.0075    6.306    6.335       0
    ## acr            1.405         0.0006    1.403    1.406       0
    ## [X = 1]:acr    1.248         0.0006    1.247    1.249       0

This prints the raw coefficients, and the transformed coefficients. The
transformed coefficients display the amplitude and acrophase for the
covariate = 1 group and the covariate = 0 group. Beware when using
continuous covariates!

Testing is easy to do, tell the function which covariate to test, and
whether to test the amplitude or acrophase. The global test is useful
when you have multiple covariates in the model.

    test_cosinor(fit, "X", param = "amp")

    ## Raw model coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)  30.0014         0.0026  29.9963   30.006  0.0000
    ## X             2.0033         0.0026   1.9981    2.009  0.0000
    ## rrr           1.0057         0.0036   0.9986    1.013  0.0000
    ## sss           5.9966         0.0037   5.9893    6.004  0.0000
    ## X:rrr         0.9979         0.0037   0.9906    1.005  0.0000
    ## X:sss        -0.0024         0.0038  -0.0097    0.005  0.5266
    ## ***********************
    ## Transformed coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)   30.001         0.0026   29.996   30.006       0
    ## [X = 1]        2.003         0.0026    1.998    2.009       0
    ## amp            6.080         0.0074    6.066    6.095       0
    ## [X = 1]:amp    6.320         0.0075    6.306    6.335       0
    ## acr            1.405         0.0006    1.403    1.406       0
    ## [X = 1]:acr    1.248         0.0006    1.247    1.249       0

    ## Global test: 
    ## Statistic: 
    ## [1] 511.7
    ## 
    ## 
    ##  P-value: 
    ## [1] 0
    ## 
    ##  Individual tests: 
    ## Statistic: 
    ## [1] 22.62
    ## 
    ## 
    ##  P-value: 
    ## [1] 0
    ## 
    ##  Estimate and confidence interval[1] "0.24 (0.22 to 0.26)"

The predict function allows you to estimate the mean value of your
outcome for individuals. This is useful for adjusting for the seasonal
effects on some measurement. Let's compare the raw values to the
seasonally adjusted values of the vitamin D dataset.

    summary(vitamind$Y)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    18.8    26.0    29.9    30.0    33.8    42.4

    summary(predict(fit))

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    29.7    29.9    30.0    30.0    30.1    30.4
