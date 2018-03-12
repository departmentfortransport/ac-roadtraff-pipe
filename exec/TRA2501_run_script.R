########
##Script that outputs TRA2501 as one doc
##12/03/2018 work in progress
########

save_loc <- "/Users/Luke/Documents/table_dump/"
#^^^^CHANGE the above line to where in your documents you want to save the file

raw <- api_get_data()

footer_text <- c("Other = Two wheeled motor vehicles, buses, and coaches",
                 "Note Total column may not match sum due to rounding",
                 "(3) Figures affected by September 2000 fuel protest",
                 "(4) 2001 figures affected by the impact of Foot and Mouth disease",
                 "(5) Affected by heavy snowfall",
                 "P Provisional",
                 "Telephone: 020 7944 3095",
                 "Email: roadtraff.stats@dft.gsi.gov.uk",
                 "The figures in this table are National Statistics",
                 "",
                 "Source: DfT National Road Traffic Survey",
                 "Last updated: November 2017",
                 "Next update: May 2018")

###TRA2501a####
new_data <- raw2new(raw, roll=T, type="vehicle", units="traffic", km_or_miles = "miles")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2501a",
                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1993",
                "",
                "Billion vehicle miles (not seasonally adjusted)")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2501a",
       save_to = save_loc,
       add_to_wb = "TRA2501.xlsx",
       save_over = TRUE)

###TRA2501b####
new_data <- raw2new(raw, roll=T, type="vehicle", units="percentage")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2501b",
                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1993",
                "",
                "Index numbers (Q3 1995 = 100")
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2501b",
       save_to = save_loc,
       add_to_wb = "TRA2501.xlsx",
       save_over = TRUE)


####TRA2501c####
new_data <- raw2new(raw, roll=T, type="vehicle", units="percentage")
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2501c",
                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
                "",
                "Percentage change on previous year")

new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2501c",
       save_to = save_loc,
       add_to_wb = "TRA2501.xlsx",
       save_over = TRUE)

####TRA2501d####
#waiting on seasonal data

####TRA2501e####
new_data <- raw2new(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "km")
#title and footer
title_text <- c("Department for Transport statistics",
                "Traffic",
                "Table TRA2501e",
                "Road traffic (vehicle kilometres) by vehicle type in Great Britain, quarterly from 1993",
                "",
                "Billion vehicle kilometres (not seasonally adjusted)")

#apply the function (look in folder to see output)
new2xl(new_data,
       title_text,
       footer_text,
       table_name = "TRA2501e",
       save_to = save_loc,
       add_to_wb = "TRA2501.xlsx",
       save_over = TRUE)


####TRA2501f####
#waiting on seasonal data

####TRA2501g####
#waiting on seasonal data

