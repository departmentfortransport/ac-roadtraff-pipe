########
##Script that outputs TRA2501 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2501_sub <- function(save_loc=getwd()){

  TRA25rap::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2501", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)

  #Footer texts (two possibilities for sasonal / not)
  footer_text <- c(foot1, foot2_main, foot3_vehicle, foot4_end)

  ###TRA2501a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501a",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "Billion vehicle miles",
                  "Rolling annual totals")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501a",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ###TRA2501b####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501b",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501b",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2501c####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501c",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501c",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ####TRA2501d####
  #redacted when seasonal data removed Q2 2018
  
  ####TRA2501e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501e",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501e",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2501f####
  #redacted when seasonal data removed Q2 2018
  
  ####TRA2501g####
  #redacted when seasonal data removed Q2 2018
  
}

make_TRA2501_sub(save_loc)
