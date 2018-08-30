#############
##Getting from data in right format for xltabr and outputting the
##desired Excel workbook (one sheet at a time)
#############

####add title####
#' Adds the title to the tab. title_text must be of the same format as TRA25 tables
#'
#' @param tab the core tab object
#' @param title_text vector string with 6 elements 
#' @examples
#'tab <- xltabr::initialise()
#'title_text <- c("Department for Transport statistics",
#'                "Traffic",
#'                "Table TRA2501a",
#'                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
#'                "Billion vehicle miles (not seasonally adjusted)",
#'                "Rolling annual totals")
#'#setting the DfT style path - defines font size, colour, etc.
#'xltabr::set_style_path(system.file("DfT_styles.xlsx", package = "TRA25rap"))
#'
#'tab <- add_title_dft(tab, title_text)
#'
#'#important xltabr function below - basically cements the formatting changes you defined
#'tab <- xltabr::write_data_and_styles_to_wb(tab)
#'#to see the result:
#'openxlsx::openXL(tab$wb)
#' @export
add_title_dft <- function(tab,title_text){
  #adds the title text, nicely formatted (cells are merged later)
  if(length(title_text)!=6){
    stop("title_text must hafve 6 elements, consider adding \"\" to make it long enough")
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
#' Adds a hyperlink to the second row of the sheet. Checks that is of TRA25 format
#' but can easily be altered not to. Based off openxlsx::writeFormula
#'
#' @param tab the core tab object
#' @param title_text vector string with 6 elements 
#' @examples
#'tab <- xltabr::initialise()
#'title_text <- c("Department for Transport statistics",
#'                "Traffic",
#'                "Table TRA2501a",
#'                "Road traffic (vehicle miles) by vehicle type in Great Britain, rolling annual totals from 1994",
#'                "Billion vehicle miles (not seasonally adjusted)",
#'                "Rolling annual totals")
#'#setting the DfT style path - defines font size, colour, etc.
#'xltabr::set_style_path(system.file("DfT_styles.xlsx", package = "TRA25rap"))

#'tab <- add_title_dft(tab, title_text)
#'important that following line is run BEFORE add_hyperlink_dft
#'tab <- xltabr::write_data_and_styles_to_wb(tab)
#'
#'tab <- add_hyperlink_dft(tab, title_text)
#'
#'#to see the result:
#'openxlsx::openXL(tab$wb)
#' @export
add_hyperlink_dft <- function(tab, title_text){
  #adds in the hyperlink on row 2 of the sheet.
  #NOTE: has to be run AFTER xltabr::write_data_and_styles_to_wb

  if (unlist(strsplit(title_text[3]," "))[1] != "Table"){
    stop("the third element of title_text must be \"Table ***\" where *** is the sheet name")}
  sheet_name <- unlist(strsplit(title_text[3]," "))[2] #see above error comment if unsure why

  openxlsx::writeFormula(tab$wb, sheet_name, x =
                           '=HYPERLINK("https://www.gov.uk/government/organisations/department-for-transport/series/road-traffic-statistics",
                         "Traffic - www.gov.uk/government/organisations/department-for-transport/series/road-traffic-statistics")',
                         startCol=1,startRow=2)
  return(tab)
}

TRA25_any_totals <- function(headers){
  #BADLY WRITTEN FUNCTION
  #subfunction of "varnames2english" that deals with occurances of "total".
  #Very limited to current TRA25 options


  if(length(grep("total",headers)) != 0){
    #^^was the word "total" anywhere within here? Even if inside a string eg "hgv.total"
    t <- match("total", headers) #place where "total" occurs. NA if doesn't
    if(!is.na(t)){
      #"total" occurs on its own
      if (setequal(headers[-t], c("year","quarter","NA","AR","AU","MR","MU","MW"))){
        headers[t] <- "all roads"
      } else if (identical(headers[-t], c("year","quarter","NA","cars","lgv","hgv","other"))){
        headers[t] <- "all motor vehicles"
      }
    } else {
      #now case where "total" was in some character string but never on it's own
      t1 <- grep("total",headers)
      if (setequal(gsub("total.","",headers[t1]),c("cars","hgv","lgv"))){
        headers[t1] <- "all roads"
      } else { warning(cat("total column is not in format seen before - this ",
                           "is a problem and your column headers may be wrong"))}
    }
  }
  return(headers)
}

####add in the body (main data in table)####
varnames2english <- function(headers){
  #given a vector of character strings, returns the same vector in "Full english"

  #First have to deal with "total" columns
  headers <- TRA25_any_totals(headers)

  #change known words (based off headers from API)
  headers[headers=="hgv"] <- "heavy goods vehicles"
  headers[headers=="lgv"] <- "light commercial vehicles"
  headers[headers=="AR"] <- "rural 'A' roads"
  headers[headers=="AU"] <- "urban 'A' roads"
  headers[headers=="MR"] <- "minor rural roads"
  headers[headers=="MU"] <- "minor urban roads"
  headers[headers=="MW"] <- "motorway"
  headers[headers=="NA"] <- ""
  headers[is.na(headers)] <- ""

  #capitalise first letter
  .simpleCap <- function(x) { #bad to create function inside function. Stollen from ?toupper
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1, 1)), substring(s, 2),
          sep = "", collapse = " ")}

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
  tab$body$body_df[my_filter, "meta_left_header_row_"] <-
    paste(tab$body$body_df[my_filter, "meta_left_header_row_"], stylename, sep = "|")

  return(tab)
}

