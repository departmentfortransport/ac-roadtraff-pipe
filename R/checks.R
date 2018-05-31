########
##Place for checking functions that don't fit as unit tests
########

#' @title check_uptodate
#' @description checks that the incoming data's most recent info matches what the user
#' thinks it is
#' @param raw output from \code{\link{TRA25_data_api}}
#' @param year integer - year of most recent data
#' @param quarter integer - quarter of most recent data
#' @examples
#' mini_raw <- readRDS(system.file("data","mini_raw.rds", package = "TRA25rap"))
#' # can see if look at mini_raw that goes to 1995 Q4

#' check_uptodate(mini_raw,1995,4) #no error
#' \dontrun{
#' check_uptodate(mini_raw,1995,2) #error}
#' @export
check_uptodate <- function(raw, year, quarter){
  y <- tail(raw$year,1)
  q <- tail(raw$quarter,1)
  if (y == year & q == quarter){
    return()
  } else {
    stop(paste0("The API data downloaded doesn't match year = ", year,
               "quarter = ", quarter,"\n to see the bottom of the data table run tail(raw) \n"))
  }
}


