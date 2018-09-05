########
##Script that outputs TRA2504 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2504_sub <- function(save_loc=getwd()){

  TRA25rap::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2504", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)

  #Footer texts (two possibilities for sasonal / not)
  footer_text <- c(foot1, foot2_main, foot3_vehicle, foot4_end)

  ###TRA2504a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "km")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2504a",
                  "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "Billion vehicle kilometres (not seasonally adjusted)",
                  "Rolling annual totals")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2504a",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ###TRA2504b####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2504b",
                  "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2504b",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2504c####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2504c",
                  "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2504c",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ####TRA2504d####
  #redacted when seasonal data removed Q2 2018

  ####TRA2504e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "km")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2504e",
                  "Road traffic (vehicle kilometres) by vehicle type in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle kilometres (not seasonally adjusted)")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2504e",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2504f####
  #redacted when seasonal data removed Q2 2018

  ####TRA2504g####
  #redacted when seasonal data removed Q2 2018
}

make_TRA2504_sub(save_loc)
