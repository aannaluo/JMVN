# Tutorial: Fitting Robust Nonlinear Mixed Effects Models

## Introduction

Nonlinear mixed effects models (NLME) are commonly used for analyzing
longitudinal data where observations are collected repeatedly from
multiple subjects. These models allow population-level effects to be
estimated while accounting for subject-specific variation through random
effects.

However, traditional NLME models typically assume that the variability
of the measurements is constant across subjects and over time. In many
applications, this assumption is unrealistic. For example, biological
measurements may have different levels of variability depending on
patient characteristics or latent processes.

The `JMVN` package extends nonlinear mixed effects modeling by allowing
flexible dispersion models. This tutorial demonstrates how to fit:

1.  A standard nonlinear mixed effects model.
2.  A two-step approach where an auxiliary longitudinal process is first
    estimated and then incorporated into the variance model.
3.  A joint modeling approach where both processes are estimated
    simultaneously.

## Required Packages

The following packages are required for this tutorial.

``` r

########################### load packages
library(nlme)
```

## Loading Model Functions

The functions used throughout this tutorial are sourced from the package
development directory.

``` r

rm(list=ls())
########################## source all functions  
(file.sources = list.files(path=here::here("R"),pattern="*.R$"))
#>  [1] "est_disp_ml.R"            "est_disp_reml.R"         
#>  [3] "est_dispersion.R"         "est_fixed.R"             
#>  [5] "est_individual_raneff.R"  "est_individual_raneff1.R"
#>  [7] "est_raneff.R"             "get_Hessian.R"           
#>  [9] "get_Hvalue.R"             "get_idSIGMA_aGH.R"       
#> [11] "get_info_sigma.R"         "get_Jloglike.R"          
#> [13] "get_loglike_value.R"      "get_nlme_loglike.R"      
#> [15] "get_sd_dispersion.R"      "get_sd.R"                
#> [17] "imports.R"                "make_loglike_invChi.R"   
#> [19] "make_loglike_normal.R"    "make_Mat.R"              
#> [21] "make_name.R"              "make_strMat.R"           
#> [23] "mgauss.hermite.R"         "Rnlme_methods.R"         
#> [25] "Rnlme.R"
(file.sources <- paste0(here::here("R"), "/", file.sources))
#>  [1] "/home/runner/work/JMVN/JMVN/R/est_disp_ml.R"           
#>  [2] "/home/runner/work/JMVN/JMVN/R/est_disp_reml.R"         
#>  [3] "/home/runner/work/JMVN/JMVN/R/est_dispersion.R"        
#>  [4] "/home/runner/work/JMVN/JMVN/R/est_fixed.R"             
#>  [5] "/home/runner/work/JMVN/JMVN/R/est_individual_raneff.R" 
#>  [6] "/home/runner/work/JMVN/JMVN/R/est_individual_raneff1.R"
#>  [7] "/home/runner/work/JMVN/JMVN/R/est_raneff.R"            
#>  [8] "/home/runner/work/JMVN/JMVN/R/get_Hessian.R"           
#>  [9] "/home/runner/work/JMVN/JMVN/R/get_Hvalue.R"            
#> [10] "/home/runner/work/JMVN/JMVN/R/get_idSIGMA_aGH.R"       
#> [11] "/home/runner/work/JMVN/JMVN/R/get_info_sigma.R"        
#> [12] "/home/runner/work/JMVN/JMVN/R/get_Jloglike.R"          
#> [13] "/home/runner/work/JMVN/JMVN/R/get_loglike_value.R"     
#> [14] "/home/runner/work/JMVN/JMVN/R/get_nlme_loglike.R"      
#> [15] "/home/runner/work/JMVN/JMVN/R/get_sd_dispersion.R"     
#> [16] "/home/runner/work/JMVN/JMVN/R/get_sd.R"                
#> [17] "/home/runner/work/JMVN/JMVN/R/imports.R"               
#> [18] "/home/runner/work/JMVN/JMVN/R/make_loglike_invChi.R"   
#> [19] "/home/runner/work/JMVN/JMVN/R/make_loglike_normal.R"   
#> [20] "/home/runner/work/JMVN/JMVN/R/make_Mat.R"              
#> [21] "/home/runner/work/JMVN/JMVN/R/make_name.R"             
#> [22] "/home/runner/work/JMVN/JMVN/R/make_strMat.R"           
#> [23] "/home/runner/work/JMVN/JMVN/R/mgauss.hermite.R"        
#> [24] "/home/runner/work/JMVN/JMVN/R/Rnlme_methods.R"         
#> [25] "/home/runner/work/JMVN/JMVN/R/Rnlme.R"
sapply(file.sources,source)
#>         /home/runner/work/JMVN/JMVN/R/est_disp_ml.R
#> value   ?                                          
#> visible FALSE                                      
#>         /home/runner/work/JMVN/JMVN/R/est_disp_reml.R
#> value   ?                                            
#> visible FALSE                                        
#>         /home/runner/work/JMVN/JMVN/R/est_dispersion.R
#> value   ?                                             
#> visible FALSE                                         
#>         /home/runner/work/JMVN/JMVN/R/est_fixed.R
#> value   ?                                        
#> visible FALSE                                    
#>         /home/runner/work/JMVN/JMVN/R/est_individual_raneff.R
#> value   ?                                                    
#> visible FALSE                                                
#>         /home/runner/work/JMVN/JMVN/R/est_individual_raneff1.R
#> value   ?                                                     
#> visible FALSE                                                 
#>         /home/runner/work/JMVN/JMVN/R/est_raneff.R
#> value   ?                                         
#> visible FALSE                                     
#>         /home/runner/work/JMVN/JMVN/R/get_Hessian.R
#> value   ?                                          
#> visible FALSE                                      
#>         /home/runner/work/JMVN/JMVN/R/get_Hvalue.R
#> value   ?                                         
#> visible FALSE                                     
#>         /home/runner/work/JMVN/JMVN/R/get_idSIGMA_aGH.R
#> value   ?                                              
#> visible FALSE                                          
#>         /home/runner/work/JMVN/JMVN/R/get_info_sigma.R
#> value   ?                                             
#> visible FALSE                                         
#>         /home/runner/work/JMVN/JMVN/R/get_Jloglike.R
#> value   ?                                           
#> visible FALSE                                       
#>         /home/runner/work/JMVN/JMVN/R/get_loglike_value.R
#> value   ?                                                
#> visible FALSE                                            
#>         /home/runner/work/JMVN/JMVN/R/get_nlme_loglike.R
#> value   ?                                               
#> visible FALSE                                           
#>         /home/runner/work/JMVN/JMVN/R/get_sd_dispersion.R
#> value   ?                                                
#> visible FALSE                                            
#>         /home/runner/work/JMVN/JMVN/R/get_sd.R
#> value   ?                                     
#> visible FALSE                                 
#>         /home/runner/work/JMVN/JMVN/R/imports.R
#> value   NULL                                   
#> visible TRUE                                   
#>         /home/runner/work/JMVN/JMVN/R/make_loglike_invChi.R
#> value   ?                                                  
#> visible FALSE                                              
#>         /home/runner/work/JMVN/JMVN/R/make_loglike_normal.R
#> value   ?                                                  
#> visible FALSE                                              
#>         /home/runner/work/JMVN/JMVN/R/make_Mat.R
#> value   ?                                       
#> visible FALSE                                   
#>         /home/runner/work/JMVN/JMVN/R/make_name.R
#> value   ?                                        
#> visible FALSE                                    
#>         /home/runner/work/JMVN/JMVN/R/make_strMat.R
#> value   ?                                          
#> visible FALSE                                      
#>         /home/runner/work/JMVN/JMVN/R/mgauss.hermite.R
#> value   ?                                             
#> visible FALSE                                         
#>         /home/runner/work/JMVN/JMVN/R/Rnlme_methods.R
#> value   ?                                            
#> visible FALSE                                        
#>         /home/runner/work/JMVN/JMVN/R/Rnlme.R
#> value   ?                                    
#> visible FALSE

###############################################
```