add_headers_twovars <- function(headers){
  #if the header is in the format c("one.a", "two.a", "three.a", "one.b", "two.b") split into 2 vectors
  #and paste into the excel doc so it prints as:
  #_____________________
  #     a           b
  #one two three one two
  #_____________________
  #(is a subfunction of add_body_dft)

  row_1 <- sapply(strsplit(headers, ".", fixed = T), '[', 2)
  row_2 <- sapply(strsplit(headers, ".", fixed = T), '[', 1)
  row_1 <- unname(TRA25rap:::varnames2english(row_1))
  row_2 <- unname(TRA25rap:::varnames2english(row_2))

  #replace ("a", "a", "a", "a", "b", "b", "b") with ("a","","","","b","","")
  for (temp in unique(row_1)){
    first_appearance <- which(row_1 == temp)[1]
    row_1[row_1 == temp] <- ""
    row_1[first_appearance] <- temp
  }

  top_headers <- list(row_1, row_2)
  warning("this function is incomplete")
  return(top_headers)
}

add_footnote_refs <- function(data_for_xl){
  #Adds in the footnote notations to the third col.
  #Returns 2 objects in a list, the first being data_for_xl with updated third col
  #and the second being a named list of footnote linking to reference
  #(subfunction of add_body_dft)
  d <- data_for_xl #just for simplicity (easier to read)

  #2000 fuel protest
  d[d$year == 1999 & d$quarter == 3, 3] <- "[1]"

  #2001 foot and mouth
  d[d$year == 2001, 3] <- "[2]"

  #heavy snowfall
  d[d$year == 2009 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2010 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2010 & d$quarter == 4, 3] <- "[3]"
  d[d$year == 2013 & d$quarter == 1, 3] <- "[3]"
  d[d$year == 2018 & d$quarter == 1, 3] <- "[3]"
  
  #provisional estimates. The complicated line is just ensuring the "P" doesn't overwrite a previous
  #footnote in that cell
  d[d$year == tail(d$year,1), 3] <- sapply(d[d$year == tail(d$year,1), 3], function(x) paste(x, "P"))
  #LS: provisional are currently defined by if most recent year. Maybe not true?

  footnote_refs <- unique(d[,3])

  return(list(d, footnote_refs))
}

#' Adds the body (main data) to the tab. Relies on many TRA25rap subfunctions. 
#' Not advisable to use outside of TRA25 table compilation - but useful as 
#' a spring board for creating bespoke functions
#'
#' @param tab the core tab object
#' @param data_for_xl output from TRA25_arrange_data
#' @param num_dp number of decimal places for the output. Default is 1, 
#' which is what published tables are
#' #' @export
add_body_dft <- function(tab, data_for_xl, num_dp = 1){
  #adds in the main data and it's col headers to tab
  
  #add in a blank third column - for footnote references
  n <- dim(data_for_xl)[2]
  data_for_xl <- cbind(data_for_xl[,1:2], NA, data_for_xl[,3:n])
  n <- n+1 #because we've added a new col

  #add in footnote references to third column (eg "P" for provisional)
  data_for_xl <- add_footnote_refs(data_for_xl)[[1]]

  #write the column styles - which ones to make bold
  headers <- names(data_for_xl)
  col_style_names <- rep("body", length(headers))
  col_style_names[headers=="year"] <- "body_bold_year" #so year nums formatted as 2013 not 2,013
  col_style_names[headers=="quarter"] <- "body_bold"
  col_style_names[grepl("total",headers)] <- "body_bold" #all totals will be bold


  #Add col headers to tab
  headers <- varnames2english(headers)
  if (sum(grepl(".", headers, fixed = T)) > length(headers) / 3){
    #this is an arbitrary if condition of "if more than a third of the headers have the "." character
    #in. The reason being that is the notation I have been using for 2 header levels (e.g. TRA2503)
    headers <- add_headers_twovars(headers)

    tab <- xltabr::add_top_headers(tab, headers
                                   , row_style_names = c("ch_top", "ch_bottom"))

  } else {
    tab <- xltabr::add_top_headers(tab, headers
                                   , col_style_names = "col_headers")
  }

  #Round data to (default) 1 decimal place (important to do after any manipulation has happened)
  data_for_xl[ ,4:n] <- round(data_for_xl[ ,4:n],num_dp)
  
  #Add data to tab (after making slightly nicer)
  data_for_xl$year <- nice_year(data_for_xl$year, data_for_xl$quarter)
  data_for_xl$quarter <- nice_quart(data_for_xl$quarter)
  tab <- xltabr::add_body(tab, data_for_xl,
                          col_style_names = col_style_names)
  tab <- add_bottom_row_style(tab) #the border along the bottom
  return(tab)
}

