#' Predict from a cosinor model
#'
#' Given a time variable and optional covariates, generate predicted values from a cosinor fit. Default
#' prediction is the mean value, optionally can predict at a given month
#'
#' @param cosinor.lm An object of class \code{cosinor.lm}
#' @param newdata Optional data frame which contains outcome and time values for forming predictions
#' @param type Character string specifying type of prediction. Currently the only option is \code{"mean"}.
#'
#'
#' @examples
#'
#' fit <- cosinor.lm(Y ~ time(time) + X + amp.acro(X), data = vitamind)
#' predict(fit, type = "mean")
#'
#' @export
#'

predict.cosinor.lm <- function(cosinor.lm, newdata = NULL, type = "mean"){

  if(missing(newdata) || is.null(newdata)) {

  Y <- cosinor.lm$fit$model[,paste(attr(cosinor.lm$Terms, "variables")[1 + attr(cosinor.lm$Terms, "response")])]
  Y.hat <- fitted(cosinor.lm$fit)

} else {

  Y <- newdata[, paste(attr(cosinor.lm$Terms, "variables")[1 + attr(cosinor.lm$Terms, "response")])]
  Y.hat <- predict(cosinor.lm$fit, newdata = newdata)

}

mu.hat <- cosinor.lm$fit$coefficients[1]
return(Y - Y.hat + mu.hat)

}

