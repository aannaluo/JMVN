#' @importFrom nlme VarCorr
#' @importFrom nlme fixef
#' @importFrom nlme ranef
#' @importFrom stats AIC BIC logLik
#' @importFrom Deriv Deriv Simplify
#' @importFrom ecoreg gauss.hermite
#' @importFrom LaplacesDemon tr
#' @importFrom mvtnorm rmvnorm
#' @importFrom Matrix bdiag
#' @importFrom purrr map
#' @importFrom stringr str_replace_all str_detect str_remove str_subset str_trim
#' @importFrom dplyr arrange mutate
#' @importFrom parallel detectCores makeCluster stopCluster
#' @importFrom foreach foreach %dopar%
#' @importFrom doParallel registerDoParallel
#' @importFrom stats as.formula complete.cases median optim pnorm quantile
#' @importFrom stats rchisq rnorm runif sd
NULL

#TODO
#Rnlme: no visible binding for global variable ‘q_split’
#Rnlme: no visible binding for global variable ‘df.sigma’
#Rnlme: no visible binding for global variable ‘df.randisp’
#Rnlme: no visible binding for global variable ‘ghsize’
#get_sd_aGH: no visible binding for global variable ‘n’
#calculate_aGH: no visible binding for global variable ‘exponent’
#est_raneff: no visible binding for global variable ‘sd’

