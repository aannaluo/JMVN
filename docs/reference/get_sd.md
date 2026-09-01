# Standard error estimation for NLME parameters

Computes standard errors for fixed-effect parameters using an observed
information matrix from a joint nonlinear mixed-effects model.

## Usage

``` r
get_sd(
  RespLog,
  long.data,
  idVar,
  fixedest0,
  dispest0,
  invSIGMA0,
  SIGMA0,
  Bi,
  B,
  Jfixed,
  Jraneff
)
```

## Arguments

- RespLog:

  A list containing symbolic log-likelihood components.

- long.data:

  A longitudinal dataset containing model observations.

- idVar:

  Character string specifying the subject identifier variable.

- fixedest0:

  Estimated fixed-effect parameters.

- dispest0:

  Estimated dispersion parameters.

- invSIGMA0:

  Inverse of the random-effects covariance matrix.

- SIGMA0:

  Random-effects covariance matrix.

- Bi:

  Estimated subject-specific random effects.

- B:

  Matrix of random-effect estimates.

- Jfixed:

  Indices or definitions of fixed-effect parameters.

- Jraneff:

  Indices or definitions of random-effect parameters.

## Value

A vector containing standard errors for the fixed-effect parameters.

## Details

Uses the h-likelihood observed information matrix to estimate parameter
uncertainty while accounting for random effects and dispersion
components.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
  # Example:
  # sd <- get_sd(...)
}
} # }
```
