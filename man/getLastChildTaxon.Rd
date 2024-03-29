% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getLastChildTaxon.R
\name{getLastChildTaxon}
\alias{getLastChildTaxon}
\title{Get last child taxon in Keys at specified taxonomic level}
\usage{
getLastChildTaxon(level = c("order", "suborder", "greatgroup"))
}
\arguments{
\item{level}{Get child taxa from keys at specified level. One of: \code{"order"}, \code{"suborder"}, \code{"greatgroup"}}
}
\value{
A \code{data.frame} containing \code{key} (parent key), \code{taxon} (last taxon name), \code{code} (letter code), \code{position} (relative taxon position)
}
\description{
Get last child taxon in Keys at specified taxonomic level
}
\examples{

# get last taxa in suborder-level keys
x <- getLastChildTaxon(level = "suborder")

# proportion of keys where last taxon has "Hap" formative element
prop.table(table(grepl("^Hap", x$taxon)))
}
