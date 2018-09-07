
###
##This script contains the character strings used in footnotes.

##IF you are changing the footnotes from the standard in the package, make 
##the changes to this script then run all in one ("CTRL+A" then "CTRL+R")

##IMPORTANT: after doing this, do NOT then run the following line 
##"source(system.file("TRA2501_sub.r",package="TRA25rap"))"
##as this will revert back to the package standards
##

##IMPORTANT: if you are changing the footnote assignments within the data, not
##just a change in the sentence structure, you will also need to change  
##things under the line "FOOTNOTES ON IN COLUMN C - EDIT MANUALLY" in the function
##at the bottom of this script.

foot1 <- c("Note: Totals may not match sum due to rounding")

#Note if you want to change where the footnotes go you need to go "deeper" into the code, it
#is in the function "add_footnote_refs" in this package
foot2_main <- c("[1] Figures affected by September 2000 fuel protest",
                "[2] 2001 figures affected by the impact of Foot and Mouth disease",
                "[3] Affected by heavy snowfall. It is estimates that snowfall during Q4 2010 and Q1 2018 had greater impact on traffic",
                "    levels than snowfall during Q1 2009, Q1 2010, and Q1 2013")

foot3_vehicle <- c("P Provisional", 
                   "Other = Two wheeled motor vehicles, buses, and coaches")

foot3_road <-  c("[4] The urban/rural classificiation has been updated in 2017. For more information see the accompanying release",
                 "    Please note that only columns with \"Urban\" and \"Rural\" have a break in the time series.",
                 "P Provisional")

foot3_vehicle_road <- c("[4] The urban/rural classificiation has been updated in 2017. For more information see the accompanying release",
                        "    Please note that only columns with \"Urban\" and \"Rural\" have a break in the time series.",
                        "P Provisional",
                        "Note: all roads for Heavy Goods Vehicles includes minor roads")


foot4_end <- c("Telephone: 020 7944 3095",
               "Email: roadtraff.stats@dft.gov.uk",
               "The figures in this table are National Statistics",
               "",
               "Source: DfT National Road Traffic Survey",
               paste("Last updated:", last_updated),
               paste("Next update:", next_update))








add_footnote_refs_user_defined <- function(data_for_xl){
  #Adds in the footnote notations to the third col.
  #Returns 2 objects in a list, the first being data_for_xl with updated third col
  #and the second being a named list of footnote linking to reference
  
  d <- data_for_xl #just for simplicity (easier to read)
  
  ############FOOTNOTES ON IN COLUMN C - EDIT MANUALLY############
  #2000 fuel protest
  d[d$year == 2000 & d$quarter == 3, 3] <- "[1]"
  #2001 foot and mouth
  d[d$year == 2001, 3] <- "[2]"
  #heavy snowfall
  d[d$year == 2009 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2010 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2010 & d$quarter == 4, 3] <- "[3]"
  d[d$year == 2013 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2018 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2008,3] <- "test"
  
  ############URBAN/RURAL SERIES BREAK############
  #urban/rural break in the series. The if statement is "bad" coding, but a quick fix for not having
  #tables TRA2501 and TRA2504 chosen
  if (!(identical(names(d), c("year","quarter","NA","cars","lgv","hgv","other","total")))){
    d[d$year == 2017 & d$quarter == 4, 3] <- "[4]"}
  warning("add_footnotes_ref_user_defined as a function could be neater - look into developing")
  
  ############PROVISIONAL ESTIMATE "P" ADDED############
  d[is.na(d[,3]),3] <- "" #make the NA values nice character strings for next part.
  #provisional estimates. The complicated line is just ensuring the "P" doesn't overwrite a previous
  #footnote in that cell
  d[d$year == tail(d$year,1), 3] <- sapply(d[d$year == tail(d$year,1), 3], function(x) paste(x, "P"))
  #LS: provisional are currently defined by if most recent year. Maybe not true?
  
  footnote_refs <- unique(d[,3])
  
  return(list(d, footnote_refs))
}


