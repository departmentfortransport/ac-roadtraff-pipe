########
##Script that outputs TRA2503 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2503_sub <- function(save_loc=getwd()){

  TRA25rap::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2503", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)

  #Footer texts (two possibilities for sasonal / not)
  footer_text <- c(foot1, foot2_main, foot3_vehicle_road, foot4_end)
  
  #specific_cells for dashed line example (commented out as not used currently)
  #specific_cells <- list(year = 2017, quarter = 4, style_name = "body_topline_dashed")
  specific_cells <- F
  
  ###TRA2503a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle_and_road", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503a",
                  "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "Billion vehicle miles",
                  "Rolling annual totals")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2503a",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp,
         specific_cells = specific_cells,
         save_over=TRUE)
  
  ###TRA2503b####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle_and_road", units="index", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503b",
                  "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text,
                     table_name = "TRA2503b",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp,
                     specific_cells = specific_cells,
                     save_over=TRUE)
  
  ###TRA2503c####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle_and_road", units="percentage", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503c",
                  "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text,
                     table_name = "TRA2503c",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp,
                     specific_cells = specific_cells,
                     save_over=TRUE)
  
  ####TRA2503d####
  #redacted when seasonal data removed Q2 2018

  ####TRA2503e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="vehicle_and_road", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503e",
                  "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles")

  #apply the function (look in folder to see output)
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text,
                     table_name = "TRA2503e",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp,
                     specific_cells = specific_cells,
                     save_over=TRUE)
  
  ####TRA2503f####
  #redacted when seasonal data removed Q2 2018

  ####TRA2503g####
  #redacted when seasonal data removed Q2 2018
  
}

make_TRA2503_sub(save_loc)