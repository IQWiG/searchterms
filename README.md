
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Proof of concept version for presentation at \#ESMARConf2023

# searchterms

<!-- badges: start -->
<!-- badges: end -->

The goal of searchterms is to identify overrepresented terms in a set of
relevant references for a systematic review, which can then be applied
in a boolean search in a bibliograpic database.

## Installation

Instructions for installation will follow with the official release of
the package.

## Example

This is a basic example which shows you how to solve a common problem,
the package was designed for:

``` r
library(searchterms)
path <- system.file("extdata", "example_ris.txt", package= "searchterms", mustWork = T)
data <- z_scores(path)
head(print_z_scores(data, terms = "freetext") )
#>      Wort Wortfrequenz Anzahl Referenzen Erwartete Frequenz   Z-Score
#> 1     ris            2                 1       7.853101e-05 225.68006
#> 2    file            2                 1       1.927579e-04 144.04032
#> 3 package            1                 1       2.498714e-04  63.24641
#> 4    text            1                 1       7.638926e-04  36.15433
#> 5 version            1                 1       1.249357e-03  28.25708
#> 6 typical            1                 1       1.613455e-03  24.85637
#>   Approximationskriterium zutreffend?
#> 1                               FALSE
#> 2                               FALSE
#> 3                               FALSE
#> 4                               FALSE
#> 5                               FALSE
#> 6                               FALSE
head(print_z_scores(data, terms = "MeSH"))
#> # A tibble: 3 × 5
#>   MeSH                        Frequenz `Erwartete Frequenz` `Z-Score` Approxim…¹
#>   <chr>                          <int>                <dbl>     <dbl> <lgl>     
#> 1 Systematic Reviews as Topic        1            0.0000513    140.   FALSE     
#> 2 Adult                              1            0.0515         4.22 FALSE     
#> 3 Library Automation                 1           NA          10000    NA        
#> # … with abbreviated variable name ¹​`Approximationskriterium zutreffend?`
```
