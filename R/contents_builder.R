#############
##Function for getting the Contents page with right dates on
#############

#' @title contents
#' @description makes the contents page for TRA25 tables. Pulls templates
#' from the package LStest and then adds in the bits that change, which are
#' the year, quarter, last updated, next updated
#' @param table_set the table name
#' @param year of most recent data as an integer
#' @param quarter of most recent data as an integer
#' @param save_to where the xlsx document witll be saved
#' @param save_over TRUE or FALSE - if there is a file with the same name in save_to should it
#' overwrite? Default is FALSE, don't overwrite
#' @param last_updated Character string. When the table set was (will be) published
#' @param next_update Character string. When the table set will be next published
#' @examples
#' save_to <- getwd() #saves to current working directory
#' year <- 2017
#' quarter <- 3
#' last_updated <- "November 2017"
#' next_update <- "May 2018"
#' contents_TRA25("TRA2501", year = year, quarter = quarter,
#'                  save_to = save_to, save_over = FALSE,
#'                  last_updated = last_updated,
#'                  next_update = next_update)
#' #look in working directory to see outputted file
#' #note the object returned by the function is the filename, which is useful if adding sheets
#' @export
contents_TRA25 <- function(table_set, year, quarter, save_to, save_over=F,
                           last_updated="FILL IN", next_update="FILL IN"){
  #Uses the Contents template and adds the right year, quarter to the table

  if (!(table_set %in% c("TRA2501","TRA2502","TRA2503","TRA2504","TRA2505","TRA2506"))){
    stop(paste("the table set", table_set, "does not exist"))
  }

  wb <- openxlsx::loadWorkbook(system.file(paste0(table_set,"_template.xlsx"), package="LStest"))


  #Work out the text for the title of the contents page
  if (quarter==1){
    text <- paste("April", year - 1, "- March", year)
  } else if(quarter==2) {
    text <- paste("July", year - 1, "- June", year)
  } else if(quarter==3) {
  text <- paste("October", year - 1, "- September", year)
  } else if(quarter==4) {
    text <- paste("January", year, "- December", year)
  }
  table_title <- paste("Provisional Road Traffic Estimates, Great Britain:", text)




  #Write title and last updated / next update
  openxlsx::writeData(wb, "Contents", table_title, startCol = 2, startRow = 11)
  openxlsx::writeData(wb, "Contents", last_updated, startCol = 5, startRow = 16)
  openxlsx::writeData(wb, "Contents", next_update, startCol = 5, startRow = 17)



  setwd(save_to) #where the output will be saved. Default is current folder
  filename <- paste0(table_set,".xlsx")

  if (file.exists(filename)) {
    if(save_over){ #we'll remove the file that exists so we can save with identical name
      file.remove(filename)
      cat("\n There was a file",filename,"in", save_to,"already, it has now been overwritten. \n",
          "This is because the parameter save_over was set to TRUE \n")
      } else {
      #add on the date and time of saving to file name so we're not overwriting
      filename <- paste0(table_set, "_", gsub(" ","_",substr(Sys.time(),6,16)),".xlsx")
      #remove the colon as causes errors when saving
      filename <- gsub(":","",filename)
      }
  }

  #Hide the gridlines and add the 2 images (DfT, National Stats)
  openxlsx::showGridLines(wb, "Contents", showGridLines = FALSE)

  ###The commented out lines below are to add the logos to the contents page. This doesn't
  ###need doing anymore due to the template having them, but in theory is still useful if need be
  #unit <- 0.8 #can alter to scale how large you want the images
  # openxlsx::insertImage(wb, "Contents", system.file("DfT_logo.png", package = "LStest"),
  #                       height = 2*unit, width = 2*unit*1.5, startRow = 2,startCol = 2)
  # openxlsx::insertImage(wb, "Contents", system.file("nationalstats_logo.png", package = "LStest"),
  #                       height = unit, width = unit, startRow = 2,startCol = 7)

  #Save the file
  openxlsx::saveWorkbook(wb, filename)
  #print statement to show success, and where it was outputted
  cat("The file: ", filename, "\n",
      "with updated contents page been saved in the following location on your desktop: \n",
      save_to, "\n", rep("-",50),"\n")

  #returns the name of the file so that other sheets know when saving over
  return(filename)
}

#LStest:::contents_TRA25("TRA2502", 2017, 3, save_to = "/Users/Luke/Documents/table_dump/")



