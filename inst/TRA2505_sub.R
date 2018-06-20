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
  footer_text <- c(foot1_not_SA, foot2_road, foot3_main, foot4_end)
  footer_text_seasonal <- c(foot1_SA, foot2_road, foot3_main, foot4_end)

  ###TRA2505a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="traffic", km_or_miles = "kilometres")
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
         save_over = TRUE)

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
         save_over = TRUE)


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
         save_over = TRUE)

  ####TRA2505d####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, roll=F, type="road", units="traffic", km_or_miles = "kilometres")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505d",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle kilometres (seasonally adjusted*)")
  
  #apply the function (look in folder to see output)
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2505d",
                     save_to = save_loc,
                     start_from_file = filename,
                     save_over = TRUE)
  

  ####TRA2505e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="road", units="traffic", km_or_miles = "kilometres")
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
         save_over = TRUE)


  ####TRA2505f####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, 
                                    roll=F, 
                                    type="road", 
                                    units="index", 
                                    km_or_miles = "kilometres",
                                    index_from = c(1,2,3,4))
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505f",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, quarterly from 1994",
                  "Seasonally adjusted* index numbers (1994 = 100)",
                  "Seasonally adjusted figures")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2505f",
                     save_to = save_loc,
                     start_from_file = filename,
                     save_over = TRUE)
  
  ####TRA2505g####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, roll=F, type="road", units="percentage", km_or_miles = "kilometres")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2505g",
                  "Road traffic (vehicle kilometres) by road class in Great Britain, quarterly from 1994",
                  "Percentage change on same quarter in previous year (seasonally adjusted* figures)",
                  "Seasonally adjusted figures")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2505g",
                     save_to = save_loc,
                     start_from_file = filename,
                     save_over = TRUE)
}

make_TRA2505_sub(save_loc)
