
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

This purpose of this package is to help users present beautifully formatted Excel tables in the DfT standard format. This package can automate the entire table making process, as shown in the image below. Part of why this is so powerful is that it is exactly repeatable, once the code is written all that is needed is an update to the data and then just re-run!

<img src="https://image.ibb.co/iWMyHx/flow_pipe.png?raw=TRUE" />

This will act as a segment of the [pipeline dream](https://ukgovdatascience.github.io/rap_companion/) for transforming the way that official statistics are produced.

This package is a DfT-tailored version of xltabr, including all the functions and code that I (Luke Shaw) wrote and developed - all focused primarily around `xltabr`.

The "patient zero" tables which this package was initially created for at the Quarterly provisional road traffic estimate tables, [TRA25](https://www.gov.uk/government/statistical-data-sets/tra25-quarterly-estimates). Practically all of the in-built checks and code are bespoke to issues with those tables, however the intention is that these can be used as a springboard to producing reproducible code for other teams' tables.

<a name="inst"></a> Installation
--------------------------------

This document assumes you have an understanding of coding in RStudio.

Installing the most up-to-date version of this package can be done inside R, *IF* you are working off-network (eg on a laptop):

``` r
#1) first be logged in to departmentfortransport private repo
#2) in browser, go to github/settings/tokens
#3) set up token - scope 'repo'
#copy token and use that in auth_token argument

library(devtools) #devtools has to be installed first
devtools::install_github(repo = "departmentfortransport/ac-roadtraff-pipe"
                         ,auth_token = "copyinyournewflashytoken")
library(LStest)
```

If you are working on the network, a workaround for this is the following:

Click the "Clone or download" button in the top right hand corner of this page and select "Download ZIP". Then, you will have to open your file explorer and manually put the folder into the location of your installed R packages. To find out where your R packages are installed, type `.libPaths()` in your console. Hopefully you can then type `library(LStest)` and everything works out fine.

<c name="SRF2"></c> "I'm in the Road Stats team and I want to make new TRA25 tables"
------------------------------------------------------------------------------------

Great! You'll need to install the package onto your desktop and have R set up on the system. Then, you need to read through and run the script "TRA25\_run\_script.R" that is in the "exec" folder of this package. You can open it in RStudio by the usual file finder way or by running:

``` r
file.edit(system.file("exec", "TRA25_run_script.R", package="LStest"))
```

in your console which will open the file. Make sure you read all the comments, and without any hiccups you should have the tables ready in under 5 minutes! Whilst in the development stages, do not be afraid of hiccups...

<b name="notSRF"></b> "I'm in DfT, but not the Road Stats team"
---------------------------------------------------------------

Great! Depending on how "heavy" an R-user you are may affect how much you want to use my package.

If the tables you are trying to produce are wildly different to the ones I have created with this package, you may not find any of my sub-functions useful. If you are comfortable with R, having a look at my functions may prove inspirational. If you wouldn't know how to look at the functions in a package, I wouldn't worry about it.

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

A general workflow for creating new DfT Tables should be:

1.  have a default Contents page that is made in Excel
2.  have an R script that gets the data
3.  have separate R scripts for each sheet you want to add, which takes raw data, rearranges, and formats into an excel doc

^<sup>^</sup> The above workflow and process will be updated as I try this out more within DfT. Watch this space!

Example
-------

This is an example of the power of this package - it can reproduce and update tables through the simple updating of the data in its raw format online.

First, ensure the package is in the Environment. Note you would have to have installed the package first (see [above](#inst) - only needs to be done once per desktop).

``` r
library(LStest) 
```

Second, download the raw data from online.

``` r
raw <- TRA25_data_api("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly") 
raw
#> # A tibble: 1,900 x 5
#>     year quarter road_type vehicle_type estimate
#>    <dbl>   <dbl> <chr>     <chr>           <dbl>
#>  1 1994.      1. AR        cars           21.8  
#>  2 1994.      1. AR        hgv             2.22 
#>  3 1994.      1. AR        lgv             2.77 
#>  4 1994.      1. AR        other           0.324
#>  5 1994.      1. AU        cars           15.9  
#>  6 1994.      1. AU        hgv             0.762
#>  7 1994.      1. AU        lgv             1.80 
#>  8 1994.      1. AU        other           0.428
#>  9 1994.      1. MR        cars           11.1  
#> 10 1994.      1. MR        hgv             0.433
#> # ... with 1,890 more rows
```

If your data is in a csv on your desktop you can get it into R easily, an example of how to do that is given at <http://rprogramming.net/read-csv-in-r/>

There are 2 steps to outputting nice Excel tables from raw data:
1. rearrange the data into correct shape
2. create the Excel table (including headers, footers, formatting etc.)

#### Step 1 - rearranging the data

We can format the data as desired, which for sheet TRA2501a in table TRA2501 is: rolling annual vehicle miles split into different vehicle types. Using the bespoke function `TRA25_arrange_data` this means simply one line of code specifying each decision:

``` r
data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
head(data_for_xl)
#>   year quarter     cars      lgv      hgv    other    total
#> 1 1994       4 214.3886 26.92739 15.39442 5.222279 261.9327
#> 2 1995       1 215.4086 27.07652 15.53502 5.238177 263.2583
#> 3 1995       2 216.5472 27.33318 15.64935 5.285051 264.8148
#> 4 1995       3 217.5244 27.57971 15.71081 5.336299 266.1512
#> 5 1995       4 218.1757 27.65709 15.81008 5.373812 267.0167
#> 6 1996       1 219.7889 27.92875 15.90126 5.398444 269.0173
```

#### Step 2 - format into a lovely Excel Sheet

Now the data is in the right shape for making the table. After naming the title and footer this is all done inside the `TRA25_format_to_xl` function:

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

TRA25_format_to_xl(data_for_xl,
       title_text,
       footer_text,
       table_name = "TRA2501a")
```

The above process can be repeated for each sheet in the Excel file, and by the end you will have the finished table. There is a way to append the sheet to a workbook, which is how I have made the TRA25 series. The Contents pages are the templates I use (all contained within this package) and then each sheet can be bolted on to the file. To see this in action, see the "TRA25\_run\_script.R" script in this package, which can be found by running:

``` r
file.edit(system.file("exec", "TRA25_run_script.R", package="LStest"))
```

Note if you are not in the Road Traffics team the function `TRA25_format_to_xl` is not necessarily helpful, please see [above](#notSRF)
