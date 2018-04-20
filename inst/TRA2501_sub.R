########
##Script that outputs TRA2501 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2501_sub <- function(save_loc=getwd()){

  LStest::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2501", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)

  footer_text <- c("Other = Two wheeled motor vehicles, buses, and coaches",
                   "Note: Total column may not match sum due to rounding",
                   "[1] Figures affected by September 2000 fuel protest",
                   "[2] 2001 figures affected by the impact of Foot and Mouth disease",
                   "[3] Affected by heavy snowfall",
                   "P Provisional",
                   "Telephone: 020 7944 3095",
                   "Email: roadtraff.stats@dft.gsi.gov.uk",
                   "The figures in this table are National Statistics",
                   "",
                   "Source: DfT National Road Traffic Survey",
                   paste("Last updated:", last_updated),
                   paste("Next update:", next_update))

  ###TRA2501a####
  data_for_xl <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501a",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "Billion vehicle miles (not seasonally adjusted)",
                  "Rolling annual totals")
  new2xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501a",
         save_to = save_loc,
         start_from_wb = filename,
         save_over = TRUE)

  ###TRA2501b####
  data_for_xl <- raw2new(raw, roll=T, type="vehicle", units="index")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501b",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Index numbers (Q4 1994 = 100)")
  new2xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501b",
         save_to = save_loc,
         start_from_wb = filename,
         save_over = TRUE)


  ####TRA2501c####
  data_for_xl <- raw2new(raw, roll=T, type="vehicle", units="percentage")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501c",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                  "",
                  "Percentage change on previous year")

  new2xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501c",
         save_to = save_loc,
         start_from_wb = filename,
         save_over = TRUE)

  ####TRA2501d####
  #waiting on seasonal data

  ####TRA2501e####
  data_for_xl <- raw2new(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "miles")
  #title and footer
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2501e",
                  "Road traffic (vehicle miles) by vehicle type in Great Britain, quarterly from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")

  #apply the function (look in folder to see output)
  new2xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2501e",
         save_to = save_loc,
         start_from_wb = filename,
         save_over = TRUE)


  ####TRA2501f####
  #waiting on seasonal data

  ####TRA2501g####
  #waiting on seasonal data
}

make_TRA2501_sub(save_loc)
