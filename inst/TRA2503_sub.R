########
##Script that outputs TRA2503 as one doc
##13/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2503_sub <- function(save_loc=getwd()){

  LStest::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2503", year = year, quarter = quarter,
                 save_to = save_loc, save_over = FALSE,
                 last_updated = last_updated,
                 next_update = next_update)


  footer_text <- c("Note: Total column may not match sum due to rounding",
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

  ###TRA2503a####
  data_for_xl <- raw2new(raw, roll=T, type="vehicle_and_road", units="traffic", km_or_miles = "miles")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2503a",
                  "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, rollong annual totals from 1994",
                  "",
                  "Billion vehicle miles (not seasonally adjusted)")
  new2xl(data_for_xl,
         title_text,
         footer_text,
         table_name = "TRA2503a",
         save_to = save_loc,
         start_from_wb = filename,
         save_over = TRUE)
}

make_TRA2503_sub(save_loc)

