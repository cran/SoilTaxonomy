context("Soil Taxonomy formative element parsing")

# used to iterate over all taxa at a given level
data("ST_unique_list")

test_that("soil order formative elements", {
  
  # full subgroup
  x <- OrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$order, 'mollisols')
  expect_equal(x$char.index, 15L)
  
  # suborder
  x <- OrderFormativeElements('xererts')
  expect_equal(x$defs$order, 'vertisols')
  expect_equal(x$char.index, 4L)
  
  # another
  x <- OrderFormativeElements('hemists')
  expect_equal(x$defs$order, 'histosols')
  expect_equal(x$char.index, 4L)
  
  # apply to all suborders
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$suborder)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all greatgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$greatgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all subgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$subgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
})


test_that("suborder formative elements", {
  
  # full subgroup
  x <- SubOrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$element, 'xer')
  expect_equal(x$char.index, 12L)
  
  # greatgroup
  x <- SubOrderFormativeElements('haplocryolls')
  expect_equal(x$defs$element, 'cry')
  expect_equal(x$char.index, 6L)
  
  # aridisols were causing problems due to collision ar|arg
  x <- SubOrderFormativeElements('calciargids')
  expect_equal(x$defs$element, 'arg')
  expect_equal(x$char.index, 6L)
  
  # # histels are difficult because of truncation: hist -> ist
  x <- SubOrderFormativeElements('folistels')
  expect_equal(x$defs$element, 'ist')
  expect_equal(x$char.index, 4L)
  
  # multiple occurence of formative elements
  x <- SubOrderFormativeElements('acrustoxic kanhaplustults')
  expect_equal(x$defs$element, 'ust')
  expect_equal(x$char.index, 19L)
  
  # multiple subgroup elements
  x <- SubOrderFormativeElements('aridic lithic argixerolls')
  expect_equal(x$defs$element, 'xer')
  expect_equal(x$char.index, 19L)
  
  # apply to all suborders
  # NA = parsing failure
  x <- SubOrderFormativeElements(ST_unique_list$suborder)
  expect_false(any(is.na(x$defs$suborder)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all greatgroups
  # NA = parsing failure
  x <- SubOrderFormativeElements(ST_unique_list$greatgroup)
  expect_false(any(is.na(x$defs$suborder)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all subgroups
  # NA = parsing failure
  
  # skip_on_cran() # too long for routine test
  # 
  # x <- SubOrderFormativeElements(ST_unique_list$subgroup)
  # expect_false(any(is.na(x$defs$suborder)))
  # expect_false(any(is.na(x$char.index)))
  
})


test_that("greatgroup formative elements", {
  
  # full subgroup
  x <- GreatGroupFormativeElements('typic haploxerolls')
  expect_equal(x$defs$element, 'hap')
  expect_equal(x$char.index, 7L)
  
  # more complex example
  x <- GreatGroupFormativeElements('aridic lithic argixerolls')
  expect_equal(x$defs$element, 'argi')
  expect_equal(x$char.index, 15)
  
  x <- GreatGroupFormativeElements('alfic humic vitrixerands')
  expect_equal(x$defs$element, 'vitr')
  expect_equal(x$char.index, 13)
  
  x <- GreatGroupFormativeElements('acrustoxic kanhaplustults')
  expect_equal(x$defs$element, 'kanhap')
  expect_equal(x$char.index, 12L)
  

  # apply to all greatgroups
  # NA = parsing failure
  x <- GreatGroupFormativeElements(ST_unique_list$greatgroup)
  expect_false(any(is.na(x$defs$greatgroup)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all subgroups
  # NA = parsing failure
  x <- GreatGroupFormativeElements(ST_unique_list$subgroup)
  expect_false(any(is.na(x$defs$greatgroup)))
  expect_false(any(is.na(x$char.index)))

})

test_that("subgroup formative elements", {
  
  # full subgroup
  x <- SubGroupFormativeElements('typic folistels')
  expect_equal(x$defs$element, 'typic')
  expect_equal(x$char.index, 1L)
  
  # more complex example
  x <- SubGroupFormativeElements('aridic lithic argixerolls')
  expect_equal(x$defs$element, c("aridic","lithic"))
  expect_equal(x$char.index, c(1,8))
  
  x <- SubGroupFormativeElements('acrustoxic kanhaplustults')
  expect_equal(x$defs$element, 'acrustoxic')
  expect_equal(x$char.index, 1L)
  
  # apply to all subgroups
  # NA = parsing failure
  # 
  # skip_on_cran() # too long for routine test
  # 
  # x <- SubGroupFormativeElements(ST_unique_list$subgroup)
  # expect_false(any(is.na(x$defs$subgroup)))
  # expect_false(any(is.na(x$char.index)))
  # 
})

test_that("explainST", {
  
  # explain a formative element position in order name
  expect_output(cat(explainST("aridisols")))
  
  # explain several challenging suborders and great groups
  expect_output(cat(explainST("saprists")))
  expect_output(cat(explainST("sapristels")))
  
  expect_output(cat(explainST("folists")))
  expect_output(cat(explainST("folistels")))
  
  data("ST_higher_taxa_codes_12th")
  
  subgroups <- ST_higher_taxa_codes_12th[nchar(ST_higher_taxa_codes_12th$code) >= 4,]
  
  # res <- lapply(subgroups$taxon, function(x) try(explainST(x), silent = TRUE))
  
  # TODO: some sort of partial matching needs revision
  # ties in distance vector: hemistels [histels,hemists]
  
  # first iteration: 30% of subgroups produce errors
  # second iteration: 3% of subgroups produce errors
  # third iteration: no errors woo
  # lbad <- sapply(res, function(x) inherits(x, 'try-error'))
  # round(sum(lbad) / length(res) * 100, 5)
  # 
  # # take five bad ones at random, fix any errors, re-run
  # test.idx <- sample(which(lbad), 5)
  # 
  # subgroups[test.idx,]
  
  # first iteration: all these are broken
  # Error in ws[idx] <- txt : replacement has length zero
  expect_output(cat(explainST("ultic argixerolls")))
  expect_output(cat(explainST("psammentic paleudalfs")))
  expect_output(cat(explainST("vitrandic humustepts")))
  expect_output(cat(explainST("aridic kanhaplustalfs")))
  expect_output(cat(explainST("andic kanhaplustults")))
  expect_output(cat(explainST("terric fibristels")))
  expect_output(cat(explainST("typic folistels")))
  
  # opening a browser w/ HTML output is not a good idea on CRAN
  expect_output(cat(explainST("folistic haplorthels", format = "html", viewer = FALSE)))
  expect_output(cat(explainST("acrudoxic plinthic kandiudults", format = "html", viewer = FALSE)))
  
  # this is not a real taxon, but the great group portion is identifiable/explainable
  expect_output(cat(explainST("goobery foobery kandiudults", format = 'text', viewer = FALSE)))
})

test_that("explainST HTML viewer", {
  
  skip_on_cran()
  
  # test the utils::browseURL functionality off CRAN
  expect_output(cat(explainST("folistic haplorthels", format = "html", viewer = TRUE)))
  expect_output(cat(explainST("acrudoxic plinthic kandiudults", format = "html", viewer = TRUE)))
})

# a test of explainST for all taxa: 
# res <- lapply(level_to_taxon(), explainST)
