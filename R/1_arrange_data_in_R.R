#############
##Functions that go from downloading data to rearranging into right 
##structure for table set TRA25. THis is so that it can be made into Excel tables. 
##
##The only two functions that are not subfunctions in here are:
##TRA25_data_api
##TRA25_arrange_data
##
##ALL other functions are subfunctions of TRA25_arrange_data
#############

####Get data####
#' Downloads data from road traffic API and makes into data frame
#'
#' @param url the API url. Is preset to the original, but can be overwritten (for example, seasonal data)
#' @examples
#' #set up scenario. If statement is to do with the situation when the API URL is not in place,
#' #with the back up (to ensure the example works) using pre-installed data
#' if(RCurl::url.exists("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly"))
#'   {raw <- TRA25_data_api()
#'   } else {load("~/ac-roadtraff-pipe/R/sysdata.rda")} 

#' @export
TRA25_data_api <- function(
  url="https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly"){
  ##Gets the data from Luke V's API webiste and changes it from messy list
  ##to nice data frame

  raw_list <- rjson::fromJSON(file = url)
  raw_list <- raw_list$data
  raw <- raw_list %>%
    purrr::map(
      function(x) {
      x[names(x) %in%
          c("year", "quarter", "road_type", "vehicle_type", "estimate")]
      }
      ) %>%
    purrr::map(dplyr::as_data_frame) %>%
    dplyr::bind_rows()
  return(raw)
}

####quarterly or rolling annual####
#' Ultimately a subfunction of \code{\link{TRA25_arrange_data}}
#'
#' Creates the rolling annual totals from quarterly values
#'
#' @param raw the raw data, from \code{\link{TRA25_data_api}}
#' @param x logical, if TRUE then makes values rolling annual totals. If FALSE
#' then function does nothing (returns raw)
#' @examples
#' #set up scenario. If statement is to do with the situation when the API URL is not in place,
#' #with the back up (to ensure the example works) using pre-installed data
#' if(RCurl::url.exists("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly"))
#'   {raw <- TRA25_data_api()
#'   } else {load("~/ac-roadtraff-pipe/R/sysdata.rda")} 

