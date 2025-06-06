#' Decompose taxon letter codes
#'
#'  Find all codes that logically comprise the specified codes. For instance, code "ABC" ("Anhyturbels") returns "A" ("Gelisols"), "AB" ("Turbels"), "ABC" ("Anhyturbels"). Use in conjunction with a lookup table that maps Order, Suborder, Great Group and Subgroup taxa to their codes (see \code{\link{taxon_code_to_taxon}} and \code{\link{taxon_to_taxon_code}}).
#'
#' @details Accounts for Keys that run out of capital letters (more than 26 subgroups) and use lowercase letters for a unique subdivision within the "fourth character position."
#'
#' @param codes A character vector of taxon codes to "decompose" -- case sensitive
#'
#' @return A list with equal length to input vector; one character vector per element
#'
#' @seealso \code{\link{preceding_taxon_codes}}, \code{\link{taxon_code_to_taxon}}, \code{\link{taxon_to_taxon_code}}
#'
#' @export
#'
#' @examples
#'
#' decompose_taxon_code(c("ABC", "ABCDe", "BCDEf"))
#'
decompose_taxon_code <- function(codes) {
  na.mask <- is.na(codes)
  fin <- vector(mode = 'list', length = length(na.mask))
  fin[na.mask] <- NA
  codes.nona <- codes[!na.mask]

  if(any(!na.mask)) {
    clevels <- sapply(codes.nona, function(cr) strsplit(cr, character(0)))
    clevel.sub <- lapply(clevels, function(cl) grepl("[a-z]", cl[length(cl)]))

    inter <- lapply(clevels, function(l) {
      res <- vector("list", length(l))
      for (i in 1:length(l)) {
        res[i] <- paste0(l[1:i], collapse = "")
      }
      return(res)
    })

    out <- lapply(1:length(inter), function(j) {
      res <- inter[j][[1]]
      if (clevel.sub[[names(inter[j])]]) {
        res[length(res) - 1] <- NULL
      }
      return(res)
    })
    fin[!na.mask] <- out
  }
  names(fin) <- codes
  return(fin)
}

#' Get taxon codes of preceding taxa
#'
#'  Find all codes that logically precede the specified codes. For instance, code "ABC" ("Anhyturbels") returns "AA" ("Histels") "ABA" ("Histoturbels") and "ABB" ("Aquiturbels"). Use in conjunction with a lookup table that maps Order, Suborder, Great Group and Subgroup taxa to their codes (see \code{\link{taxon_code_to_taxon}} and \code{\link{taxon_to_taxon_code}}).
#'
#' @details  Accounts for Keys that run out of capital letters (more than 26 subgroups) and use lowercase letters for a unique subdivision within the "fourth character position."
#'
#' @param codes A character vector of codes to calculate preceding codes for
#'
#' @return A list with equal length to input vector; one character vector per element
#' @export
#'
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{taxon_code_to_taxon}}, \code{\link{taxon_to_taxon_code}}
#'
#' @examples
#'
#' preceding_taxon_codes(c("ABCDe", "BCDEf"))
#'
preceding_taxon_codes <- function(codes) {
  res <- lapply(codes, function(i) {
    if(is.na(nchar(i)))
      return(NA)
    out <- vector(mode = 'list',
                  length = nchar(i))
    parenttaxon <- character(0)
    for (j in 1:nchar(i)) {
      idx <- which(LETTERS == substr(i, j, j))
      idx.ex <- which(letters == substr(i, j, j))
      if (length(idx)) {
        previoustaxa <- LETTERS[1:idx[1] - 1]
        out[[j]] <- previoustaxa
        if (length(parenttaxon) > 0) {
          if (length(previoustaxa)) {
            out[[j]] <- paste0(parenttaxon, previoustaxa)
          }
          newparent <- LETTERS[idx[1]]
          if (length(newparent)) {
            parenttaxon <- paste0(parenttaxon, newparent)
          }
        } else {
          parenttaxon <- LETTERS[idx[1]]
        }
      } else if (length(idx.ex)) {
        previoustaxa <- c("", letters[1:idx.ex[1]])
        out[[j]] <- previoustaxa
        if (length(parenttaxon) > 0) {
          out[[j]] <- paste0(parenttaxon, previoustaxa)
          parenttaxon <- paste0(parenttaxon, letters[idx.ex[1]])
        }
      }
    }

    return(do.call('c', out))
  })
  names(res) <- codes
  return(res)
}

#' Convert taxon code to taxon name
#'
#' @param code A character vector of Taxon Codes
#'
#' @return A character vector of matching Taxon Names
#' @export
#'
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{preceding_taxon_codes}}, \code{\link{taxon_to_taxon_code}}
#'
#' @examples
#'
#' taxon_code_to_taxon(c("ABC", "XYZ", "DAB", NA))
#'
taxon_code_to_taxon <- function(code) {

  ST_higher_taxa_codes_12th <- .get_ST_higher_taxa_codes()

  # LEFT JOIN on code (CASE SENSITIVE)
  res <- merge(data.frame(code = code),
               ST_higher_taxa_codes_12th[ST_higher_taxa_codes_12th$code %in% code,],
               by = "code", all.x = "TRUE", incomparables = NA, sort = FALSE)

  # re-arrange if NA-containing input
  taxon <- res$taxon[match(code, res$code)]

  # add input as names
  names(taxon) <- as.character(code)

  return(taxon)
}

