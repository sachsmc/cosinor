#' Summarize a cosinor model
#'
#' Given a time variable and optional covariates, generate inference a cosinor fit. Gives estimates,
#' confidence intervals, and tests for the mean, amplitude, and acrophase parameters.
#'
#'
#' @param object An object of class \code{cosinor.lm}
#' @param ...
#'
#'
#' @examples
#'
#' fit <- cosinor.lm(Y ~ time(time) + X + amp.acro(X), data = vitamind)
#' summary(fit)
#'
#' @export
#'

summary.cosinor.lm <- function(object, ...) {

  mf <- object$fit

  r.coef <- c(FALSE, as.logical(attr(mf$terms, "factors")["rrr",]))
  s.coef <- c(FALSE, as.logical(attr(mf$terms, "factors")["sss",]))
  mu.coef <- c(TRUE, ! (as.logical(attr(mf$terms, "factors")["sss",]) |
                                    as.logical(attr(mf$terms, "factors")["rrr",])))

  beta.s <- mf$coefficients[s.coef]
  beta.r <- mf$coefficients[r.coef]

  amp <- sqrt(beta.r^2 + beta.s^2)
  names(amp) <- gsub("rrr", "amp", names(amp))

  acr <- atan(beta.s / beta.r)
  names(acr) <-  gsub("sss", "acr", names(acr))

  ## delta method to get variance

  vmat <- vcov(mf)[c(which(r.coef), which(s.coef)), c(which(r.coef), which(s.coef))]
  a_r <- (beta.r^2 + beta.s^2)^(-0.5) * beta.r
  a_s <- (beta.r^2 + beta.s^2)^(-0.5) * beta.s

  b_r <- (1 / (1 + (beta.s^2 / beta.r^2))) * (-beta.s / beta.r^2)
  b_s <- (1 / (1 + (beta.s^2 / beta.r^2))) * (1 / beta.r)

  jac <- rbind(cbind(diag(a_r), diag(a_s)),
               cbind(diag(b_r), diag(b_s)))

  cov.trans <- jac %*% vmat %*% t(jac)
  se.trans <- sqrt(diag(cov.trans))

  ## assemble summary matrix

  coef <- c(mf$coefficients[mu.coef], amp, acr)
  se <- c(sqrt(diag(vcov(mf)))[mu.coef], se.trans)

  zt <- qnorm((1 - .95)/2, lower.tail = F)

  smat <- cbind(estimate = coef, standard.error = se, lower.CI = coef - zt * se, upper.ci = coef + zt * se, p.value = 2 * pnorm(-abs(coef/se)))
  print(round(smat, 4))
  invisible(as.data.frame(smat))

}
