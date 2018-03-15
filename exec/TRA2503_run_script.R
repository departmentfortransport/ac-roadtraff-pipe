########
##Script that outputs TRA2503 as one doc
##15/03/2018 work in progress

##UPDATE LINES 9 and 16-19 THEN RUN WHOLE SCRIPT IN ONE BY PRESSING
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

make_TRA2503 <- function(save_loc=getwd()){

  raw <- api_get_data()

  #Start by making the contents page
  contents_TRA25("TRA2502", year = year, quarter = quarter,
                 save_to = save_loc, save_over = TRUE,
                 last_updated = last_updated,
                 next_update = next_update)


  footer_text <- c("Note: Total column may not match sum due to rounding",
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

  ###TRA2502a####
  new_data <- raw2new(raw, roll=T, type="vehicle_and_road", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503a",
                  "something",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2503a",
         save_to = save_loc,
         start_from_wb = "TRA2502.xlsx",
         save_over = TRUE)
}

make_TRA2503(save_loc)

