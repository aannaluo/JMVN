# Joint nonlinear mixed-effects model estimation (Rnlme)

Fits a joint nonlinear mixed-effects model by iteratively estimating
random effects, fixed effects, and dispersion parameters.

## Usage

``` r
Rnlme(
  nlmeObjects,
  long.data,
  idVar,
  sd.method = "None",
  dispersion.SD = FALSE,
  independent.raneff = FALSE,
  sdghsize = 4,
  itertol = 0.001,
  Ptol = 0.01,
  iterMax = 15,
  Verbose = FALSE
)
```

## Arguments

- nlmeObjects:

  A nonlinear mixed-effects model object containing model
  specifications.

- long.data:

  A longitudinal dataset containing observations and grouping
  information.

- idVar:

  Character string specifying the subject/group identifier variable.

- sd.method:

  Method for estimating standard errors. Options are `"None"`, `"HL"`.
  Default is `"None"`.

- dispersion.SD:

  Logical indicating whether dispersion parameter standard errors should
  be estimated. Default is `FALSE`.

- independent.raneff:

  Logical indicating whether random effects are assumed independent.
  Default is `FALSE`.

- sdghsize:

  Number of quadrature points for adaptive Gaussian quadrature. Default
  is `4`.

- itertol:

  Likelihood convergence tolerance. Default is `0.001`.

- Ptol:

  Parameter convergence tolerance. Default is `0.01`.

- iterMax:

  Maximum number of iterations. Default is `15`.

- Verbose:

  Logical indicating whether progress messages are printed. Default is
  `FALSE`.

## Value

A list containing parameter estimates, random effects, covariance
estimates, likelihood values, model criteria, and convergence
information.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
  # Example:
  # fit <- Rnlme(nlmeObjects, long.data, idVar="id")
}
} # }

```