## Simulated Longitudinal Data

The example dataset contains repeated measurements from 100 individuals.
Each individual has 15 longitudinal observations.

The variables are:

- `patid`: patient identifier
- `day`: observation time
- `lgcopy`: primary longitudinal response
- `cd4`: auxiliary longitudinal measurement

``` r

#### Read in the data
simdat <- readRDS(here::here("inst/extdata","toy_data.rds"))

# 100 unique patients
# 15 repeated measurements per patient
# var: patid, day, lgcopy, cd4
```

## Nonlinear Model Specification

We first define two nonlinear functions.

The first function describes an exponential decay trajectory:

``` math
f(t)=p_1+p_2e^{-p_3t}
```

The second function describes a quadratic trajectory:

``` math
f(t)=p_1+p_2t+p_3t^2
```

These functions will be used to specify the nonlinear mean structures.

``` r

#### pre-define the functions we need for modeling
    nf1 <- function(p1,p2,p3,t) p1+p2*exp(-p3*t)
    nf2 <- function(p1,p2,p3,t) p1+p2*t+p3*t^2
```

## Standard NLME Model

Before fitting robust dispersion models, we first fit a conventional
nonlinear mixed effects model using
[`nlme()`](https://rdrr.io/pkg/nlme/man/nlme.html).

This model provides initial parameter estimates for subsequent models.

``` r

#### LB method: nlme()
    cat("--Fit NLME() \n")
#> --Fit NLME()
    dat_g <- groupedData(lgcopy~day|patid, data=simdat)
  
    
    start0 <- c(p1=1,p2=2,p3=3) # random starting values
    nls.fit  <- nls(lgcopy~nf1(p1,p2,p3, day), data=dat_g, start=start0)
    start <- coef(nls.fit) # update starting values
    nlme.fit <- R.utils::withTimeout({try(nlme(lgcopy~nf1(p1,p2,p3, day),fixed = p1+p2+p3 ~1,random  = p1+p3 ~1,
                     data=dat_g,start=start))},timeout=1.5,onTimeout="warning")
#> Warning in nlme.formula(lgcopy ~ nf1(p1, p2, p3, day), fixed = p1 + p2 + :
#> Iteration 1, LME step: nlminb() did not converge (code = 1). Do increase
#> 'msMaxIter'!
```

## Two-Step Approach

The two-step approach separates the estimation of the auxiliary process
from the nonlinear response model.

The first step estimates the latent CD4 trajectory. The predicted CD4
values are then used in the dispersion model for the nonlinear response.

### Step 1: Estimate the Auxiliary Process

``` r

#### TS method:
    cat("--Runing Two-step model\n")
#> --Runing Two-step model

    # step 1: fit CD4 model and get predicted true CD4 values
    
    cd4.fit <- try(lme(cd4~day+I(day^2), data=simdat, random=~1|patid))
    simdat$cd4.pred <- fitted(cd4.fit)
```

### Step 2: Fit the Joint Mean-Variance Model

The variance model allows measurement variability to depend on the
estimated CD4 trajectory.

``` r

    # step 2: Joint modeling mean and variance for NLME
    
    # variance model:  
    sigmaObject_TS <- list(model=~1+cd4.pred+(1|patid),
                           link='log',
                           ran.dist="normal",
                           str.fixed=c(2*log(nlme.fit$sigma), 0),
                           lower.fixed=NULL,
                           upper.fixed=NULL,
                           fixName="alpha",
                           ranName="a",
                           dispName="siga",
                           str.disp=0.5)
```

The nonlinear response model is specified below.

``` r

    # mean model
    nlmeObject_TS <- list(nf = "nf1",
                          model= lgcopy ~ nf(p1,p2,p3,day),
                          var=c("day"),
                          fixed = p1+p2+p3 ~1,
                          random = p1+p3 ~1,
                          family='normal', 
                          ran.dist='normal',
                          fixName="beta",
                          ranName="u",
                          dispName="d",
                          sigma=sigmaObject_TS,
                          ran.Cov=NULL,
                          str.fixed=fixef(nlme.fit),
                          str.disp=as.numeric(VarCorr(nlme.fit)[,"StdDev"][c("p1", "p3")]),
                          lower.fixed=NULL,
                          upper.fixed=rep(100,3),
                          lower.disp=c(0,0),
                          upper.disp=c(Inf,Inf)
                          )
    
    nlmeObjects_TS=list(nlmeObject_TS)
    
    TS <- try(Rnlme(nlmeObjects=nlmeObjects_TS, long.data=simdat, 
                        idVar="patid", sd.method="HL", dispersion.SD = TRUE,
                        independent.raneff=FALSE))
#> Error in str_trim(resp) : could not find function "str_trim"
```

## Joint Modeling Approach

The joint modeling approach simultaneously estimates:

- the nonlinear response model,
- the auxiliary longitudinal model,
- the measurement error model,
- and the dispersion model.

Unlike the two-step approach, uncertainty in the latent CD4 trajectory
is propagated through the entire estimation procedure.

``` r

#### JM method
    cat("--Runing Joint model\n")
#> --Runing Joint model
```

The CD4 measurement model is specified first.

``` r

    #### JM
    sigma1 <- list(model=NULL,
                   str.disp=as.numeric(VarCorr(cd4.fit)[,"StdDev"][2]),
                   lower.disp=NULL,
                   upper.disp=NULL,
                   parName="xi")
```

The measurement error model is defined below.

``` r

    lmeObject_JM <- list(nf = "nf2" ,
                         model= cd4 ~ nf(p1,p2,p3,day),
                         var=c("day"),
                         fixed = p1+p2+p3 ~1,
                         random = p1 ~1,
                         family='normal', 
                         ran.dist='normal',
                         fixName="gamma",
                         ranName="b",
                         dispName="sigb",
                         sigma=sigma1,
                         ran.Cov=NULL,
                         str.fixed=fixef(cd4.fit),
                         str.disp=as.numeric(VarCorr(cd4.fit)[,"StdDev"][1]),
                         lower.fixed=NULL,
                         upper.fixed=rep(100,3),
                         lower.disp=c(0),
                         upper.disp=c(Inf)
                         )
```

``` r

    sigma2 <- list(model=~1+cd4.true+(1|patid),
                   link='log',
                   ran.dist="normal",
                   str.fixed=c(2*log(nlme.fit$sigma), 0),
                   lower.fixed=NULL,
                   upper.fixed=NULL,
                   fixName="alpha",
                   ranName="a",
                   dispName="siga",
                   str.disp=0.5,
                   trueVal.model=list(var="cd4.true", model=lmeObject_JM)
                   )
# variance model
```

Finally, both models are fitted simultaneously.

``` r

    nlmeObject_JM <- list(nf = "nf1",
                          model= lgcopy ~ nf(p1,p2,p3,day),
                          var=c("day"),
                          fixed = p1+p2+p3 ~1,
                          random = p1+p3 ~1,
                          family='normal', 
                          ran.dist='normal',
                          fixName="beta",
                          ranName="u",
                          dispName="d",
                          sigma=sigma2,
                          ran.Cov=NULL,
                          str.fixed=fixef(nlme.fit),
                          str.disp=as.numeric(VarCorr(nlme.fit)[,"StdDev"][c("p1", "p3")]),
                          lower.fixed=NULL,
                          upper.fixed=rep(100,3),
                          lower.disp=c(0,0),
                          upper.disp=c(Inf,Inf)
                          )
    
    nlmeObjects_JM <- list(nlmeObject_JM, lmeObject_JM)
    
    JM <- try(Rnlme(nlmeObjects=nlmeObjects_JM, long.data=simdat, 
                    idVar="patid", sd.method="HL", dispersion.SD = TRUE,
                    independent.raneff="byModel"))
#> Error in str_trim(resp) : could not find function "str_trim"
    saveRDS(JM, file = "JM.rds")
```

## Summary

This tutorial demonstrated how `JMVN` can be used to fit nonlinear mixed
effects models with flexible dispersion structures.

The two-step approach provides a computationally simpler strategy, while
the joint modeling approach accounts for uncertainty in the auxiliary
process by estimating all components simultaneously.
