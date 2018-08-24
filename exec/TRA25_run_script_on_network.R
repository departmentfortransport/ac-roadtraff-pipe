########
##Script that outputs all TRA25 tables in 6 steps :)
##Follow the instructions step by step in this script!
##DO NOT RUN ALL AT ONCE - step by step is important

##The "on network" is with access to the SQL database TS01. If you are working
##on a laptop off the ETHOS network, you will need to run the other script 
##(TRA25_run_script.R)


##LS Aug 2018
########




#******************************************************************************#
#0) run the lines below
#******************************************************************************#
library(TRA25rap) #the package LS created for pipelining
library(RODBC)    #For connecting to SQL Server
library(tibble)   #the package for nice data frames




#******************************************************************************#
#1) check that the steps before this have been run and that the following table 
#in SQL has all the right data:
#******************************************************************************#
#   [TA_Quarterly].[new].[unadj_in_API_format]  




#******************************************************************************#
#2) Update the variables below.
#******************************************************************************#
year <- 2018                        #what year is being processed
quarter <- 1                        #what quarter is being processed
last_updated <- "July 2018"         #when will these tables be published
next_update <- "September 2018"     #when is the next scheduled publication
num_dp <- 1                         #Number of decimal places for table output


#******************************************************************************#
#3) Setting the save location (save_loc) for the xlsx tables that are outputted
#******************************************************************************#
#Ideally, they are put in the "table_dump" directory of the quarter that's being 
#processed. Make sure you read the output in the console after the if else 
#statement below.
save_loc <- paste0("G:\\TSTATS\\TS_GROUPS\\COMM\\03 Quarterly Publication",
                   "\\4_Table compilation\\2018 Q", quarter,
                   "\\table_dump")
if(file.exists(save_loc)){
  cat("\n save_loc is a valid file path, you can continue to the next step")
} else {
    warning(paste0("the directory for save_loc doesn't exist.", 
            "This will cause errors later if not fixed now"))}
    #^^^If you get the above warning, you can run the following line:
    #save_loc <- file.choose()
    #and then you can choose the folder for the current quarter. 
    #Do NOT set save_loc to be the ac-roadtraff-pipe-master folder!




#******************************************************************************#
#4) Connect to SQL
#******************************************************************************#
#Connect to TS01 and import table containing undadjusted quarterly data
TS01<- odbcDriverConnect('driver={SQL Server};
                         server=TS01;
                         database=TA_Quarterly;
                         trusted_connection=true')
raw <- sqlQuery(channel = TS01,
                query = "SELECT * 
                           FROM [TA_Quarterly].[new].[unadj_in_API_format] 
                           ORDER BY year, quarter, road_type, vehicle_type")
raw <- tibble::as.tibble(raw)


raw_seasonal <- raw
raw_seasonal$estimate <- 1
warning("raw_seasonal URL is currently wrong (just normal values)")




#******************************************************************************#
#5) Outputting tables!
#******************************************************************************#
#First, we load in the footnotes:
source(system.file("footnotes.R",package="TRA25rap"))
    #if you want to update the footnotes run the commented out line below and 
    #follow instructions in there:
    #file.edit(system.file("footnotes.R", package="TRA25rap"))
    #You will then need to save the file, and re-install the package TRA25rap
    #using the steps in the desknotes


#RUN LINE BY LINE 
#Each line here outputs a new table. 
source(system.file("TRA2501_sub.r",package="TRA25rap"))
source(system.file("TRA2502_sub.r",package="TRA25rap"))
source(system.file("TRA2503_sub.r",package="TRA25rap"))
source(system.file("TRA2504_sub.r",package="TRA25rap"))
source(system.file("TRA2505_sub.r",package="TRA25rap"))
source(system.file("TRA2506_sub.r",package="TRA25rap"))




#******************************************************************************#
#6) CHECK FOR ANY ERRORS OR WARNINGS in the output
#******************************************************************************#

#you'll know them because they are in red :)

#This includes scrolling right the way up the consol to where the first line 
#was run 

#It is important you understand any that happen, as this process is new so there 
#could be bugs. Report any bugs to the appropriate person!





#******************************************************************************#
#7) QA the tables
#******************************************************************************#
