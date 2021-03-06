#' Get the taxon name the Soil Order, Suborder, Great Group or Subgroup level
#'
#' @param x A character vector containing subgroup-level taxonomic names
#' @param level one of `c("order","suborder","greatgroup","subgroup")`
#'
#' @return A named character vector of taxa at specified level, where names are the internal Soil Taxonomy letter codes.
#' 
#' @export
#'
#' @examples
#' 
#' # default gets the soil order 
#' getTaxonAtLevel(c("typic haplargids", "typic glacistels")) #, level = "order")
#' 
#' # specify alternate levels
#' getTaxonAtLevel("humic haploxerands", level = "greatgroup")
#' 
#' # can't get subgroup (child) from great group (parent)
#' getTaxonAtLevel("udifolists", level = "subgroup")
#' 
#' # but can do parents of children
#' getTaxonAtLevel("udifolists", level = "suborder")
#' 
getTaxonAtLevel <- function(x, level = c("order","suborder","greatgroup","subgroup")) {
  
  level.names <- c("order","suborder","greatgroup","subgroup")
  
  level = match.arg(level, choices = level.names)
  level.lut <- 1:4
  names(level.lut) <- level.names
  
  levelid <- level.lut[level]
  ncharlevel <- levelid
  
  if (levelid == 4)
    ncharlevel <- 4:5
  
  needle <- decompose_taxon_code(taxon_to_taxon_code(x))
  res <- sapply(needle, function(y) {
    if (length(y) >= levelid && nchar(y[[levelid]]) %in% ncharlevel) {
      return(tolower(taxon_code_to_taxon(y[[levelid]])))
    }
    return(NA_character_)
  })
  names(res) <- x
  if(length(res) > 0)
    return(res)
  return(NA_character_)
}
