seaaroundus
===========



[![cran version](https://www.r-pkg.org/badges/version/seaaroundus)](https://cran.r-project.org/package=seaaroundus)
[![Build Status](https://api.travis-ci.org/ropensci/seaaroundus.svg?branch=master)](https://travis-ci.org/ropensci/seaaroundus)
[![codecov](https://codecov.io/gh/ropensci/seaaroundus/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/seaaroundus)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/seaaroundus)](https://github.com/metacran/cranlogs.app)


## Sea Around Us API Wrapper

R wrapper for the Sea Around Us API.

The Sea Around Us data are licensed to the public under a Creative Commons Attribution-NonCommercial-ShareAlike
    4.0 International Public License.

Please read the data use policy described in the DATA_USE file.

This software is free software:  you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.  See the LICENSE file for a full statement of the License.

### A note on usage

When querying the API, please be respectful of the resources required to provide this data. We recommend you retain the results for each request so you can avoid repeated requests for duplicate information.


### Prerequisites

*Mac via Homebrew*
```bash
$ brew tap homebrew/versions
$ brew install v8-315 gdal
```

*Linux via apt-get*
```bash
$ sudo apt-get install libgdal1-dev libgdal-dev libgeos-c1 libproj-dev
```


### Installation

CRAN version


```r
install.packages("seaaroundus")
```

Dev version


```r
install.packages("devtools")
devtools::install_github("ropensci/seaaroundus")
```


```r
library(seaaroundus)
```

### Example usage

list available eezs


```r
head(listregions('eez'))
#>                            title  id
#> 1                        Albania   8
#> 2                        Algeria  12
#> 3                 American Samoa  16
#> 4 Andaman & Nicobar Isl. (India) 357
#> 5                         Angola  24
#> 6                  Anguilla (UK) 660
```

get species data for Brazil as a data frame


```r
head(catchdata("eez", 76))
#>   years brazilian sardinella whitemouth croaker atlantic seabob
#> 1  1950                    0           7129.341               0
#> 2  1951                    0           6499.208               0
#> 3  1952                    0           6608.910               0
#> 4  1953                    0           6769.266               0
#> 5  1954                    0           6168.482               0
#> 6  1955                    0           6976.245               0
#>   sea catfishes, coblers herrings, sardines, menhadens argentine croaker
#> 1               2913.719                      5857.411          1707.013
#> 2               3280.651                      5267.541          1599.238
#> 3               3333.485                      5356.747          2002.369
#> 4               3417.538                      5486.354          1348.201
#> 5               3664.398                      4935.857          1827.590
#> 6               3652.267                      5639.058          2131.946
#>   king weakfish argentine hake drums, croakers grey mullets   others
#> 1      5076.131              0        1544.886      941.349 25156.60
#> 2      4565.233              0        1794.251      846.551 26962.93
#> 3      4642.063              0        1853.677      860.887 28678.96
#> 4      4754.324              0        1844.091      881.717 26989.10
#> 5      4277.566              0        2065.444      793.246 30082.72
#> 6      4900.144              0        2025.746      906.258 32000.83
```

use alternative API environment (available on all functions)
> NOTE: alternative API environments may not always be publically accessible or stable


```r
head(catchdata("eez", 76, env="qa"))
#>   years brazilian sardinella whitemouth croaker atlantic seabob
#> 1  1950                    0           7129.341               0
#> 2  1951                    0           6499.208               0
#> 3  1952                    0           6608.910               0
#> 4  1953                    0           6769.266               0
#> 5  1954                    0           6168.482               0
#> 6  1955                    0           6976.245               0
#>   sea catfishes, coblers herrings, sardines, menhadens argentine croaker
#> 1               2913.719                      5857.411          1707.013
#> 2               3280.651                      5267.541          1599.238
#> 3               3333.485                      5356.747          2002.369
#> 4               3417.538                      5486.354          1348.201
#> 5               3664.398                      4935.857          1827.590
#> 6               3652.267                      5639.058          2131.946
#>   king weakfish argentine hake drums, croakers grey mullets   others
#> 1      5076.131              0        1544.886      941.349 25156.60
#> 2      4565.233              0        1794.251      846.551 26962.93
#> 3      4642.063              0        1853.677      860.887 28678.96
#> 4      4754.324              0        1844.091      881.717 26989.10
#> 5      4277.566              0        2065.444      793.246 30082.72
#> 6      4900.144              0        2025.746      906.258 32000.83
```

get top 3 species data for Brazil as a data frame


```r
head(catchdata("eez", 76, limit=3))
#>   years brazilian sardinella whitemouth croaker atlantic seabob   others
#> 1  1950                    0           7129.341               0 43197.11
#> 2  1951                    0           6499.208               0 44316.40
#> 3  1952                    0           6608.910               0 46728.19
#> 4  1953                    0           6769.266               0 44721.33
#> 5  1954                    0           6168.482               0 47646.82
#> 6  1955                    0           6976.245               0 51256.25
```

get reporting status data by value for Brazil as a data frame


```r
head(catchdata("eez", 76, measure="value", dimension="reporting-status"))
#>   years  reported unreported
#> 1  1950  443600.5  194909739
#> 2  1951  498019.1  188595589
#> 3  1952  562198.1  181745220
#> 4  1953  389671.3  160502627
#> 5  1954  802928.4  120388021
#> 6  1955 2531927.4  103156694
```

get species data for Brazil as a chart


```r
catchdata("eez", 76, chart=TRUE)
```

eez vs high seas percent catch data frame
> NOTE: data not available until SeaAroundUs global paper is released


```r
head(eezsvshighseas())
#>   year eez_percent_catch high_seas_percent_catch
#> 1 1950                99                       1
#> 2 1951                99                       1
#> 3 1952                99                       1
#> 4 1953                99                       1
#> 5 1954                99                       1
#> 6 1955                99                       1
```

eez vs high seas percent catch graph


```r
eezsvshighseas(chart=TRUE)
```

marine trophic index for Brazil as a data frame


```r
head(marinetrophicindex("eez", 76))
#>   level year
#> 1  3.51 1950
#> 2  3.53 1951
#> 3  3.53 1952
#> 4  3.52 1953
#> 5  3.54 1954
#> 6  3.54 1955
```

marine trophic index for Brazil as graph


```r
marinetrophicindex("eez", 76, chart=TRUE)
```

get cells for a shape in WKT format


```r
wkt <- "POLYGON((2.37 43.56,13.18 43.56,13.18 35.66,2.37 35.66,2.37 43.56))"
res <- getcells(wkt)
res[1:10]
#>  [1] 66605 66606 66607 66608 66609 66610 66611 66612 66613 66614
```

get datagrid of cell data for a given year and list of cells


```r
head(getcelldata(2005, c(89568,90288,89569)))
#>   taxon_scientific_name taxon_key commercial_group_id sector_type_id
#> 1     Thunnus albacares    600143                   4              1
#> 2     Thunnus albacares    600143                   4              1
#> 3     Thunnus albacares    600143                   4              1
#> 4        Thunnus obesus    600146                   4              1
#> 5        Thunnus obesus    600146                   4              1
#> 6        Thunnus obesus    600146                   4              1
#>   commercial_group_name catch_status_name sector_type_name  catch_sum
#> 1     Tuna & billfishes          Landings       Industrial 0.02261394
#> 2     Tuna & billfishes          Landings       Industrial 0.02318308
#> 3     Tuna & billfishes          Landings       Industrial 0.02261394
#> 4     Tuna & billfishes          Landings       Industrial 0.03267660
#> 5     Tuna & billfishes          Landings       Industrial 0.03377360
#> 6     Tuna & billfishes          Landings       Industrial 0.03267660
#>   functional_group_name catch_status reporting_status taxon_common_name
#> 1             pelagiclg            R                R    Yellowfin tuna
#> 2             pelagiclg            R                R    Yellowfin tuna
#> 3             pelagiclg            R                R    Yellowfin tuna
#> 4             pelagiclg            R                R       Bigeye tuna
#> 5             pelagiclg            R                R       Bigeye tuna
#> 6             pelagiclg            R                R       Bigeye tuna
#>   fishing_entity_name year cell_id reporting_status_name
#> 1              Taiwan 2005   89569              Reported
#> 2              Taiwan 2005   90288              Reported
#> 3              Taiwan 2005   89568              Reported
#> 4              Taiwan 2005   89569              Reported
#> 5              Taiwan 2005   90288              Reported
#> 6              Taiwan 2005   89568              Reported
#>   functional_group_id fishing_entity_id
#> 1                   3                32
#> 2                   3                32
#> 3                   3                32
#> 4                   3                32
#> 5                   3                32
#> 6                   3                32
```

### Available parameters

Regions:

* eez
* lme
* rfmo
* eez-bordering
* taxon

Measures:

* tonnage
* value

Dimensions:

* taxon (not available for taxon region)
* commercialgroup
* functionalgroup
* country (fishing country)
* sector
* catchtype
* reporting-status
* eez (only available for eez-bordering and taxon regions)
* highseas (only available for taxon region)


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/seaaroundus/issues).
* License: MIT
* Get citation information for `seaaroundus` in R doing `citation(package = 'seaaroundus')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