#' Convert taxon name to taxon code
#'
#' @param taxon A character vector of taxon names, case insensitive
#'
#' @return A character vector of matching taxon codes
#'
#' @export
#'
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{preceding_taxon_codes}}, \code{\link{taxon_code_to_taxon}}
#'
#' @examples
#'
#' taxon_to_taxon_code(c("Anhyturbels", "foo", "Cryaquands", NA))
#'
taxon_to_taxon_code <- function(taxon) {

  ST_higher_taxa_codes_12th <- .get_ST_higher_taxa_codes()

  # assume "family" has a comma separated list (words separated by commas)
  #   followed by subgroup (2 or more words without commas)
  #   some families only have one class (soil temperature class) before subgroup name
  ft <- .is_family_taxon(taxon)
  if (any(ft)) {
    taxon[ft] <- gsub(".*, \\b[A-Za-z]+\\b (\\b[^,]*)$|^.*\\b(isomesic|isofrigid|isohyperthermic|frigid|hypergelic|hyperthermic|mesic|pergelic|isothermic|thermic|subgelic) (\\b[^,]*)$", "\\1\\3", taxon[ft], ignore.case = TRUE)
  }

  # return matches
  ltaxon <- tolower(taxon)

  # for efficiency the lowercase taxon names are calculated only if needed
  # the ST_higher_taxa_codes loading function does this
  if (!"taxonlow" %in% colnames(ST_higher_taxa_codes_12th)) {
    ST_higher_taxa_codes_12th$taxonlow <- tolower(ST_higher_taxa_codes_12th$taxon)
  }

  # LEFT JOIN on lowercase taxon name
  res <- merge(data.frame(taxonlow = ltaxon, row.names = NULL),
               ST_higher_taxa_codes_12th[ST_higher_taxa_codes_12th$taxonlow %in% ltaxon,],
               by = "taxonlow", all.x = TRUE, incomparables = NA, sort = FALSE)


  # re-arrange if NA-containing input
  code <- res$code[match(ltaxon, res$taxonlow)]

  # add input as names
  names(code) <- as.character(taxon)

  return(code)
}

#' Determine relative position of taxon within Keys to Soil Taxonomy (Order to Subgroup)
#'
#'  The relative position of a taxon is `[number of preceding Key steps] + 1`, or `NA` if it does not exist in the lookup table.
#'
#' @param code A character vector of taxon codes to determine the relative position of.
#'
#' @return A numeric vector with the relative position of each code with respect to their individual Keys.
#'
#' @export
#'
#' @examples
#'
#' # "ABCD" -> "Gypsic Anhyturbels", relative position 7
#' # "WXYZa" does not exist, theoretical position is 97
#' # "BAD" -> "Udifolists", relative position is 5
#'
#' relative_taxon_code_position(c("ABCD", "WXYZa", "BAD"))
#'
#' # [1]  7 NA  5
#'
relative_taxon_code_position <- function(code) {

  if (length(code) == 0)
    return(numeric(0))

  # calculate theoretical positions for each code
  res <- sapply(preceding_taxon_codes(code), function(x) {
    return(length(x) + 1)
  })

  # non-existent codes return NA
  tst <- vapply(taxon_code_to_taxon(code), FUN.VALUE = logical(1), is.na)
  bad_idx <- which(tst)

  if (length(bad_idx) > 0) {
    res[bad_idx] <- NA
  }

  return(res)
}

#' Return `ST_higher_taxa_codes_12th` dataset efficiently
#'
#' Provides mechanism for caching rather than repeatedly re-reading .rda files for heavily used functions involving code lookup tables.
#' @return data.frame with two columns (`code`, and `taxon` name)
#' @noRd
.get_ST_higher_taxa_codes <- function() {

  if (exists("ST_higher_taxa_codes_12th", envir = SoilTaxonomy.env)) {
    return(get("ST_higher_taxa_codes_12th", SoilTaxonomy.env))
  }

  ST_higher_taxa_codes_12th <- NULL
  load(system.file("data", "ST_higher_taxa_codes_12th.rda", package = "SoilTaxonomy")[1])

  # for efficiency the lowercase taxon names are calculated only if needed
  # the ST_higher_taxa_codes loading function does this
  if (!"taxonlow" %in% colnames(ST_higher_taxa_codes_12th)) {
    ST_higher_taxa_codes_12th$taxonlow <-
      tolower(ST_higher_taxa_codes_12th$taxon)
  }

  assign("ST_higher_taxa_codes_12th",
         ST_higher_taxa_codes_12th,
         envir = SoilTaxonomy.env)

  ST_higher_taxa_codes_12th
}
