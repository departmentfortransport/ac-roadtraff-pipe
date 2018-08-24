########
##Script that outputs TRA2502 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2502_sub <- function(save_loc=getwd()){

  TRA25rap::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2502", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)


  #Footer texts (two possibilities for sasonal / not)
  footer_text <- c(foot1_not_SA, foot2_road, foot3_main, foot4_end)
  footer_text_seasonal <- c(foot1_SA, foot2_road, foot3_main, foot4_end)

  ###TRA2502a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502a",
                  "Road traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2502a",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ###TRA2502b####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502b",
                  "Road traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2502b",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2502c####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="road", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502c",
                  "Road traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2502c",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)

  ####TRA2502d####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, roll=F, type="road", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502d",
                  "Road traffic (vehicle miles) by road class in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles (seasonally adjusted*)")
  
  #apply the function (look in folder to see output)
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2502d",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp, save_over=TRUE)
  

  ####TRA2502e####
  data_for_xl <- TRA25_arrange_data(raw, roll=F, type="road", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502e",
                  "Road traffic (vehicle miles) by road class in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")

  #apply the function (look in folder to see output)
  TRA25_format_to_xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2502e",
         save_to = save_loc,
         start_from_file = filename,
         num_dp = num_dp, save_over=TRUE)


  ####TRA2502f####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, 
                                    roll=F, 
                                    type="road", 
                                    units="index", 
                                    km_or_miles = "miles",
                                    index_from = c(1,2,3,4))
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502f",
                  "Road traffic (vehicle miles) by road class in Great Britain, quarterly from 1994",
                  "Seasonally adjusted* index numbers (1994 = 100)",
                  "Seasonally adjusted figures")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2502f",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp, save_over=TRUE)
  
  ####TRA2502g####
  data_for_xl <- TRA25_arrange_data(raw_seasonal, roll=F, type="road", units="percentage", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2502g",
                  "Road traffic (vehicle miles) by road class in Great Britain, quarterly from 1994",
                  "Percentage change on same quarter in previous year (seasonally adjusted* figures)",
                  "Seasonally adjusted figures")
  TRA25_format_to_xl(data_for_xl,
                     title_text,
                     footer_text_seasonal,
                     table_name = "TRA2502g",
                     save_to = save_loc,
                     start_from_file = filename,
                     num_dp = num_dp, save_over=TRUE)
}

make_TRA2502_sub(save_loc)
