% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/1_arrange_data_in_R.R
\name{chosen_units}
\alias{chosen_units}
\title{Ultimately a subfunction of \code{\link{TRA25_arrange_data}}}
\usage{
chosen_units(data_for_xl, units, index_from = NA)
}
\arguments{
\item{data_for_xl}{the pivotted data, outputted from \code{\link{TRA25_vehicle_road}}}

\item{units}{either "traffic", "percentage", "index" depending on what values required.}

\item{index_from}{which row you want to index the values from. Default is first, if multiple
rows are given then index is from their average}
}
\description{
Ultimately a subfunction of \code{\link{TRA25_arrange_data}}
}
