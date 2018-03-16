
<!-- README.md is generated from README.Rmd. Please edit that file -->
**Warning: `LStest` is in its early stages of development.** It is based heavily on the `xltabr` package developed by members of the Ministry of Justice (MoJ).
---------------------------------------------------------------------------------------------------------------------------------------------------------------

If you are not a member of the Department for Transport (DfT) **I highly recommend you instead [use the `xltabr` package](https://github.com/moj-analytical-services/xltabr)**, as it is a far more developed and organised package. Even if you do work for DfT, that package is definitely worth a look!

"I'm stuck... help!"
--------------------

If you are having problems with this package, there are different places you can find help:

-   Read all of this document
-   Look at other documentation: `xltabr` is better documented(!)
-   [Raise an issue](https://github.com/departmentfortransport/ac-roadtraff-pipe/issues) on GitHub if you have found a bug within this package
-   Email me: <Luke.Shaw@dft.gsi.gov.uk>
-   Google (it can't hurt) - especially if your problem is likely a problem with R coding

LStest - what is it?
--------------------

This purpose of this package is to help users present beautifully formatted Excel tables in the DfT standard format. When functioning as designed, it can go automate the entire table making process as shown in the image below. Part of why this is so powerful is that it is exactly repeatable, once the code is written all that is needed is an update to the data and with one click the tables are made!

<img src="/Users/Luke/Library/R/3.4/library/LStest/image3.png" width="100%" />

This will act as a segment of the [pipeline dream](https://ukgovdatascience.github.io/rap_companion/) for transforming the way that official statistics are produced.

This package is a DfT-tailored version of xltabr, including all the functions and code that I (Luke Shaw) wrote and developed - all focused primarily around `xltabr`.

The "patient zero" tables which this package was initially created for at the Quarterly provisional road traffic estimate tables, [TRA25](https://www.gov.uk/government/statistical-data-sets/tra25-quarterly-estimates). Many of the in-built checks and code are bespoke to issues with those tables, however the intention is that these can be used as a springboard to producing reproducible code for other teams' tables.

<a name="inst"></a> Installation
--------------------------------

This document assumes you have an understanding of coding in RStudio.

Installing the most up-to-date version of this package can be done in 2 lines of code in R:

``` r
install.packages("devtools")
devtools::install_github("username/packagename")
```

If you receive an error in the above, it is likely that you are on the ETHOS network and RStudio is forbidden from accessing the internet. A workaround for this is the following:

Click the "Clone or download" button in the top right hand corner of this page and select "Download ZIP". Then, you will have to open your file explorer and manually put the folder into the location of your installed R packages. To find out where your R packages are installed, type `.libPaths()` in your console. Hopefully you can then type `library(LStest)` and everything works out fine.

<c name="SRF2"></c> "I'm in the Road Stats team and I want to make new TRA25 tables"
------------------------------------------------------------------------------------

Great!

<b name="notSRF"></b> "I'm in DfT, but not the Road Stats team"
---------------------------------------------------------------

Great! Depending on how "heavy" an R-user you are may affect how much you want to use my package.

If the tables you are trying to produce are wildly different to the ones I have created with this package, you may not find any of my sub-functions useful. If you are comfortable with R, having a look at my subfunctions may prove inspirational. If you wouldn't know how to look at the subfunctions in a package, I wouldn't worry about it.

Mainly, I would suggest reading all of the [`xltabr` readme](https://github.com/moj-analytical-services/xltabr/) to understand what this is about. Then, when writing your scripts use the DfT Style Path document in this package, which you can get in 2 ways:

1.  Download my package and then in your script where the table is made run:

``` r
xltabr::set_style_path(system.file("DfT_styles.xlsx", package = "LStest"))
```

1.  Go to the 'inst' folder of this package's GitHub and download "DfT\_styles.xlsx" and then:

``` r
xltabr::set_style_path("/whereyousavedit/.../DfT_styles.xlsx")
```

This ensures that DfT\_styles can act as a master document for DfT-formatted tables, and as such we have no inconsistencies with font style, size, and colourings.

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
new_data <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
head(new_data)
#>   year quarter     cars      hgv      lgv    other    total
#> 1 1994       4 214.3886 15.39442 26.92739 5.222279 261.9327
#> 2 1995       1 215.4086 15.53502 27.07652 5.238177 263.2583
#> 3 1995       2 216.5472 15.64935 27.33318 5.285051 264.8148
#> 4 1995       3 217.5244 15.71081 27.57971 5.336299 266.1512
#> 5 1995       4 218.1757 15.81008 27.65709 5.373812 267.0167
#> 6 1996       1 219.7889 15.90126 27.92875 5.398444 269.0173
```

### Step 2 - format into a lovely Excel Sheet

Now the data is in the right shape for making the table. After naming the title and footer this is all done inside the `new2xl` function:

``` r
###TRA2501a####
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2501a",
                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1993",
                "",
                "Billion vehicle miles (not seasonally adjusted)")
footer_text <- c("Other = Two wheeled motor vehicles, buses, and coaches",
                 "Note Total column may not match sum due to rounding",
                 "(3) Figures affected by September 2000 fuel protest",
                 "(4) 2001 figures affected by the impact of Foot and Mouth disease",
                 "(5) Affected by heavy snowfall",
                 "P Provisional",
                 "Telephone: 020 7944 3095",
                 "Email: roadtraff.stats@dft.gsi.gov.uk",
                 "The figures in this table are National Statistics",
                 "",
                 "Source: DfT National Road Traffic Survey",
                 "Last updated: November 2017",
                 "Next update: May 2018")

new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2501a")
```

The above process can be repeated for each sheet in the Excel file, and by the end you will have the finished table. Currently there is no way to make the Contents page, but this could be done as an extra feature of this package. The recommended method is to have the file saved with the Contents sheet already in place, and to write over the file each time. To see how to do this, look in `?new2xl`.

Note if you are not in the Road Traffics team the function `new2xl` is not necessarily helpful, please see [above](#notSRF)
