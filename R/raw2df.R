#############
##Getting from raw data to output that can be inputted to xltabr
##Allows for differences in all sheets, tries to make it not very painful!

#devtools::load_all()
#devtools::document()
#############


####Get data####
#' Downloads data from road traffic API and formats correctly into data frame
#'
#' @param url the API url. Preset to one that works but can be overwritten (for example, seasonal data)
#' @examples
#' raw <- api_get_data()
#' @export
api_get_data <- function(
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
rolling_annual <- function(raw, x){
  #given the API output changes the estimate column into rolling annual, if
  #given a positive input. If not given "TRUE" or "FALSE" returns error.
  #Note: FALSE changes nothing - the data is already in quarterly values!

  if (!is.logical(x)) {
    stop("second input must be TRUE or FALSE - indicating whether you want
         rolling annual figures or not")
  }
  if (!is.data.frame(raw)) {
    stop("first input must be a data frame from the API output")
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
  #pivots the raw data up by one column, type being either "road" or "vehicle"
  #only used inside the function vehicle_road

  if (!(type=="road" | type=="vehicle")){
    stop("type must be \"vehicle\", \"road\" in this subfunction - select the one you want as cols")
  }
  type <- paste0(type,"_type") #bit of backwards coding - but important due to variable names

  #sum over variable that's not needed (either vehicle_type or road_type)
  new_data <- raw %>%
    dplyr::group_by_("year", "quarter", type) %>%
    dplyr::summarise(estimate = sum(estimate))
  #Pivots type from being a row tso being a few cols (as is categorical)
  new_data <- reshape2::dcast(new_data,
                              year + quarter ~ get(type),
                              #^^"get" is used here as we want the value of type not "type"
                              value.var = "estimate",
                              fun.aggregate = sum)
  # Add  in a column for the sum ie the totals
  total <- rowSums(new_data[, which(names(new_data) %in%
                                    unique(dplyr::pull(raw,type)))])
  #^^^dirty code - but just selects ones we've pivoted up
  new_data <-  cbind(new_data, total)
  colnames(new_data)[length(new_data)] <- "total"
  return(new_data)
}

vehicle_road <- function(raw, type){
  #Do you want the columns to be vehicle type or road type. Pivots the data to be that way
  if (!(type=="road" | type=="vehicle" | type=="vehicle_and_road")){
    stop("type must be \"vehicle\", \"road\", or \"vehicle_and_road\" - select the one you want as cols")
  }

  if (type == "road" | type == "vehicle"){
    #apply the sub function pivot_raw that changes type from being in one column
    #to being separate rows
    new_data <- pivot_raw(raw, type)
  } else { #type = "vehicle_and_road"
    #create 3 data sets to be appended to each other
    new_data_C <- raw[raw$vehicle_type == "cars",]
    new_data_C <- pivot_raw(new_data_C, "road")
    names(new_data_C)[3:8] <- paste0(names(new_data_C),".cars")[3:8]

    new_data_H <- raw[raw$vehicle_type == "hgv",]
    new_data_H <- pivot_raw(new_data_H, "road")
    names(new_data_H)[3:8] <- paste0(names(new_data_H),".hgv")[3:8]

    new_data_L <- raw[raw$vehicle_type == "lgv",]
    new_data_L <- pivot_raw(new_data_L, "road")
    names(new_data_L)[3:8] <- paste0(names(new_data_L),".lgv")[3:8]

    new_data <- base::merge(new_data_C, new_data_H, by = c("year", "quarter"))
    new_data <- base::merge(new_data, new_data_L, by = c("year", "quarter"))

    }

  return(new_data)
}

####Traffic, index numbers, or % change####
chosen_units <- function(new_data, units, index_from=NA){
  #Changes the "estimates" column from the initial data to be either percentage change on
  #previous year, indexed from chosen point, or the same values themselves

  if (!(units %in% c("traffic", "percentage", "index"))){
    stop("units input must be one of: traffic, percentage, or index")
  }

  if (units == "percentage"){

    #percentage change - always 4 quarters apart regardless of whether the data is rolling annual or quarterly :)
    warning("LS fix - bad practice probably in this bit of code below")
    n <- dim(new_data)[2] #width of the data frame
    for (i in 3:n){
      new_data[,i] <- ave(new_data[,i], #the colum we're 'ave'raging
                          FUN = function(x) {100 * ( x / dplyr::lag(x,4) - 1 )}) #the -1 is to get perc CHANGE
    }
  }
  if (units == "index"){
    if(is.na(index_from)){index_from <- list(year=new_data$year[1], quarter=new_data$quarter[1])
    } else {
      stop("index_from is not sorted from vals other than first in data set - sorry!")
    }
    #next 5 lines is probably bad practice - using loops in R!
    n <- dim(new_data)[2] #width of the data frame
    m <- dim(new_data)[1] #length of the data frame
    index_vals <- new_data[1,3:n]
    index_vals <- as.numeric(index_vals) #otherwise in loop we get one number (due to fact is data frame)
    for (i in 3:n){
      new_data[,i] <- 100 * new_data[,i] / index_vals[i-2]
    }
  }
  #NOTE - when units="traffic" we don't change anything. Important to make user define that that is the value they want
  return(new_data)
}

####Wrapper function####
#' given the API output from \code{\link{api_get_data}}, formats into a data frame
#' with values defined by the user.
#'
#' @param raw data frame outputted from \code{\link{api_get_data}()}
#' @param roll logical. TRUE if rolling annual values desired, FALSE if not
#' @param type character string. Either "road" or "vehicle" dependant on which wanted for column headers
#' @param units character string. Either
#'  \itemize{
#'   \item "traffic" - traffic values (vehicle Kms)
#'   \item "percentage" - percentage change from previous year same quarter
#'   \item "index" - indexed values from first quarter in data, with that quarter being 100
#' }
#' @param km_or_miles "km" or "miles" dependant on desired units. Only used if units = "traffic",
#' as otherwise doesn't make a difference.
#' @return data frame of same dimensions as input, with values changed to rolling annual (if stated)
#' @examples
#' #first get the raw data
#' raw <- api_get_data()
#' #Google TRA25 if the naming convention on the left ("TRA25...") doesn't make sense
#' TRA2504e <- raw2new(raw,roll=FALSE, type="vehicle", units="traffic", km_or_miles = "km")
#' TRA2505e <- raw2new(raw,roll=FALSE, type="road", units="traffic", km_or_miles = "km")
#' TRA2504b <- raw2new(raw,roll=TRUE, type="vehicle", units="index")
#' TRA2504c <- raw2new(raw,roll=TRUE, type="vehicle", units="percentage")
#' @export

raw2new <- function(raw, roll=NA, type=NA, units=NA, km_or_miles=NA){
  ##Wrapper function that goes from data read to API to the formatted
  ##output that can be put into xltabr

  raw <- rolling_annual(raw,roll) #quarterly vals or rolling annual

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

  new_data <- vehicle_road(raw, type) #road or vehicle

  temp <- new_data[ ,-which(names(new_data) %in% c("year", "quarter"))]
  new_data <- new_data[rowSums(is.na(temp)) != ncol(temp),] #so we don't have empty rows


  new_data <- chosen_units(new_data, units) #traff, %, or index

  temp <- new_data[ ,-which(names(new_data) %in% c("year", "quarter"))]
  new_data <- new_data[rowSums(is.na(temp)) != ncol(temp),] #so we don't have empty rows
  return(new_data)
}
