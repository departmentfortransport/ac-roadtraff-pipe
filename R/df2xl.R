#############
##Getting from data in right format for xltabr and outputting the
##desired Excel workbook (one sheet at a time)
#############

####add title####
add_title_dft <- function(tab,title_text){
  #adds the title text, nicely formatted (cells are merged later)
  if(length(title_text)!=6){
    stop("title_text must have 6 elements, consider adding \"\" to make it long enough")
  }
  title_style_names <- c("header",
                         "body",
                         "table_title",
                         "title",
                         "title_units",
                         "title_units")
  #now can add the title to the tab
  tab <- xltabr::add_title(tab, title_text, title_style_names = title_style_names)
  return(tab)
}

####add in the road traff hyperlink####
add_hyperlink_dft <- function(tab, title_text){
  #adds in the hyperlink on row 2 of the sheet.
  #has to be run AFTER xltabr::write_data_and_styles_to_wb

  if (unlist(strsplit(title_text[3]," "))[1] != "Table"){
    stop("the third element of title_text must be \"Table ***\" where *** is the sheet name")}
  sheet_name <- unlist(strsplit(title_text[3]," "))[2] #see above error comment if unsure why

  openxlsx::writeFormula(tab$wb, sheet_name, x =
                 '=HYPERLINK("https://www.gov.uk/government/organisations/department-for-transport/series/road-traffic-statistics",
               "Traffic - www.gov.uk/government/organisations/department-for-transport/series/road-traffic-statistics")',
               startCol=1,startRow=2)
  return(tab)
  }

####add in the body (main data in table)####
varnames2english <- function(headers){
  #given a vector of character strings, returns the same vector in "Full english"

  #change known words (based off headers from API)
  headers[headers=="hgv"] <- "heavy goods vehicles"
  headers[headers=="lgv"] <- "light commercial vehicles"
  headers[headers=="AMV"] <- "all motor vehicles"
  headers[headers=="AR"] <- "rural 'A' roads"
  headers[headers=="AU"] <- "urban 'A' roads"
  headers[headers=="MR"] <- "rural minor roads"
  headers[headers=="MU"] <- "urban minor roads"
  headers[headers=="MW"] <- "motorway"
  headers[headers=="NA"] <- ""
  headers[is.na(headers)] <- ""

  #capitalise first letter
  .simpleCap <- function(x) { #bad to create function inside function. Stollen from ?toupper
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1, 1)), substring(s, 2),
          sep = "", collapse = " ")
  }
  headers <- sapply(headers, .simpleCap)
  return(headers)
}

nice_quart <- function(quart_num){
  #given a quarter number outputs the relevant text
  #(is sub-function of add_body_dft)
  if (!is.vector(quart_num)){stop("input needs to be a vector")}

  quart_num[quart_num == 1] <- "Q1: Jan-Mar"
  quart_num[quart_num == 2] <- "Q2: Apr-Jun"
  quart_num[quart_num == 3] <- "Q3: Jul-Sep"
  quart_num[quart_num == 4] <- "Q4: Oct-Dec"
  return(quart_num)
}
nice_year <- function(year_vec, quarter_vec){
  #given a year with repetitions due to quarters, outputs the nicer format (only
  #having a value when Q1)
  #(is sub-function of add_body_dft)
  temp <- year_vec[1]
  year_vec[quarter_vec != 1] <- NA
  year_vec[1] <- temp #always want first value to have year next to it
  return(year_vec)
}
add_bottom_row_style <- function(tab, stylename="heavy_bottom_border") {
  #LS function based off "add_style_to_rows"
  #stylename is applied to final rows
  #(is sub-function of add_body_dft)

  my_filter <- nrow(tab$body$body_df) + 1

  tab$body$body_df[my_filter, "meta_row_"] <- paste(tab$body$body_df[my_filter, "meta_row_"], stylename, sep = "|")
  tab$body$body_df[my_filter, "meta_left_header_row_"] <- paste(tab$body$body_df[my_filter, "meta_left_header_row_"], stylename, sep = "|")

  return(tab)
}

