
###
##This script contains the character strings used in footnotes.

##IF you are changing the footnotes from the standard in the package, make 
##the changes to this script then run all in one ("CTRL+A" then "CTRL+R")

##IMPORTANT: do NOT then run the following line 
##"source(system.file("TRA2501_sub.r",package="TRA25rap"))"
##as this will revert back to the package standards
###
foot1_SA <- c("*Quarterly figures are subject to revision due to the nature of the seasonal adjustment. However, these will typically",
              "be minor and will not affect ovarall patterns shown.",
              "Note: Totals may not match sum due to rounding")

foot1_not_SA <- c("Note: Totals may not match sum due to rounding")

foot2_vehicle <- c("Other = Two wheeled motor vehicles, buses, and coaches")

foot2_road <- c() #currently nothing to add!

foot2_vehicle_road <- c("Note: all roads for Heavy Goods Vehicles includes minor roads")

foot3_main <- c("[1] Figures affected by September 2000 fuel protest",
                "[2] 2001 figures affected by the impact of Foot and Mouth disease",
                "[3] Affected by heavy snowfall. It is estimates that snowfall during Q4 2010 had a greater impact on traffic levels than",
                "for the other assigned quarters",
                "P Provisional")


foot4_end <- c("Telephone: 020 7944 3095",
               "Email: roadtraff.stats@dft.gsi.gov.uk",
               "The figures in this table are National Statistics",
               "",
               "Source: DfT National Road Traffic Survey",
               paste("Last updated:", last_updated),
               paste("Next update:", next_update))










