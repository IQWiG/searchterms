
<!-- README.md is generated from README.Rmd. Please edit that file -->

# searchterms

<!-- badges: start -->
<!-- badges: end -->

The goal of searchterms is to identify overrepresented terms in a set of
relevant references for a systematic review, which can be applied in a
boolean search.

## Installation

You can install the development version of searchterms from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("claudiakapp/searchterms")
```

## Statistics

The test statistic is a binomial test, which is implemented in the
internal function “calculate_z\_scores()” and defined with:

x = observed frequency of each unique term, merged\$testset_freq  
n = Sample size, the amount of all terms in the sample, merged\$n  
p = expected frequency of each unique term in the norm population
erwarteten Häufigkeit (aus dem Referenzpool bestimmt), merged\$p

The expected frequency in the sample is approximated with n\*p and the
variance with n\*p\*(1-p). The z-score is calculated with: (x – n\*p) /
sqrt( n\*p\*(1-p) )

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(searchterms)
path <- system.file("extdata", "example_ris.txt", package= "searchterms", mustWork = T)
data <- z_scores(path)
head(print_z_scores(data, terms = "freetext") )
#>         Wort Wortfrequenz Anzahl Referenzen Erwartete Frequenz   Z-Score
#> 1        cyc            2                 1       9.566505e-05 204.47143
#> 2  nephritis            6                 1       5.165913e-03  83.40802
#> 3  worrisome            1                 1       2.869952e-04  59.01172
#> 4      lupus            6                 1       1.042749e-02  58.65626
#> 5        aza            2                 1       1.339311e-03  54.61343
#> 6 quiescence            1                 1       6.696554e-04  38.61748
#>   Approximationskriterium zutreffend?
#> 1                               FALSE
#> 2                               FALSE
#> 3                               FALSE
#> 4                               FALSE
#> 5                               FALSE
#> 6                               FALSE
head(print_z_scores(data, terms = "MeSH"))
#> # A tibble: 6 × 5
#>   MeSH                 Frequenz `Erwartete Frequenz` `Z-Score` Approximationsk…¹
#>   <chr>                   <int>                <dbl>     <dbl> <lgl>            
#> 1 Abatacept                   1            0.0000799     112.  FALSE            
#> 2 Immunoconjugates            1            0.000479       45.7 FALSE            
#> 3 Lupus Nephritis             1            0.000479       45.7 FALSE            
#> 4 Antirheumatic Agents        1            0.000799       35.4 FALSE            
#> 5 Cyclophosphamide            1            0.00200        22.3 FALSE            
#> 6 Double-Blind Method         1            0.00679        12.1 FALSE            
#> # … with abbreviated variable name ¹​`Approximationskriterium zutreffend?`
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.
