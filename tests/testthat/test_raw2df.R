########
##testing the functions in the file "raw2df", which
##culminates in the function "raw2new" (potential
##for confusion)
########

library(testthat)
library(RCurl)


check_api_working <- function(my_url) {
  if (!RCurl::url.exists(my_url)){
    skip("API not available, or you are not online")
  }
}

test_that("api data in expected format",{
  check_api_working("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly")
  #^^ skip this bit if can't even access API

  raw <- TRA25_data_api()
  #below is quite a strict error test - var names can't change, neither can order
  expect_equal(names(raw), c("year", "quarter", "road_type", "vehicle_type", "estimate"))
  #can't have negative? or NA traffic flow
  expect_true(min(raw$estimate) > (0-10^-100) , label = "negative values")
  expect_that(sum(is.na(raw)), equals(0),label="NA vals")
  expect_equal(raw,raw[order(raw$year, raw$quarter),], label = "ordered abnormally")
})

test_that("rolling_annual not working as expected", {
  #Setting up a dummy data set
  d_0 <- data.frame(year = NA, quarter=rep(c(2,3,4,1,2,3,4,1),each=4))
  d_0$year <- rep(c(10,10,10,11,11,11,11,12),each=4)
  d_0$road_type <- c("A","A","B","B")
  d_0$vehicle_type <- c("C","D")
  set.seed(1) #so we get the same data every time
  d_0$estimate <- round(rnorm(32,10,2),2)

  d_1 <- LStest:::rolling_annual(d_0,TRUE)
  #The expected output is:
  a <- c(39.32, 33.69, 44.57, 45.36, 40.54, 35.21, 47.88, 43.36,
         41.72, 38.41, 47.06, 37.90, 41.81, 38.91, 43.73, 34.18,
         42.09, 44.18, 44.20, 34.06)

  expect_equal(d_1$estimate, a)
})

