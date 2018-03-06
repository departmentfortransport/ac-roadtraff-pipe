########
##Getting TRA2503 (cars/HGV/LGV by road type)
########

raw <- api_get_data()
raw <- LStest:::rolling_annual(raw, TRUE)
new_data <- LStest:::vehicle_road(raw, "vehicle_and_road")

LStest::new2xl(new_data, title_text, footer_text, table_name,
save_to=getwd(), add_to_wb = FALSE, save_over = F)


###Trying to fix the "add_top_headers" function to work for 2 levels
headers_0 <- names(new_data)
headers_1 <- unname(LStest:::varnames2english(headers_0))

tab <- initialise()
tab <- xltabr::add_top_headers(tab, headers
                               , col_style_names = "col_headers")

headers <- add_headers_twovars(headers_1)
tab <- xltabr::add_top_headers(tab, headers
                               , row_style_names = c("col_headers_top", "col_headers_bottom"))
tab <- xltabr::write_data_and_styles_to_wb(tab) #the order matters here (LS needs extra check)
if (file.exists("a.xlsx")) {
  file.remove("a.xlsx")}
openxlsx::saveWorkbook(tab$wb, "a.xlsx")


add_headers_twovars <- function(headers){
  #if the header is in the format c("one.a", "two.a", "three.a", "one.b", "two.b") split into 2 vectors
  #and paste into the excel doc so it prints as:
  #_____________________
  #     a           b
  #one two three one two
  #_____________________

  row_1 <- sapply(strsplit(headers, ".", fixed = T), '[', 2)
  row_2 <- sapply(strsplit(headers, ".", fixed = T), '[', 1)
  row_1 <- LStest:::varnames2english(row_1)
  row_2 <- LStest:::varnames2english(row_2)

  top_headers <- list(row_1, row_2)
  warning("this function is incomplete")
  return(top_headers)
}


