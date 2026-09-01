#' @export
summary.Rnlme <- function(object, ...) {

  estimates <- object$fixedest
  se        <- object$fixedSD

  if (is.null(names(se)) && length(se) == length(estimates)) {
    names(se) <- names(estimates)
  }

  fixed_role <- sub("[0-9]+$", "", names(estimates))

  z <- as.numeric(estimates) / as.numeric(se)
  p <- 2 * pnorm(-abs(z))
  p <- format.pval(p, digits = 4, eps = 0.0001)

  fixed_df <- data.frame(
    label = names(estimates),
    role  = fixed_role,
    est   = as.numeric(estimates),
    se    = as.numeric(se),
    `z value`  = z,
    `p-value` = p,
    check.names = FALSE,
    row.names = names(estimates)
  )

  # ---- dispersion parameters (d, siga, sigb, xi, ...) ----
  disp_est <- unlist(object$dispersion)
  disp_se  <- object$dispSD
  if (is.null(names(disp_se)) && length(disp_se) == length(disp_est)) {
    names(disp_se) <- names(disp_est)
  }
  disp_role <- sub("[0-9]+$", "", names(disp_est))

  disp_df <- NULL
  if (length(disp_se) == length(disp_est)) {
    dz <- as.numeric(disp_est) / as.numeric(disp_se)
    dp <- 2 * pnorm(-abs(dz))
    disp_df <- data.frame(
      label = names(disp_est),
      role  = disp_role,
      est   = as.numeric(disp_est),
      se    = as.numeric(disp_se),
      `z value`  = dz,
      `p-value` = dp,
      check.names = FALSE,
      row.names = names(disp_est)
    )
  } else {
    disp_df <- data.frame(
      label = names(disp_est),
      role  = disp_role,
      est   = as.numeric(disp_est),
      check.names = FALSE,
      row.names = names(disp_est)
    )
  }

  # ---- formulas per model component (unchanged) ----
  formulas <- lapply(object$nlmeObjects, function(obj) {
    list(
      nffunc    = obj$nffunc,
      mean_model = obj$model,
      fixed      = obj$fixed,
      random     = obj$random,
      disp_model = if (!is.null(obj$sigma)) obj$sigma$model else NULL
    )
  })

  out <- list(
    object      = object,
    convergence = object$convergence,
    formulas    = formulas,
    fixed_df    = fixed_df,
    disp_df     = disp_df,
    AIC         = object$AIC,
    BIC         = object$BIC,
    logLik      = object$loglike_value,
    corr        = object$SIGMA,
    Jdf         = object$Jdf
    )

  class(out) <- "summary.Rnlme"
  out
}

  # p-value
  # use a normal distribution
  # just for the fixed effects -->
  #
  # standard error

  # estimate <- 0.75
  # se <- 0.20

  # z <- estimate / se
  # p <- 2 * pnorm(-abs(z))

  # z
  # p

  # separate using dashed lines, mean model (beta), variance model (alpha),
  # measurement error model (gamma) in t-table

  # simple formula for each model



#' @export
print.summary.Rnlme <- function(x, digits = 4, ...) {

  cat("Joint Nonlinear Mixed-Effects Model\n")
  cat(sprintf("logLik: %.2f   AIC: %.2f   BIC: %.2f\n",
              x$logLik, x$AIC, x$BIC))
  cat("-----------------------------------\n\n")

  print_block <- function(header, formula_lines, df, role) {
    cat(header, "\n")

    for (nm in names(formula_lines)) {
      if (!is.null(formula_lines[[nm]])) {
        cat("  ", nm, ": ", deparse(formula_lines[[nm]]), "\n", sep = "")
      }
    }

    cat("\n")

    sub_df <- df[df$role == role, , drop = FALSE]

    if (nrow(sub_df) > 0) {
      mat <- as.matrix(sub_df[, c("est", "se", "p-value")])
      rownames(mat) <- sub_df$label
      print(mat, digits = digits, quote = FALSE)
    }

    cat("\n-----------------------------------\n\n")
  }

  f1 <- x$formulas[[1]]

  print_block(
    "Mean model (beta):",
    list(
      nf = f1$nffunc,
      model = f1$mean_model,
      fixed = f1$fixed,
      random = f1$random
    ),
    x$fixed_df,
    "beta"
  )

  print_block(
    "Variance model (alpha):",
    list(model = f1$disp_model),
    x$fixed_df,
    "alpha"
  )

  if (length(x$formulas) > 1) {
    f2 <- x$formulas[[2]]

    print_block(
      "Measurement error model (gamma):",
      list(
        nf = f2$nffunc,
        model = f2$mean_model,
        fixed = f2$fixed,
        random = f2$random
      ),
      x$fixed_df,
      "gamma"
    )
  }

  cat("Dispersion parameters:\n\n")

  disp_mat <- as.matrix(x$disp_df[, c("est", "se", "p-value")])
  rownames(disp_mat) <- x$disp_df$label

  print(disp_mat, digits = digits, quote = FALSE)

  cat("\n")

  cat("Random effects covariance matrix:\n\n")
  print(VarCorr(x$object), digits = digits, quote = FALSE)

  cat("\nVariance model:\n")

  if (is.null(x$Jdf)) {
    cat("Random effects distribution: Normal\n")
  } else {
    cat("Random effects distribution: Inverse-Chi\n")
    cat("Degrees of freedom:", x$Jdf, "\n")
  }

  cat("\n")

  invisible(x)
}

