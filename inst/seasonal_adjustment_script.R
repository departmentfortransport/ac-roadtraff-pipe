#########
##18/06/18 going from raw data in API format to seasonally adjusted
##Created by LS as a quick-fix as seasonal adjusted estimates are
##no longer used in the tables (as of Q2 2018)


##THIS SCRIPT IS NEVER RUN IN THE PACKAGE - this is only a storage
##place if seasonal estimates are asked for

##Run line by line, noting that the "year" and "quarter" variables
##need to be updated each time, as well as where the outputs will be saved
#########

library(tidyr)    #tidyverse
library(dplyr)    #tidyverse
library(purrr)    #tidyverse
library(RODBC)    #For connecting to SQL Server
library(seasonal) #seasonal adjustment
library(TRA25rap) #for formatting tables

##UPDATE EACH QUARTER - to the values in the database
year <- 2018
quarter <- 1
save_loc <- choose.dir() #pop up will appear, pick 
#save location of outputs!
##UPDATE EACH QUARTER - to the values in the database



############################################################
##1. Functions 
############################################################

#make the seasonal model from the subset of raw
make_model <- function(df){
  temp <- ts(df$estimate, start = c(1994,1), frequency = 4)
  model <- seas(temp)
  return(model)
}

#from the model just takes the column "final"
get_final_data <- function(model){
  return(model$data %>% as.data.frame() %>% .$final)
}

############################################################
##2. Let's do this - running the seasonal adjustment 
############################################################

#connect to SQL
TS01<- odbcDriverConnect('driver={SQL Server};server=TS01;database=TA_Quarterly;trusted_connection=true')
#get the data
raw <- sqlQuery(channel = TS01, query = "SELECT * FROM [TA_Quarterly].[new].[unadj_in_API_format]ORDER BY year, quarter, road_type, vehicle_type")

#make a column to group over
raw$veh_road <- paste0(raw$road_type, "_",raw$vehicle_type)
#list the data frames that we have grouped over
raw %>%
  group_by(veh_road) %>%
  select(estimate, veh_road) %>%
  split(.$veh_road) -> list_of_dfs

#make the SA model for each group
list_of_dfs %>% map(make_model) -> list_of_models

#get the estimates as a data frame
list_of_models %>% map_df(get_final_data) -> seasonal_estimates

#this bit is hacky - just listing the years and quarters down the side. 
#Bad practice as what if rows were mixed? We know they're not by doing 
year_quarter <- function(year, quarter){
  #outputs the years and quarters from 1994 Q1 up to given point
  YEARS <- rep(1994:(year - 1), each = 4) #all full years 
  YEARS <- append(YEARS, rep(year, times = quarter)) #quarters of this year
  
  QUARTERS <- rep(1:4, times = floor(length(YEARS) / 4)) #all full years
  QUARTERS <- append(QUARTERS, 1:quarter) #quarters of this year so far
  
  return(list(YEARS, QUARTERS))
}

seasonal_estimates$year <- year_quarter(year, quarter)[[1]]
seasonal_estimates$quarter <- year_quarter(year, quarter)[[2]]

############################################################
##3. Writing the raw file: look in directory that is save_loc
############################################################

#arrange to format for new tables
seasonal_pipe <- seasonal_estimates %>% 
  gather("vehicle_road", estimate = AR_cars:MW_other) %>% #Pivoting the data from cols to rows
  separate(vehicle_road, c("road_type","vehicle_type")) #eg "AR_cars" becomes 2 cols "AR" and "cars"
seasonal_pipe <- seasonal_pipe %>%
  select(year, quarter, road_type, vehicle_type, estimate = value) %>% #renaming "value" as "estimate"
  arrange(year, quarter, road_type, vehicle_type) #identical to ORDER BY in SQL

#write for new tables (as "seasonal_raw.csv")
write.csv(seasonal_pipe, paste0(save_loc,"\\seasonal_raw.csv"), row.names = FALSE)

############################################################
##4. table outputs 
############################################################

#depending on which table is being asked for, you need to 
#change the definitions in TRA25_arrange_data function

#NOTE - sheet "d" is always the one that contains the actual 
#data, that is why TRA2501d,TRA2502d, and TRA2503d are 
#made below. For others (sheets f/g or other tables) it may
#be easier to just edit these outputs in Excel. 
#ALTERNATIVELY - you can run the command:
#     ?TRA25_arrange_data 
#to see how the function works and change the parametrs to
#match whichever table you want!

TRA2501d <- TRA25rap::TRA25_arrange_data(seasonal_pipe, 
                               roll=F, 
                               type="vehicle", 
                               units="traffic", 
                               km_or_miles = "miles")
write.csv(TRA2501d, paste0(save_loc,"\\TRA2501d_unformatted.csv"), row.names = FALSE)

TRA2502d <- TRA25rap::TRA25_arrange_data(seasonal_pipe, 
                                     roll=F, 
                                     type="road", 
                                     units="traffic", 
                                     km_or_miles = "miles")
write.csv(TRA2502d, paste0(save_loc,"\\TRA2502d_unformatted.csv"), row.names = FALSE)

TRA2503d <- TRA25rap::TRA25_arrange_data(seasonal_pipe, 
                                         roll=F, 
                                         type="vehicle_and_road", 
                                         units="traffic", 
                                         km_or_miles = "miles")
write.csv(TRA2503d, paste0(save_loc,"\\TRA2503d_unformatted.csv"), row.names = FALSE)

##below are some examples of how to get sheets f and g for 
#TRA2501. Commented out as not essential

#TRA2501f <- TRA25rap::TRA25_arrange_data(seasonal_pipe, 
#                                         roll=F, 
#                                         type="vehicle", 
#                                         units="index",
#                                         index_from=c(1,2,3,4),
#                                         km_or_miles = "miles")
#write.csv(TRA2501f, paste0(save_loc,"\\TRA2501f_unformatted.csv"), row.names = FALSE)
#
#TRA2501g <- TRA25rap::TRA25_arrange_data(seasonal_pipe, 
#                                         roll=F, 
#                                         type="vehicle", 
#                                         units="percentage",
#                                         km_or_miles = "miles")
#write.csv(TRA2501g, paste0(save_loc,"\\TRA2501g_unformatted.csv"), row.names = FALSE)

















