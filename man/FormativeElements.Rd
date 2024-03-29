% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formative-elements.R
\name{FormativeElements}
\alias{FormativeElements}
\alias{OrderFormativeElements}
\alias{SubOrderFormativeElements}
\alias{GreatGroupFormativeElements}
\alias{SubGroupFormativeElements}
\alias{get_ST_formative_elements}
\title{Identify formative elements in taxon names at Soil Order, Suborder, Great Group or Subgroup level}
\usage{
FormativeElements(x, level = c("order", "suborder", "greatgroup", "subgroup"))

OrderFormativeElements(x)

SubOrderFormativeElements(x)

GreatGroupFormativeElements(x)

SubGroupFormativeElements(x)

get_ST_formative_elements(
  level = c("order", "suborder", "greatgroup", "subgroup")
)
}
\arguments{
\item{x}{A character vector containing subgroup-level taxonomic names}

\item{level}{one of \code{c("order","suborder","greatgroup","subgroup")}}
}
\value{
A list containing \verb{$defs}: a \code{data.frame} containing taxonomic elements, derivations, connotations and links. And \verb{$char.index}: a numeric denoting the position where the formative element occurs in the search text \code{x}

\code{get_ST_formative_elements()}: a data.frame containing descriptors of formative elements used at the specified \code{level}
}
\description{
Identify formative elements in taxon names at Soil Order, Suborder, Great Group or Subgroup level
}
\examples{

FormativeElements("acrudoxic plinthic kandiudults", level = "subgroup")
SubGroupFormativeElements("acrudoxic plinthic kandiudults")

FormativeElements("acrudoxic plinthic kandiudults", level = "greatgroup")
GreatGroupFormativeElements("acrudoxic plinthic kandiudults")

FormativeElements("acrudoxic plinthic kandiudults", level = "suborder")
SubOrderFormativeElements("acrudoxic plinthic kandiudults")

FormativeElements("acrudoxic plinthic kandiudults", level = "order")
OrderFormativeElements("acrudoxic plinthic kandiudults")

}
\author{
D.E. Beaudette, A.G. Brown
}
