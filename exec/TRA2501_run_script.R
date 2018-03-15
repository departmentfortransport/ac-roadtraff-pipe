########
##Script that outputs TRA2501 as one doc
##13/03/2018 work in progress

##CHANGE LINE 9 TO YOUR DESIRED FOLDER THEN RUN ALL IN ONE GO BY PRESSING
##"CTRL+ A" then "CTRL + R"
########

save_loc <- "/Users/Luke/Documents/table_dump/"
#^^^^CHANGE the above line to where in your documents you want to save the file
#If you don't know run the following line:
#  rm(save_loc)
#and then it will be saved to where your current session is, which you can see
#by running:
#  getwd()
year <- 2017
quarter <- 3
last_updated <- "November 2017"
next_update <- "May 2018"
#^^^^Update the year and quarter to most recent

###############################################
##RUN EVERYTHING BELOW THIS IN ONE
###############################################

make_TRA2501 <- function(save_loc=getwd()){

  raw <- api_get_data()

  #Start by making the contents page
  contents_TRA25("TRA2501", year = year, quarter = quarter,
                 save_to = save_loc, save_over = TRUE,
                 last_updated = last_updated,
                 next_update = next_update)

  footer_text <- c("Other = Two wheeled motor vehicles, buses, and coaches",
                   "Note: Total column may not match sum due to rounding",
                   "(1) Figures affected by September 2000 fuel protest",
                   "(2) 2001 figures affected by the impact of Foot and Mouth disease",
                   "(3) Affected by heavy snowfall",
                   "P Provisional",
                   "Telephone: 020 7944 3095",
                   "Email: roadtraff.stats@dft.gsi.gov.uk",
                   "The figures in this table are National Statistics",
                   "",
                   "Source: DfT National Road Traffic Survey",
                   "Last updated: November 2017",
                   "Next update: May 2018")

  ###TRA2501a####
  new_data <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501a",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "Billion vehicle miles (not seasonally adjusted)",
                  "Rolling annual totals")
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2501a",
         save_to = save_loc,
         start_from_wb = "TRA2501.xlsx",
         save_over = TRUE)

  ###TRA2501b####
  new_data <- raw2new(raw, roll=T, type="vehicle", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501b",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2501b",
         save_to = save_loc,
         start_from_wb = "TRA2501.xlsx",
         save_over = TRUE)


  ####TRA2501c####
  new_data <- raw2new(raw, roll=T, type="vehicle", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501c",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2501c",
         save_to = save_loc,
         start_from_wb = "TRA2501.xlsx",
         save_over = TRUE)

  ####TRA2501d####
  #waiting on seasonal data

  ####TRA2501e####
  new_data <- raw2new(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501e",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")

  #apply the function (look in folder to see output)
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2501e",
         save_to = save_loc,
         start_from_wb = "TRA2501.xlsx",
         save_over = TRUE)


  ####TRA2501f####
  #waiting on seasonal data

  ####TRA2501g####
  #waiting on seasonal data
}

make_TRA2501(save_loc)
