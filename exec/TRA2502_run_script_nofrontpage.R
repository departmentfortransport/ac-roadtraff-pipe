########
##Script that outputs TRA2502 as one doc
##13/03/2018 work in progress

##CHANGE LINE 9 TO YOUR DESIRED FOLDER THEN RUN ALL IN ONE GO BY PRESSING
##"CTRL+ A" then "CTRL + R"
########

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

###############################################
##RUN EVERYTHING BELOW THIS IN ONE
###############################################

make_TRA2502 <- function(save_loc=getwd()){

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
  new_data <- raw2new(raw, roll=T, type="road", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502a",
                  "Road traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2502a",
         save_to = save_loc,
         start_from_wb = "TRA2502.xlsx",
         save_over = TRUE)

  ###TRA2502b####
  new_data <- raw2new(raw, roll=T, type="road", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502b",
                  "Road traffic (vehicle miles) by road type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2502b",
         save_to = save_loc,
         start_from_wb = "TRA2502.xlsx",
         save_over = TRUE)


  ####TRA2502c####
  new_data <- raw2new(raw, roll=T, type="road", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502c",
                  "Road traffic (vehicle miles) by road type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2502c",
         save_to = save_loc,
         start_from_wb = "TRA2502.xlsx",
         save_over = TRUE)

  ####TRA2502d####
  #waiting on seasonal data

  ####TRA2502e####
  new_data <- raw2new(raw, roll=F, type="road", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502e",
                  "Road traffic (vehicle miles) by road type in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")

  #apply the function (look in folder to see output)
  new2xl(new_data,
         title_text,
         footer_text,
         table_name = "TRA2502e",
         save_to = save_loc,
         start_from_wb = "TRA2502.xlsx",
         save_over = TRUE)


  ####TRA2502f####
  #waiting on seasonal data

  ####TRA2502g####
  #waiting on seasonal data
}

make_TRA2502(save_loc)
