########
##Script that outputs all TRA25 tables in 6 steps :)
##15/03/2018 work in progress
########
library(LStest)
#1) check the API at https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly has the most uptodate data

#2) change the following line to where in your docs you want the tables to save (*)
save_loc <- "~/table_dump"
#   (*)If you don't know uncomment the following line:
#   rm(save_loc)
#   and then it will be saved to where your current session is, which you can see by running this:
#   getwd()

#3) Update the 4 things below.
year <- 2017
quarter <- 3
last_updated <- "November 2017"
next_update <- "May 2018"

#4) run this whole script - you can do this with the shortcuts "CTRL + A" then "CTRL + R"

raw <- TRA25_data_api()
source(system.file("TRA2501_sub.r",package="LStest"))
source(system.file("TRA2502_sub.r",package="LStest"))
source(system.file("TRA2503_sub.r",package="LStest"))

#5) CHECK FOR ANY ERRORS OR WARNINGS in the output - you'll know them because they are in red :)
#   This includes scrolling right the way up the consol to where the first line was run (which is
#   where save_loc is defined)
#   It is important you understand any that happen, as this process is new so there could be bugs
#   Report any bugs to the appropriate person!

#6) Look at the tables in your location. It's important to QA them (same reason as above!)
