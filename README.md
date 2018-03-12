
<!-- README.md is generated from README.Rmd. Please edit that file -->
**Warning: `LStest` is in its early stages of development.** It is based heavily on the `xltabr` package developed by members of the Ministry of Justice (MoJ).

If you are not a member of the Department for Transport (DfT) **I highly recommend you instead [use the `xltabr` package](https://github.com/moj-analytical-services/xltabr)**, as it is a far more developed and organised package. Even if you do work for DfT, that package is definitely worth a look!

I'm stuck - help!
=================

If you are having problems with this package, there are different places you can find help:

-   Google (it can't hurt)
-   Raise an issue on GitHub if you have found a bug
-   Look at other documentation: \_\_\_\_\_\_\_
-   Email me:

update

LStest - what is it?
====================

This purpose of this package is to help users present beautifully formatted Excel tables in the DfT standard format. This will act as a segment of the [pipeline dream](https://ukgovdatascience.github.io/rap_companion/) for transforming the way that official statistics are produced.

It acts as a DfT-tailored version of xltabr, including all the functions and code that I (Luke Shaw) wrote and developed - all focused primarily around `xltabr`.

The "patient zero" tables which this package was initially created for at the Quarterly provisional road traffic estimate tables, [TRA25](https://www.gov.uk/government/statistical-data-sets/tra25-quarterly-estimates). Many of the in-built checks and code are bespoke to issues with those tables, however the intention is that these can be used as a springboard to producing reproducible code for other teams' tables.

<a name="inst"></a> Installation
--------------------------------

update

Example
-------

This is an example of the power of this package - it can reproduce and update tables through the simple updating of the data in its raw format online.

First, ensure the package is in the Environment. Note you would have to have installed the package first (see [above](#inst) - only needs to be done once per desktop).

``` r
library(LStest) 
```

Second, download the raw data from online.

``` r
raw <- api_get_data("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly") 
raw
#> # A tibble: 1,900 x 5
#>     year quarter road_type vehicle_type estimate
#>    <dbl>   <dbl> <chr>     <chr>           <dbl>
#>  1  1994    1.00 AR        cars           21.8  
#>  2  1994    1.00 AR        hgv             2.22 
#>  3  1994    1.00 AR        lgv             2.77 
#>  4  1994    1.00 AR        other           0.324
#>  5  1994    1.00 AU        cars           15.9  
#>  6  1994    1.00 AU        hgv             0.762
#>  7  1994    1.00 AU        lgv             1.80 
#>  8  1994    1.00 AU        other           0.428
#>  9  1994    1.00 MR        cars           11.1  
#> 10  1994    1.00 MR        hgv             0.433
#> # ... with 1,890 more rows
```

If your data is in a csv on your desktop you can get it into R easily, an example of how to do that is given at <http://rprogramming.net/read-csv-in-r/>

There are 2 steps to outputting nice Excel tables from raw data: 1. rearrange the data into correct shape 2. create the Excel table (including headers, footers, formatting etc.)

### Step 1 - rearranging the data

We can format the data as desired, which for sheet TRA2504a in table TRA2504 is: rolling annual vehicle kilometres split into different vehicle types. Using the bespoke function `raw2new` this means simply one line of code specifying each decision:

``` r
new_data <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "km")
head(new_data)
#>   year quarter     cars      hgv      lgv    other      AMV
#> 1 1994       4 345.0251 24.77492 43.33545 8.404446 421.5399
#> 2 1995       1 346.6666 25.00120 43.57545 8.430031 423.6733
#> 3 1995       2 348.4991 25.18520 43.98851 8.505467 426.1783
#> 4 1995       3 350.0716 25.28411 44.38526 8.587944 428.3289
#> 5 1995       4 351.1199 25.44387 44.50978 8.648314 429.7219
#> 6 1996       1 353.7160 25.59061 44.94699 8.687956 432.9415
```

### Step 2 - format into an Excel table

Now the data is in the right shape for making the table. After naming the title and footer this is all done inside the `new2xl` function:

``` r
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2504a",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1993",
                "",
                "Billion vehicle kilometres (not seasonally adjusted)")
footer_text <- c("",
                 "(1) Two wheeled motor vehicles, buses, and coaches",
                 "(2) Total may not match sum due to rounding",
                 "(3) figures affected by September 2000 fuel protest",
                 "The figures in these tables are National Statistics")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2504a")
#> 
#>  The file:  new2xl03-12_1636.xlsx 
#>  Has been saved in the following location on your desktop: 
#>  /Users/Luke/LStest
```

The table has now been saved in the directory where you're working, if you can find it you can see the path by typing `getwd()` in R.

to do - add the image of outputted Excel table
