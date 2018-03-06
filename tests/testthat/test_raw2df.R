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
  check_api_online("https://statistics-api.dft.gov.uk/api/roadtraffic/quarterly")
  #^^ skip this bit if can't even access API

  raw <- api_get_data()
  #below is quite a strict error test - var names can't change, neither can order
  expect_equal(names(raw), c("year", "quarter", "road_type", "vehicle_type", "estimate"))
  #can't have negative? or NA traffic flow
  expect_that(min(raw$estimate), is_weakly_more_than(0-10^-100) , label = "negative values")
  expect_that(sum(is.na(raw)), equals(0),label="NA vals")
})
