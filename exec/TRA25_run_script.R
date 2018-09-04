########
##Script that outputs all TRA25 tables in 6 steps :)
##API currently needs altering
########
library(TRA25rap)
#1) check the API at https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly has the most uptodate data

#2) change the following line to where in your docs you want the tables to save (*)
save_loc <- "~/table_dump"
#   (*)If you don't know uncomment the following line:
#   rm(save_loc)
#   and then it will be saved to where your current session is, which you can see by running this:
#   getwd()

#3) Update the 4 things below.
year <- 2018
quarter <- 1
last_updated <- "July 2018"
next_update <- "September 2018"
num_dp <- 100 #number of decimal places to round to for output
#Footnotes
source(system.file("footnotes.R",package="TRA25rap"))
#if you want to update the file run the commented out line below and follow instructions
#file.edit(system.file("footnotes.R", package="TRA25rap"))



##You now have a choice. If the API is updated you can use the following lines:
raw <- TRA25_data_api("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly")
raw_seasonal <- TRA25_data_api("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly_seasonal")

##If not you have to download the data as a csv into your directory and find it
##WARNING: NEVER STORE OR SEND SENSITIVE DATA ONTO PERSONAL DEVICES
#raw <- read.csv(file.choose())
#raw_seasonal <- read.csv(file.choose())
#raw <- tibble::as.tibble(raw)
#raw_seasonal <- tibble::as_tibble(raw_seasonal)

#4) run this whole script - you can do this with the shortcuts "CTRL + A" then "CTRL + R"

source(system.file("TRA2501_sub.r",package="TRA25rap"))
source(system.file("TRA2502_sub.r",package="TRA25rap"))
source(system.file("TRA2503_sub.r",package="TRA25rap"))
source(system.file("TRA2504_sub.r",package="TRA25rap"))
source(system.file("TRA2505_sub.r",package="TRA25rap"))
source(system.file("TRA2506_sub.r",package="TRA25rap"))

#5) CHECK FOR ANY ERRORS OR WARNINGS in the output - you'll know them because they are in red :)
#   This includes scrolling right the way up the consol to where the first line was run (which is
#   where save_loc is defined)
#   It is important you understand any that happen, as this process is new so there could be bugs
#   Report any bugs to the appropriate person!

#6) Look at the tables in your location. It's important to QA them (same reason as above!)
