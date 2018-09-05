
###
##This script contains the character strings used in footnotes.

##IF you are changing the footnotes from the standard in the package, make 
##the changes to this script then run all in one ("CTRL+A" then "CTRL+R")

##IMPORTANT: do NOT then run the following line 
##"source(system.file("TRA2501_sub.r",package="TRA25rap"))"
##as this will revert back to the package standards
###

foot1 <- c("Note: Totals may not match sum due to rounding")

#Note if you want to change where the footnotes go you need to go "deeper" into the code, it
#is in the function "add_footnote_refs" in this package
foot2_main <- c("[1] Figures affected by September 2000 fuel protest",
                "[2] 2001 figures affected by the impact of Foot and Mouth disease",
                "[3] Affected by heavy snowfall. It is estimates that snowfall during Q4 2010 and Q1 2018 had greater impact on traffic",
                "levels than snowfall during Q1 2009, Q1 2010, and Q1 2013")

foot3_vehicle <- c("P Provisional", 
                   "Other = Two wheeled motor vehicles, buses, and coaches")

foot3_road <-  c("[4] The urban/rural classificiation has been updated in 2017. For more information see the accompanying release",
                 "P Provisional")

foot3_vehicle_road <- c("[4] The urban/rural classificiation has been updated in 2017. For more information see the accompanying release",
                        "P Provisional",
                        "Note: all roads for Heavy Goods Vehicles includes minor roads")


foot4_end <- c("Telephone: 020 7944 3095",
               "Email: roadtraff.stats@dft.gov.uk",
               "The figures in this table are National Statistics",
               "",
               "Source: DfT National Road Traffic Survey",
               paste("Last updated:", last_updated),
               paste("Next update:", next_update))










