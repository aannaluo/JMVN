# Construct joint log-likelihood structure from multiple NLME models

Combines multiple nonlinear mixed-effects models into a unified joint
likelihood representation for estimation.

## Usage

``` r
get_Jloglike(nlmeObjects)
```

## Arguments

- nlmeObjects:

  A list of nonlinear mixed-effects model specification objects.

## Value

A list containing joint likelihood components, parameter definitions,
starting values, parameter bounds, and random-effects covariance
information.

## Details

Extracts likelihood components from each NLME model and combines fixed
effects, dispersion parameters, and random-effects structures into a
joint representation.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
  # Example:
  # Jloglike <- get_Jloglike(nlmeObjects)
}
} # }
```
