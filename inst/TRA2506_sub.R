########
##Script that outputs TRA2506 as one doc
##Works using a template sheet with formatted headers already in
##CURRENTLY DOESN'T WORK
##22/03/2018 work in progress

#DO NOT RUN ME ON MY OWN - I AM ONLY USEFUL INSIDE "TRA25_run_script.r"
########

make_TRA2506_sub <- function(save_loc=getwd()){

  LStest::check_uptodate(raw, year, quarter)

  #Start by making the contents page
  filename <- contents_TRA25("TRA2506", year = year, quarter = quarter,
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

  ###TRA2506a####
  data_for_xl <- TRA25_arrange_data(raw, roll=T, type="vehicle_and_road", units="traffic", km_or_miles = "km")
  title_text <- c("Department for Transport statistics",
                  "Traffic",
                  "Table TRA2506a",
                  "Car and goods vehicle traffic (vehicle kilometres) by road class in Great Britain, rollong annual totals from 1994",
                  "",
                  "Billion vehicle kilometres (not seasonally adjusted)")


  #####BELOW IS A BASTARDISATION OF TRA25_format_to_xl
  table_name <-  "TRA2506a"
  save_to <-  save_loc
  start_from_file <- filename
  save_over <- TRUE

    #Open the workbook
  if (start_from_file == F){
    wb <- openxlsx::loadWorkbook(system.file("template.xlsx", package="LStest"))
  } else {
    wb <- openxlsx::loadWorkbook(paste0(save_to, "/", start_from_file))
  }

  filename <- LStest:::get_filename(start_from_file, save_over, table_name)


  xltabr::set_style_path(system.file("DfT_styles.xlsx", package = "LStest"))


  #now we use all the subfunctions created as part of the LStest package (behind the scenes)
  tab <- xltabr::initialise(wb = wb, ws_name = table_name)

  #RIPPED add_body_dft AS DON'T WANT TO ADD ALL
  n <- dim(data_for_xl)[2]
  data_for_xl <- cbind(data_for_xl[,1:2], NA, data_for_xl[,3:n])
  n <- n+1 #because we've added a new col

  #add in col for footnotes (eg "P" for provisional)
  data_for_xl <- LStest:::add_footnote_refs(data_for_xl)[[1]]

  #write the column styles - which ones to make bold
  headers <- names(data_for_xl)
  col_style_names <- rep("body", length(headers))
  col_style_names[headers=="year"] <- "body_bold_year" #so year nums formatted as 2013 not 2,013
  col_style_names[headers=="quarter"] <- "body_bold"
  col_style_names[grepl("total",headers)] <- "body_bold" #all totals will be bold


  #Add col headers to tab
  headers <- LStest:::varnames2english(headers)

  if (sum(grepl(".", headers, fixed = T)) > length(headers) / 3){
    #this is an arbitrary if condition of "if more than a third of the headers have the "." character
    #in. The reason being that is the notation I have been using for 2 header levels (e.g. TRA2503)
    headers <- LStest:::add_headers_twovars(headers)

    #tab <- xltabr::add_top_headers(tab, headers
    #                               , row_style_names = c("ch_top", "ch_bottom"))

  } else {
    #tab <- xltabr::add_top_headers(tab, headers
    #                               , col_style_names = "col_headers")
  }

  #Add the data to tab (put it in presentable format)
  data_for_xl[ ,4:n] <- round(data_for_xl[ ,4:n],1)
  #Add data to tab (after making slightly nicer)
  data_for_xl$year <- LStest:::nice_year(data_for_xl$year, data_for_xl$quarter)
  data_for_xl$quarter <- LStest:::nice_quart(data_for_xl$quarter)
  tab <- xltabr::add_body(tab, data_for_xl,
                          col_style_names = col_style_names)
  tab <- LStest:::add_bottom_row_style(tab) #the border along the bottom


  #tab <- LStest:::colrow_width_dft(tab, data_for_xl)
  tab <- xltabr::add_footer(tab,footer_text, footer_style_names = "body")
  tab <- xltabr::auto_merge_footer_cells(tab)
  tab <- xltabr::write_data_and_styles_to_wb(tab) #the order matters here (LS needs extra check)
  tab <- LStest:::add_hyperlink_dft(tab, title_text)

  #Freeze panes (extra thing, should probably be own function)
  tare <- length(tab$title$title_text) + length(tab$top_headers$top_headers_list) + 1
  openxlsx::freezePane(tab$wb, table_name,
                       firstActiveRow = tare,
                       firstActiveCol = 3)

  #write the worksheet
  setwd(save_to) #where the output will be saved. Default is current folder
  if (file.exists(filename)) {
    file.remove(filename)}
  openxlsx::saveWorkbook(tab$wb, filename)

  #print statement to show success, and where it was outputted
  cat("The file: ", filename, "\n", "Has been saved in the following location on your desktop: \n", save_to, "\n")

  if(start_from_file!=FALSE){
    cat("\n NB the file", filename, "has been overwritten \n", "and now has sheet", table_name, "\n ",
        rep("-",50),"\n")
  }

}

make_TRA2506_sub(save_loc)

