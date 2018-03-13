########
##Script that outputs all TRA25 tables
##06/03/2018 work in progress
########

save_loc <- "/Users/Luke/Documents/table_dump/"
#^^^^CHANGE the above line to where in your documents you want to save the file

raw <- api_get_data()

####TRA2503a####
new_data <- raw2new(raw, roll=T, type="vehicle_and_road", units="traffic", km_or_miles = "miles")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2503a",
                "Car and goods vehicle traffic (vehicle miles) by road class in Great Britain, rolling annual totals from 1993",
                "",
                "Billion vehicle miles (not seasonally adjusted)")
footer_text <- c("",
                 "(1) Two wheeled motor vehicles, buses, and coaches",
                 "(2) Total may not match sum due to rounding",
                 "(3) figures affected by September 2000 fuel protest",
                 "The figures in these tables are National Statistics")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2503a",
       save_to = save_loc,
       start_from_wb = "TRA2503.xlsx",
       save_over = TRUE)


###TRA2504a####
new_data <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "km")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2504a",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1993",
                "",
                "Billion vehicle kilometres (not seasonally adjusted)")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2504a",
       save_to = save_loc,
       start_from_wb = "TRA2504.xlsx",
       save_over = TRUE)

####TRA2504c####
new_data <- raw2new(raw, roll=T, type="vehicle", units="percentage")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2504c",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1994",
                "",
                "Percentage change on previous year")

new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2504c",
       save_to = save_loc,
       start_from_wb = "TRA2504.xlsx",
       save_over = TRUE)

####TRA2504e####
new_data <- raw2new(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "km")
#title and footer
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2504e",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, quarterly from 1993",
                "",
                "Billion vehicle kilometres (not seasonally adjusted)")

#apply the function (look in folder to see output)
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2504e",
       save_to = save_loc,
       start_from_wb = "TRA2504.xlsx",
       save_over = TRUE)


####TRA2505b####
new_data <- raw2new(raw, roll=T, type="road", units="index")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2505b",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, rolling annual totals from 1994",
                "",
                "Index numbers (Q4 1994 = 100)")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2505b",
       save_to = save_loc,
       start_from_wb = FALSE)