#' rolling_raw <- TRA25_rolling_annual(raw, TRUE)
#' @export
TRA25_rolling_annual <- function(raw, x){
  #given the API output changes the estimate column into rolling annual, if
  #given a positive input. If not given "TRUE" or "FALSE" returns error.
  #Note: FALSE changes nothing - the data is already in quarterly values!

  if (!is.logical(x)) {
    stop("second input must be TRUE or FALSE - indicating whether you want
         rolling annual figures or not")
  }
  if (!is.data.frame(raw)) {
    stop("first input must be a data frame output from TRA25_data_api")
  }
  if (!identical(names(raw),
                 c("year", "quarter", "road_type", "vehicle_type", "estimate"))){
    stop("first input isn't raw API output as has wrong headings")
  }

  if (x){
    raw$estimate <- stats::ave(raw$estimate, #the colum we're 'ave'raging
                        raw$vehicle_type, raw$road_type, #grouping over these
                        FUN = function(x) { #rolling annual function
                          zoo::rollsumr(x, k=4, fill=NA)})
    raw <- raw[!is.na(raw$estimate),] #removes the NA values at beginning as
    #otherwise they cause trouble later on
  }
  return(raw)
}


####vehicle type or road type####
pivot_raw <- function(raw, type){
  #ONLY USED INSIDE the function TRA25_vehicle_road
  #pivots the raw data up by one column, type being either "road" or "vehicle"

  if (!(type=="road" | type=="vehicle")){
    stop("type must be \"vehicle\", \"road\" in this subfunction - select the one you want as cols")
  }
  type <- paste0(type,"_type") #bit of backwards coding - but important due to variable names

  #sum over variable that's not needed (either vehicle_type or road_type)
  data_for_xl <- raw %>%
    dplyr::group_by_("year", "quarter", type) %>%
    dplyr::summarise(estimate = sum(estimate))
  #Pivots type from being a row tso being a few cols (as is categorical)
  data_for_xl <- reshape2::dcast(data_for_xl,
                              year + quarter ~ get(type),
                              #^^"get" is used here as we want the value of type not "type"
                              value.var = "estimate",
                              fun.aggregate = sum)
  # Add  in a column for the sum ie the totals
  total <- rowSums(data_for_xl[, which(names(data_for_xl) %in%
                                    unique(dplyr::pull(raw,type)))])
  #^^^dirty code - but just selects ones we've pivoted up
  data_for_xl <-  cbind(data_for_xl, total)
  colnames(data_for_xl)[length(data_for_xl)] <- "total"
  return(data_for_xl)
}


#' This is a subfunction of TRA25_arrange_data
#' 
#' Takes the raw data, and pivots it up so that a factor variable column (with n factors)
#' is changed to add in the n columns, with the "estimate" col now populating the values
#' 
#'
#' @param raw the raw data in the same format as the output of \code{\link{TRA25_data_api}}
#' @param type either "road", "vehicle", or "vehicle_and_road"
#' @examples
#' #set up scenario. If statement is to do with the situation when the API URL is not in place,
#' #with the back up (to ensure the example works) using pre-installed data
#' if(RCurl::url.exists("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly"))
#'   {raw <- TRA25_data_api()
#'   } else {load("~/ac-roadtraff-pipe/R/sysdata.rda")} 

#' data_for_xl <- TRA25_vehicle_road(raw, "road")
#' #look at where we've gone from/to
#' tibble::glimpse(raw)
#' tibble::glimpse(data_for_xl)
#' @export
TRA25_vehicle_road <- function(raw, type){
  #Takes the initial data "raw" from function TRA25_rolling_annual
  #Do you want the columns to be vehicle type or road type? Pivots the data to be that way

  if (!(type=="road" | type=="vehicle" | type=="vehicle_and_road")){
    stop("type must be \"vehicle\", \"road\", or \"vehicle_and_road\" - select the one you want as cols")
  }

  if (type == "road" | type == "vehicle"){
    #apply the sub function pivot_raw that changes type from being in one column
    #to being separate rows
    data_for_xl <- pivot_raw(raw, type)
    if (type == "vehicle"){
      data_for_xl <- data_for_xl[c("year", "quarter", "cars", "lgv", "hgv","other","total")]
    } else {#type == "road"
      data_for_xl <- data_for_xl[c("year", "quarter", "MW", "AR", "AU","MR","MU", "total")]}
  } else { #type = "vehicle_and_road"
    #create 3 data sets to be appended to each other
    data_for_xl_C <- raw[raw$vehicle_type == "cars",]
    data_for_xl_C <- pivot_raw(data_for_xl_C, "road")
    names(data_for_xl_C)[3:8] <- paste0(names(data_for_xl_C),".cars")[3:8]

    data_for_xl_H <- raw[raw$vehicle_type == "hgv",]
    data_for_xl_H <- pivot_raw(data_for_xl_H, "road")
    names(data_for_xl_H)[3:8] <- paste0(names(data_for_xl_H),".hgv")[3:8]

    data_for_xl_L <- raw[raw$vehicle_type == "lgv",]
    data_for_xl_L <- pivot_raw(data_for_xl_L, "road")
    names(data_for_xl_L)[3:8] <- paste0(names(data_for_xl_L),".lgv")[3:8]

    data_for_xl <- base::merge(data_for_xl_C, data_for_xl_H, by = c("year", "quarter"))
    data_for_xl <- base::merge(data_for_xl, data_for_xl_L, by = c("year", "quarter"))

    #remove MR.hgv and MU.hgv - done to match the way tables have been made. Totals col still
    #has them though, which is odd in my opinion (could easily derive "minor HGV")
    data_for_xl <- data_for_xl[,-which(names(data_for_xl) %in% c("MU.hgv","MR.hgv"))]
    #re-order for consistency with old (I don't like this as it limits to very specific scenario)
    data_for_xl <- data_for_xl[c("year", "quarter",
                           "MW.cars", "AR.cars", "AU.cars", "MR.cars", "MU.cars" , "total.cars"
                           ,"MW.hgv", "AR.hgv",  "AU.hgv",  "total.hgv"
                           ,"MW.lgv", "AR.lgv",  "AU.lgv",  "MR.lgv",  "MU.lgv", "total.lgv")]
    }

  return(data_for_xl)
}

####Traffic, index numbers, or % change####
#' Ultimately a subfunction of \code{\link{TRA25_arrange_data}}
#'
#' @param data_for_xl the pivotted data, outputted from \code{\link{TRA25_vehicle_road}}
#' @param units either "traffic", "percentage", "index" depending on what values required. 
#' @param index_from which row you want to index the values from. Default is first, if multiple
#' rows are given then index is from their average
#' @export
chosen_units <- function(data_for_xl, units, index_from = NA){
  #Changes the "estimates" column from the initial data to be either percentage change on
  #previous year, indexed from chosen point, or the same values themselves
  
  ##IMPORTANT - the assumption here is that the first 2 cols are Year, Quarter and the rest are data
  
  if (!(units %in% c("traffic", "percentage", "index"))){
    stop("units input must be one of: traffic, percentage, or index")
  }
  
  if (units == "percentage"){

    #percentage change - always 4 quarters apart regardless of whether the data is rolling annual or quarterly :)
    warning("LS fix - bad practice probably (for loop, use of \"ave\" in this bit of code below")
    n <- dim(data_for_xl)[2] #width of the data frame
    for (i in 3:n){
      data_for_xl[,i] <- ave(data_for_xl[,i], #the colum we're 'ave'raging
                          FUN = function(x) {100 * ( x / dplyr::lag(x,4) - 1 )}) #the -1 is to get perc CHANGE
    }
  }
  if (units == "index"){
    n <- dim(data_for_xl)[2] #width of the data frame
    if(is.na(index_from[1])){
      #default to index from first row
      index_vals <- as.numeric(data_for_xl[1,3:n]) 
      #^^^ as.numeric because otherwise in loop we get one number (due to fact is data frame)
    } else {
      temp <- data_for_xl[index_from, 3:n]
      temp <- apply(temp,2,mean) #find the mean of each column
      index_vals <- as.numeric(temp) 
    }
    for (i in 3:n){
      data_for_xl[,i] <- 100 * data_for_xl[,i] / index_vals[i-2] #actually applying the index
    }
  }
  #NOTE - when units="traffic" we don't change anything. Important to make user define that that is the value they want
  return(data_for_xl)
}
####################################################################################################
####Wrapper function####
#' given the API output from \code{\link{TRA25_data_api}}, rearranges into a data frame
#' pivotted to the right structure for making into the Excel document.
#'
#' @param raw data frame outputted from \code{\link{TRA25_data_api}()}
#' @param roll logical. TRUE if rolling annual values desired, FALSE if not
#' @param type character string. Either "road", "vehicle", or "vehicle_and_road"
#'  dependant on which wanted for column headers
#' @param units character string. Either
#'  \itemize{
#'   \item "traffic" - traffic values (vehicle Kms)
#'   \item "percentage" - percentage change from previous year same quarter
#'   \item "index" - indexed values from first quarter in data, with that quarter being 100
#' }
#' @param km_or_miles "km" or "miles" dependant on desired units. Only used if units = "traffic",
#' as otherwise doesn't make a difference.
#' @return pivotted data frame that is ready to be formatted nicely as an Excel (.xlsx) doc 
#' using the function TRA25rap::TRA25_format_to_xl
#' @param index_from integer or vector. Rows from which to index from if chosen_units = "index"
#' @examples
#' #first get the raw data
#' #set up scenario. If statement is to do with the situation when the API URL is not in place,
#' #with the back up (to ensure the example works) using pre-installed data
#' if(RCurl::url.exists("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly"))
#'   {raw <- TRA25_data_api()
#'   } else {load("~/ac-roadtraff-pipe/R/sysdata.rda")} 

#' #Google TRA25 if the naming convention on the left ("TRA25...") doesn't make sense
#' TRA2501a_data_for_xl <- TRA25_arrange_data(raw, roll=TRUE, 
#' type="vehicle", units="traffic", km_or_miles = "miles")
#' #The commented line at the bottom looks at the data frame created - 
#' #note it is the same as sheet TRA2501a (which you can search for online)
#' #View(TRA2501a_data_for_xl) 
#' @export

TRA25_arrange_data <- function(raw, roll=NA, type=NA, units=NA, km_or_miles=NA, index_from = NA){
  ##Wrapper function that rehsapes the data downloaded from the api into the structure desired for the Excel table
  raw <- TRA25_rolling_annual(raw,roll) #quarterly vals or rolling annual

  if(units=="traffic"){
    if(!km_or_miles %in% c("km","miles")){
      stop("When units=\"traffic\" you must specify km_or_miles to be exactly \"km\" or \"miles\"")
    } else {
      if(km_or_miles == "miles"){
        #change the values from km to miles
        raw$estimate <- raw$estimate * 0.621371
      }
    }
  }

  data_for_xl <- TRA25_vehicle_road(raw, type) #road or vehicle

  temp <- data_for_xl[ ,-which(names(data_for_xl) %in% c("year", "quarter"))]
  data_for_xl <- data_for_xl[rowSums(is.na(temp)) != ncol(temp),] #so we don't have empty rows


  data_for_xl <- chosen_units(data_for_xl, units, index_from) #traff, %, or index

  temp <- data_for_xl[ ,-which(names(data_for_xl) %in% c("year", "quarter"))]
  data_for_xl <- data_for_xl[rowSums(is.na(temp)) != ncol(temp),] #so we don't have empty rows
  return(data_for_xl)
}
