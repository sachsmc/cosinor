This is an R package for estimation and prediction of the cosinor model
for periodic data. It allows for covariate effects and provides tools
for inference on the mean shift, amplitude, and acrophase. Check out the shiny app that illustrates the model here

http://sachsmc.shinyapps.io/cosinor-shinyapp/

The package is on CRAN and can be installed as follows

    install.packages("cosinor")

To install from github, you must first have the `devtools` package installed. Then
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
    ## (Intercept)  29.9956         0.0080  29.9799  30.0113  0.0000
    ## X             1.9947         0.0138   1.9677   2.0218  0.0000
    ## rrr           0.9792         0.0109   0.9578   1.0006  0.0000
    ## sss           6.0030         0.0117   5.9801   6.0259  0.0000
    ## X:rrr         5.0180         0.0196   4.9797   5.0563  0.0000
    ## X:sss        -0.0110         0.0195  -0.0493   0.0273  0.5733
    ## ***********************
    ## Transformed coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)   29.996         0.0080  29.9799  30.0113       0
    ## [X = 1]        1.995         0.0138   1.9677   2.0218       0
    ## amp            6.082         0.0117   6.0594   6.1052       0
    ## [X = 1]:amp    8.478         0.0155   8.4472   8.5080       0
    ## acr            1.409         0.0018   1.4056   1.4126       0
    ## [X = 1]:acr    0.785         0.0019   0.7812   0.7887       0

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
    ## (Intercept)  29.9956         0.0080  29.9799  30.0113  0.0000
    ## X             1.9947         0.0138   1.9677   2.0218  0.0000
    ## rrr           0.9792         0.0109   0.9578   1.0006  0.0000
    ## sss           6.0030         0.0117   5.9801   6.0259  0.0000
    ## X:rrr         5.0180         0.0196   4.9797   5.0563  0.0000
    ## X:sss        -0.0110         0.0195  -0.0493   0.0273  0.5733
    ## ***********************
    ## Transformed coefficients:
    ##             estimate standard.error lower.CI upper.CI p.value
    ## (Intercept)   29.996         0.0080  29.9799  30.0113       0
    ## [X = 1]        1.995         0.0138   1.9677   2.0218       0
    ## amp            6.082         0.0117   6.0594   6.1052       0
    ## [X = 1]:amp    8.478         0.0155   8.4472   8.5080       0
    ## acr            1.409         0.0018   1.4056   1.4126       0
    ## [X = 1]:acr    0.785         0.0019   0.7812   0.7887       0

    ## Global test: 
    ## Statistic: 
    ## [1] 15210
    ## 
    ## 
    ##  P-value: 
    ## [1] 0
    ## 
    ##  Individual tests: 
    ## Statistic: 
    ## [1] 123.3
    ## 
    ## 
    ##  P-value: 
    ## [1] 0
    ## 
    ##  Estimate and confidence interval[1] "2.4 (2.36 to 2.43)"

The predict function allows you to estimate the mean value of your
outcome for individuals. This is useful for adjusting for the seasonal
effects on some measurement. Let's compare the raw values to the
seasonally adjusted values of the vitamin D dataset.

    summary(vitamind$Y)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    23.5    25.4    29.6    30.4    34.8    40.7

    summary(predict(fit))

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    29.7    29.9    30.0    30.0    30.1    30.2

Plotting the fitted curves is also easy to do. Currently only `ggplot2`
is supported.

    library(ggplot2)
    ggplot.cosinor.lm(fit, x_str = "X")

![plot of chunk
unnamed-chunk-7](./README_files/figure-markdown_strict/unnamed-chunk-7.png)
