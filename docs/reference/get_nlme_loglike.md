# Build NLME log-likelihood components

Constructs symbolic log-likelihood components for a nonlinear
mixed-effects model, including mean, variance, and random-effects
contributions.

## Usage

``` r
get_nlme_loglike(nlmeObject)
```

## Arguments

- nlmeObject:

  A nonlinear mixed-effects model specification object.

## Value

A list containing symbolic likelihood expressions, parameter names,
starting values, bounds, and model information.

## Details

Extracts model components and builds the likelihood structure required
for joint NLME estimation.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
  # Example:
  # loglike <- get_nlme_loglike(nlmeObject)
}
} # }
```
