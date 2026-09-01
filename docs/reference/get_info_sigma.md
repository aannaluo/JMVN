# Construct Sigma model information

Extracts model structure and likelihood information from a sigma model
object for use in joint h-likelihood estimation.

## Usage

``` r
get_info_sigma(sigmaObject)
```

## Arguments

- sigmaObject:

  A sigma model specification object.

## Value

A list containing sigma expressions, likelihood components, parameter
names, starting values, and parameter bounds.

## Details

Parses fixed and random effects in the sigma model and constructs the
corresponding symbolic expressions and likelihood components.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
  # Example:
  # sigmaInfo <- get_info_sigma(sigmaObject)
}
} # }
```
