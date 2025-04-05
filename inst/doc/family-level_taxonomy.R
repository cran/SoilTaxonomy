## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  eval = SoilTaxonomy:::.soilDB_metadata_available(min_version = "2.0.0"),
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(SoilTaxonomy)

## -----------------------------------------------------------------------------
parse_family("fine-loamy, mixed, semiactive, mesic ultic haploxeralfs")

## -----------------------------------------------------------------------------
data("ST_family_classes")
head(ST_family_classes)

## -----------------------------------------------------------------------------
f <- "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"
family_classes <- parse_family(f, column_metadata = FALSE)$classes_split[[1]]

get_ST_family_classes(classname = family_classes)