####col and row widths / merging ####
colrow_width_dft <- function(tab, data_for_xl){
  #Adjusts the column widths and row heights to specific values. If 
  #you want to change these vals - lift the code from this function
  
  #1) adjusts col width specifications
  #2) adjusts row height specifications (non NA "Year" rows are slightly bigger)
  #3) merges title cells where needed

  
  ##1) col widths
  n <- dim(data_for_xl)[2]
  tab <- xltabr::set_wb_widths(tab, body_header_col_widths = c(6, 12, 6, rep(14,n-2)))
  #A comment about the above line:
  #   n+1 rows are defined where data_for_xl only has n, but this is because in 'tab' we 
  #have added in a col for footnote references in col3

  ##2) row height
  ws_name <- tab$misc$ws_name
  #tare is the point at which the data ("body" in xltabr language) starts
  tare <- length(tab$title$title_text) + length(tab$top_headers$top_headers_list)

  year_rows <- which(data_for_xl$quarter==1) #first quarter has year attached
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

#' Decides the name of your .xlsx file, simplest case is just use the table name.
#'
#' @param start_from_file the name of the .xlsx file that we're going to add a sheet to
#' @param save_over logical, if TRUE then overwrite the original file
#' @param table_name string, eg "TRA2501" 
#' @export
get_filename <- function(start_from_file, save_over, table_name){
  #decides on the name of the file based off the following:

  #start_from_file given?     save_over the file?   filename is
  #--------------------     -------------------   -----------
  #       No                      No              table_name_date_time.xlsx
  #       No                      Yes             ERROR
  #       Yes                     No              start_from_file_date_time.xlsx
  #       Yes                     Yes             start_from_file.xlsx
  if(start_from_file != FALSE){
    n <- nchar(start_from_file)
    if (substr(start_from_file, n-4, n) != ".xlsx"){
      stop(cat("the workbook you're starting from is not a .xlsx file. Make sure it ends \".xlsx\". \n",
               "If it is a different type it is safest to resave as a .xlsx"))
    }
    start_from_file <- substr(start_from_file, 1, n-5) #take off the .xlsx part
  }
  #Now can do the main part of the function
  if (start_from_file == F){
    #filename will just be the table_name with date_time attached
    filename <- paste0(table_name,"_",gsub(" ","_",substr(Sys.time(),6,16)),".xlsx")
    filename <- gsub(":","",filename)
    if (save_over){stop("can't save over file when not given workbook to add to
                        (see \"save_over\" and \"start_from_file\" definitions in help)")}
  } else {
    if (save_over){
      filename <- paste0(start_from_file, ".xlsx")
    } else {
      filename <- paste0(start_from_file, "_", gsub(" ","_",substr(Sys.time(),6,16)),".xlsx")
      filename <- gsub(":","",filename)}}
  return(filename)
}


TRA2503_header_merge <- function(tab, table_name){
  #simple function that merges the cells in the right places for the scenario of TRA2503 sheets

  ws_name <- table_name
  if (substr(table_name,1,7) %in% c("TRA2503","TRA2506")){
    row <- 7
    openxlsx::mergeCells(tab$wb, ws_name, 4:9, row)
    openxlsx::mergeCells(tab$wb, ws_name, 10:13, row)
    openxlsx::mergeCells(tab$wb, ws_name, 14:19, row)
    openxlsx::mergeCells(tab$wb, ws_name, 1:2, row)
    }
  return(tab)
}

####Go from the data frame "data_for_xl" to Excel doc####
#' @title TRA25_format_to_xl
#' @description takes a data frame with title and footer text and outputs a beautiful Excel table.
#' Made with xltabr as main base.
#' @param data_for_xl data frame outputted from \code{\link{TRA25_arrange_data}}
#' @param title_text vector of strings, if not length 6 has error (see Examples below for correct notation)
#' @param footer_text vector of strings, can be any length
#' @param table_name string eg "TRA2504e"
#' @param save_to where the xlsx document will be saved. Default is current folder.
#' @param start_from_file Give name of workbook the sheet will be added on to. If left blank, new workbook
#' will be created
#' @param save_over TRUE or FALSE. Should the output file replace the file of "start_from_file" or
#' be saved as a new file? TRUE = replace the file. FALSE = will save with time stamp as part of name 
#' @param num_dp number of decimal places for output. 1 is the default (and what is published)
#' @examples
#' \dontrun{
#' #set up scenario
#' raw <- TRA25_data_api()
#' data_for_xl <- TRA25_arrange_data(raw, roll=F, type="vehicle", units="traffic", km_or_miles = "km")
#' #title and footer
#' title_text <- c("Department for Transport statistics",
#'                "Traffic",
#'                "Table TRA2504e",
#'               "Road traffic (vehicle kilometres) by vehicle type in Great Britain, quarterly from 1993",
#'               "",
#'               "Billion vehicle kilometres (not seasonally adjusted)")
#' footer_text <- footer_text <- c("",
#'               "[1] Two wheeled motor vehicles, buses, and coaches",
#'               "[2] Total may not match sum due to rounding",
#'               "[3] figures affected by September 2000 fuel protest",
#'               "The figures in these tables are National Statistics")
#'
#' #This code below currently causes an error due to the location of start_from_file being 
#' #different to save_to. Is a bug that needs fixing! Has been flagged as an issue on GitHub
#' #as "location of files"
#' TRA25_format_to_xl(data_for_xl,
#'        title_text,
#'        footer_text,
#'        table_name = "TRA2504e",
#'        save_to = getwd(),
#'        start_from_file = system.file("template.xlsx", package="TRA25rap"),
#'        save_over = F)
#'        }
#' @export
TRA25_format_to_xl <- function(data_for_xl, title_text, footer_text, table_name,
                   save_to=getwd(), start_from_file = FALSE, save_over = F,num_dp = 1){
  #makes nicely formatted Excel doc from data_for_xl

  #Open the workbook
  if (start_from_file == F){
    wb <- openxlsx::loadWorkbook(system.file("template.xlsx", package="TRA25rap"))
  } else {
    wb <- openxlsx::loadWorkbook(paste0(save_to, "/", start_from_file))
  }

  filename <- TRA25rap:::get_filename(start_from_file, save_over, table_name)


  if ( (start_from_file != F) #we have a starting point
       & (save_over = T) #we are overwriting this wb
       & (table_name %in% wb$sheet_names) #there is already a sheet with the name we want
  ){
    warning(paste("there was already a sheet named",table_name,"which has now been overwritten"))
    openxlsx::removeWorksheet(wb,table_name)}


  xltabr::set_style_path(system.file("DfT_styles.xlsx", package = "TRA25rap"))


  #now we use all the subfunctions created as part of the TRA25rap package (behind the scenes)
  tab <- xltabr::initialise(wb = wb, ws_name = table_name)
  tab <- TRA25rap:::add_title_dft(tab, title_text)
  tab <- TRA25rap:::add_body_dft(tab, data_for_xl, num_dp)
  tab <- TRA25rap:::colrow_width_dft(tab, data_for_xl)
  tab <- xltabr::add_footer(tab,footer_text, footer_style_names = "body")
  tab <- xltabr::auto_merge_footer_cells(tab)
  tab <- xltabr::write_data_and_styles_to_wb(tab) #the order matters here (LS needs extra check)
  tab <- TRA25rap:::add_hyperlink_dft(tab, title_text)

  #Freeze panes (extra thing, should probably be own function)
  tare <- length(tab$title$title_text) + length(tab$top_headers$top_headers_list) + 1
  openxlsx::freezePane(tab$wb, table_name,
                       firstActiveRow = tare,
                       firstActiveCol = 3)
  #Cheap solution to cell merge problem with TRA2503 - bespoke function for it
  tab <- TRA2503_header_merge(tab, table_name)

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


