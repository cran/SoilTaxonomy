test_that("getTaxonAtLevel works", {

  # specify alternate levels
  expect_equal(getTaxonAtLevel("humic haploxerands", level = "greatgroup"),
               c(`humic haploxerands` = "haploxerands"))

  # can't get subgroup (child) from suborder (parent), can get suborder from suborder
  expect_equal(getTaxonAtLevel(c('folists','plinthic kandiudults'), level = "subgroup"),
               c(`folists` = NA, `plinthic kandiudults` = "plinthic kandiudults"))

  # but can do parents of children
  expect_equal(getTaxonAtLevel("udifolists", level = "suborder"),
               c(`udifolists` = "folists"))

  # default is level="order"
  expect_equal(getTaxonAtLevel("udolls"),
               c(`udolls` = "mollisols"))

  # data.frame result when length(level) > 1
  expect_equal(getTaxonAtLevel(c("haploxerolls", "hapludolls"), level = c("order", "suborder", "greatgroup", "subgroup"), simplify = FALSE),
               data.frame(order = c("mollisols", "mollisols"),
                          suborder = c("xerolls",  "udolls"),
                          greatgroup = c("haploxerolls", "hapludolls"),
                          subgroup = c(NA_character_, NA_character_),
                          row.names = c("haploxerolls", "hapludolls")))

  # garbage and 0-character input
  g1 <- getTaxonAtLevel("foo")
  g2 <- getTaxonAtLevel("")
  expect_true(is.na(g1[[1]]) && is.na(g2[[1]]))

  # empty (length 0) and missing (NA) input
  expect_true(is.na(getTaxonAtLevel(character(0))) && is.na(getTaxonAtLevel(NA)))
})
