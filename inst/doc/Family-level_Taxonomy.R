## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
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
afamily_classes <- parse_family("fine-loamy, mixed, semiactive, mesic ultic haploxeralfs")$classes_split[[1]]
class_descriptions <- subset(ST_family_classes, classname %in% afamily_classes)
class_descriptions[match(afamily_classes, class_descriptions$classname),]