add_body_dft <- function(tab, new_data){
  #adds in the main data and it's col headers to tab

  ###LS - maybe this should be part of "raw2df"?
  n <- dim(new_data)[2]
  new_data <- cbind(new_data[,1:2], NA, new_data[,3:n]) #add in col for footnotes (eg "P" for provisional)
  n <- n + 1 #we've added a new col in
  ###LS - maybe this should be part of "raw2df"?

  #Add col headers to tab
  headers <- varnames2english(names(new_data))
  tab <- xltabr::add_top_headers(tab, headers
                         , col_style_names = "col_headers")


  #Add the data to tab (put it in presentable format)
  new_data[ ,4:n] <- round(new_data[ ,4:n],1)
  #Add data to tab (after making slightly nicer)
  new_data$year <- nice_year(new_data$year, new_data$quarter)
  new_data$quarter <- nice_quart(new_data$quarter)
  tab <- xltabr::add_body(tab, new_data,
                  col_style_names = c("body_bold_year", #where numbers are 2013 not 2,013.0s
                                      "body_bold",
                                      rep("body",n-3),
                                      "body_bold"))
  tab <- add_bottom_row_style(tab) #the border along the bottom
  return(tab)
}
####col and row widths / merging ####
colrow_width_dft <- function(tab, new_data){
  #1) adjusts col width specifications
  #2) adjusts row height specifications (non NA "Year" rows are slightly bigger)
  #3) merges title cells where needed

  ##1) col widths
  n <- dim(new_data)[2]
  tab <- xltabr::set_wb_widths(tab, body_header_col_widths = c(6, 12, 3, rep(14,n-2)))

  ##2) row height
  ws_name <- tab$misc$ws_name
  #tare is the point at which the data ("body" in xltabr language) starts
  tare <- length(tab$title$title_text) + 1 #plus one for top headers (col names)
  year_rows <- which(new_data$quarter==1) #first quarter has year attached
  if (!(1 %in% year_rows)){year_rows <- append(1,year_rows)} #first row needs year
  year_rows <- year_rows + tare #to make it the actual index in the ws
  #now to change the row heights
  openxlsx::setRowHeights(tab$wb, sheet = ws_name, rows=year_rows,
                         heights=25)

  ##3) cell merge
  #bastardising "auto_merge_title_cells" to not merge the first row
  cols <- xltabr:::body_get_wb_cols(tab)
  rows <- xltabr:::title_get_wb_rows(tab)
  rows <- rows[rows != 1] #everything but the first row as per AH request
  for (r in rows) {
    openxlsx::mergeCells(tab$wb, ws_name, cols, r)
  }
  openxlsx::mergeCells(tab$wb, ws_name, cols = 1:4, rows = 1)
  return(tab)
}

####Go from the data frame "new_data" to Excel doc####
#' @title new2xl
#' @description takes a data frame with title and footer text and outputs a beautiful Excel table.
#' Made with xltabr as main base.
#' @param new_data data frame outputted from \code{\link{raw2df}}
#' @param title_text vector of strings, if not length 6 has warning (see Examples below for correct notation)
#' @param footer_text vector of strings, can be any length
#' @param table_name string eg "TRA2504e"
#' @param save_to where the xlsx document will be saved. Default is current folder.
#' @param add_to_wb Give name of workbook the sheet will be added on to. If left blank, new workbook
#' will be created
#' @param save_over TRUE or FALSE. Should the output file replace the file of "add_to_wb" or
#' be saved as a new file? TRUE = replace the file
#' @examples
#' #set up scenario
#' raw <- api_new_data()
#' new_data <- raw2new(raw, roll=F, type="vehicle", units="traffic")
#' #title and footer
#' title_text <- c("Department for Transport statistics",
#'                "Traffic",
#'                "Table TRA2504e",
#'               "Road traffic (vehicle kilometres) by vehicle type in Great Britain, quarterly from 1993",
#'               "",
#'               "Billion vehicle kilometres (not seasonally adjusted)")
#' footer_text <- footer_text <- c("",
#'               "(1) Two wheeled motor vehicles, buses, and coaches",
#'               "(2) Total may not match sum due to rounding",
#'               "(3) figures affected by September 2000 fuel protest",
#'               "The figures in these tables are National Statistics")
#'
#'
#' #apply the function (look in folder to see output)
#' new2xl(new_data,
#'        title_text,
#'        footer_text,
#'        table_name = "TRA2504e",
#'        save_to = "/Users/Luke/Documents/xltabr_TRA2504e/sheet_builder_test",
#'        add_to_wb = "builder.xlsx",
#'        save_over = F)
#' @export
new2xl <- function(new_data, title_text, footer_text, table_name,
                   save_to=getwd(), add_to_wb = FALSE, save_over = F){
  #makes Excel doc from new_data, just needs title and footers

  if (add_to_wb == F){
    wb <- openxlsx::loadWorkbook("/Users/Luke/Downloads/template.xlsx")
    #write what it's going to be saved as
    filename <- paste0("new2xl",gsub(" ","_",substr(Sys.time(),6,16)),".xlsx")
    filename <- gsub(":","",filename)
    if (save_over){stop("can't save over file when not given workbook to add to
                        (see \"save_over\" and \"add_to_wb\" definitions in help)")}
  } else {
    wb <- openxlsx::loadWorkbook(paste0(save_to, "/", add_to_wb))
    filename <- paste(add_to_wb,gsub(" ","_",substr(Sys.time(),6,16)))
    if (save_over){
      filename <- add_to_wb}
  }
  xltabr::set_style_path("/Users/Luke/Downloads/LS_styles_pub.xlsx")
  setwd(save_to) #where the output will be saved. Default is current folder

  #now we use all the subfunctions created as part of the LStest package (behind the scense)
  tab <- xltabr::initialise(wb = wb, ws_name = table_name)
  tab <- add_title_dft(tab, title_text)
  tab <- add_body_dft(tab, new_data)
  tab <- colrow_width_dft(tab, new_data)
  tab <- xltabr::add_footer(tab,footer_text, footer_style_names = "body")
  tab <- xltabr::auto_merge_footer_cells(tab)
  tab <- xltabr::write_data_and_styles_to_wb(tab) #the order matters here (LS needs extra check)
  tab <- add_hyperlink_dft(tab, title_text)

  #write the worksheet
  if (file.exists(filename)) {
    file.remove(filename)}
  openxlsx::saveWorkbook(tab$wb, filename)
}