#' @export
VarCorr.Rnlme <- function(x, sigma=NULL, ...) {

  Sigma <- x$SIGMA
  disp  <- x$dispersion

  disp_names <- names(disp)

  # Random-effect names represented in Sigma
  re_names <- colnames(Sigma)

  # If Sigma has no column names, use the corresponding
  # columns from Bi
  if (is.null(re_names)) {
    re_names <- colnames(x$Bi)[seq_len(ncol(Sigma))]
  }

  # Dispersion parameters for random effects in the main model
  d_prefix <- x$nlmeObjects[[1]]$dispName

  # Dispersion parameters for random effects in the true-value model
  sigb_prefix <- x$nlmeObjects[[1]]$
    sigma$trueVal.model$model$dispName

  # Dispersion parameter for a0
  siga_prefix <- x$nlmeObjects[[1]]$
    sigma$dispName


  d_names <- disp_names[
    grepl(
      paste0("^", d_prefix, "[0-9]+$"),
      disp_names
    )
  ]

  sigb_names <- disp_names[
    grepl(
      paste0("^", sigb_prefix, "[0-9]+$"),
      disp_names
    )
  ]

  sigma_disp_names <- c(d_names, sigb_names)


  if (length(sigma_disp_names) != ncol(Sigma)) {

    stop(
      "The number of random-effect dispersion parameters found (",
      length(sigma_disp_names),
      ") does not match the dimensions of SIGMA (",
      ncol(Sigma),
      ")."
    )
  }

  sd_re <- as.numeric(disp[sigma_disp_names])

  D <- diag(sd_re)

  cov_mat <- D %*% Sigma %*% D

  if (length(re_names) != ncol(cov_mat)) {

    stop(
      "The number of random-effect names (",
      length(re_names),
      ") does not match the covariance matrix dimension (",
      ncol(cov_mat),
      ")."
    )
  }

  rownames(cov_mat) <- re_names
  colnames(cov_mat) <- re_names

  if (is.null(x$Jdf)) {

    siga_names <- disp_names[
      grepl(
        paste0("^", siga_prefix, "[0-9]*$"),
        disp_names
      )
    ]

    if (length(siga_names) == 0) {

      stop(
        "Could not find the dispersion parameter for a0 ",
        "using prefix '", siga_prefix, "'."
      )
    }

    siga0 <- as.numeric(disp[siga_names[1]])

    cov_mat <- rbind(
      cbind(cov_mat, 0),
      c(
        rep(0, ncol(cov_mat)),
        siga0^2
      )
    )

    re_names <- c(re_names, "a0")

    rownames(cov_mat) <- re_names
    colnames(cov_mat) <- re_names

  } else {


    cat(
      "a0 follows an inverse-chi distribution\n"
    )

    cat(
      "degrees of freedom:",
      x$Jdf,
      "\n"
    )
  }

  cov_mat
}


#' @export
fixef.Rnlme <- function(object, ...) {
  object$fixedest

  #output t-table for coefficients from summary function.
  # subset of the summary function
}

#' @export
AIC.Rnlme <- function(object, ...) {
  object$AIC
}

#' @export
BIC.Rnlme <- function(object, ...) {
  object$BIC
}



#' @export
ranef.Rnlme <- function(object, ...) {

  Bi <- object$Bi

  out <- data.frame(
    id = object$uniqueID,
    Bi,
    check.names = FALSE
  )

  rownames(out) <- NULL
  out

  # add id column
}

#' @export
logLik.Rnlme <- function(object, ...) {
  object$loglike_value
}


# estimates of fixed effects and random effects
# calculate values for patient
#' @export
fitted.Rnlme <- function(object, nf.env = parent.frame(), src.dir = NULL, ...) {


  find_nf <- function(nm) {
    if (exists(nm, envir = nf.env, inherits = TRUE)) {
      return(get(nm, envir = nf.env, inherits = TRUE))
    }
    if (!is.null(src.dir)) {
      f <- file.path(src.dir, paste0(nm, ".R"))
      if (file.exists(f)) {
        e <- new.env()
        source(f, local = e)
        if (exists(nm, envir = e)) return(get(nm, envir = e))
      }
    }
    stop("Could not find function '", nm, "'. Either source it first, ",
         "or pass src.dir = 'path/to/src' pointing to where ", nm, ".R lives.")
  }

  long.data   <- object$long.data
  Bi          <- object$Bi
  fixedest    <- object$fixedest
  disp        <- object$dispersion
  nlmeObjects <- object$nlmeObjects
  idVar       <- object$idVar
  uniqueID    <- object$uniqueID

  row.idx <- match(long.data[[idVar]], uniqueID)
  out <- long.data[, idVar, drop = FALSE]

  get_suffix <- function(p.name) sub("^p", "", p.name)

  for (m in seq_along(nlmeObjects)) {

    obj    <- nlmeObjects[[m]]
    nf.fun <- find_nf(obj$nf)          # <-- robust lookup here
    t.var  <- long.data[[obj$var]]

    fixName  <- obj$fixName
    ranName  <- obj$ranName
    dispName <- obj$dispName

    p.names <- all.vars(obj$fixed[[2]])
    ran.p   <- all.vars(obj$random[[2]])
    resp.name <- all.vars(obj$model)[1]

    p.args <- vector("list", length(p.names))
    names(p.args) <- p.names

    for (k in seq_along(p.names)) {
      p   <- p.names[k]
      suf <- get_suffix(p)
      fix.val <- fixedest[paste0(fixName, k)]

      if (p %in% ran.p) {
        ran.col  <- paste0(ranName, suf)
        disp.col <- paste0(dispName, suf)
        ind.val  <- fix.val + Bi[row.idx, ran.col] * disp[disp.col]
      } else {
        ind.val <- rep(fix.val, length(row.idx))
      }
      p.args[[p]] <- unname(ind.val)
    }

    out[[paste0(resp.name, ".fitted")]] <- do.call(nf.fun, c(p.args, list(t.var)))
  }

  out
}
