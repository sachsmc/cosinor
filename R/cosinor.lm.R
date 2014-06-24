#' Fit cosinor model
#'
#' Given an outcome and time variable, fit the cosinor model with optional covariate effects.
#'
#' @param formula Forumla specifying the model. Indicate the time variable with \code{time()} and covariate effects on the amplitude and acrophase with \code{amp.acro()}. See \link{details}
#' @param period Length of time for a complete period of the sine curve.
#' @param data Data frame where variable can be found
#' @param na.action What to do with missing data
#'
#' @details This defines special functions that are used in the formula to indicate the time variable
#' and which covariates effect the amplitude. To indicate the time variable wrap the name of it in the function
#' \code{time()}. To indicate a variable which affects the acrophase/amplitude, wrap the name in
#' \code{amp.acro()}. This will then do all the tranformations for you. See examples for usage.
#'
#' @examples
#'
#' cosinor.lm(Y ~ time(time) + X + amp.acro(X), vitamind)
#'
#' @export
#'



cosinor.lm <- function(formula, period = 12,
                       data, na.action = na.omit){

 # build time tranformations

  Terms <- terms(formula, specials = c("time", "amp.acro"))

  stopifnot(attr(Terms, "specials")$time != 1)
  varnames <- get_varnames(Terms)
  timevar <- varnames[attr(Terms, "specials")$time - 1]

  data$rrr <- cos(2 * pi * data[,timevar] / period)
  data$sss <- sin(2 * pi * data[,timevar] / period)

  spec_dex <- unlist(attr(Terms, "special")$amp.acro) - 1
  mainpart <- c(varnames[c(-spec_dex, - (attr(Terms, "special")$time - 1))], "rrr", "sss")
  acpart <- paste(varnames[spec_dex], rep(c("rrr", "sss"), length(spec_dex)), sep = ":")
  newformula <- as.formula(paste(rownames(attr(Terms, "factors"))[1],
                           paste(c(mainpart, acpart), collapse = " + "), sep = " ~ "))

  fit <- lm(newformula, data, na.action = na.action)

  structure(list(fit = fit, Call = match.call(), Terms = Terms, period = period), class = "cosinor.lm")

}

#' Fit cosinor model
#'
#' Given an outcome and time variable, fit the cosinor model with optional covariate effects.
#'
#' @param formula Forumla specifying the model. Indicate the time variable with \code{time()} and covariate effects on the amplitude and acrophase with \code{amp.acro()}. See \link{details}
#' @param period Length of time for a complete period of the sine curve.
#' @param data Data frame where variable can be found
#' @param na.action What to do with missing data
#'
#' @details This defines special functions that are used in the formula to indicate the time variable
#' and which covariates effect the amplitude. To indicate the time variable wrap the name of it in the function
#' \code{time()}. To indicate a variable which affects the acrophase/amplitude, wrap the name in
#' \code{amp.acro()}. This will then do all the tranformations for you. See examples for usage.
#'
#' @examples
#'
#' cosinor.lm(Y ~ time(time) + X + amp.acro(X), vitamind)
#'
#' @export
#'


cosinor.lm.default <- function(formula, ...){

  UseMethod("cosinor.lm")

}

#' Extract variable names from terms object, handling specials
#'
#' @keywords Internal
#'

get_varnames <- function(Terms){

  spec <- names(attr(Terms, "specials"))
  tname <- attr(Terms, "term.labels")

  dex <- unlist(sapply(spec, function(sp){

    attr(Terms, "specials")[[sp]] - 1

  }))

  tname[dex] <- sapply(strsplit(tname[dex], "[()]"), function(x) x[2])
  tname

}
