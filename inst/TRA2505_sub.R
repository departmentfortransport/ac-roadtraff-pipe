########
##Script that outputs TRA2505 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2505_sub <- function(save_loc=getwd()){

  TRA25rap::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2505", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)


  #Footer texts (two possibilities for sasonal / not)
  footer_text <- c(foot1, foot2_main, foot3_road, foot4_end)

  ###TRA2505a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="traffic", km_or_miles = "km")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505a",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Billion vehicle kilometres (not seasonally adjusted)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2505a",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp,
         specific_cells = specific_cells,
         save_over=TRUE)
  
  ###TRA2505b####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505b",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2505b",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp,
         specific_cells = specific_cells,
         save_over=TRUE)
  

  ####TRA2505c####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505c",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2505c",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp,
         specific_cells = specific_cells,
         save_over=TRUE)
  
  ####TRA2505d####
  #redacted when seasonal data removed Q2 2018

  ####TRA2505e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="road", units="traffic", km_or_miles = "km")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505e",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle kilometres (not seasonally adjusted)")

  #apply the function (look in folder to see output)
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2505e",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp,
         specific_cells = specific_cells,
         save_over=TRUE)
  

  ####TRA2505f####
  #redacted when seasonal data removed Q2 2018

  ####TRA2505g####
  #redacted when seasonal data removed Q2 2018
}

make_TRA2505_sub(save_loc)
