context('eztfidf$docs')

# TFIDF objects with different named-ness
replacers = c('INC' = 'incorporated', 'corp' = 'CORPORATION')
tf_noname <- eztfidf::eztfidf(company_names_data, replacers)  # should handle the same as intname
tf_intname <- eztfidf::eztfidf(setNames(company_names_data, seq_along(company_names_data)), replacers)
tf_strname <- eztfidf::eztfidf(setNames(company_names_data, company_names_data), replacers)


test_that('Indexing docs works with names and numbers', {
    expect_gt(length(company_names_data),0)
    expect_equivalent(tf_noname$docs[1], '1st discount brokerage incorporated')
    expect_equivalent(tf_intname$docs['1'], '1st discount brokerage incorporated')
    expect_equivalent(tf_strname$docs['1st Discount Brokerage, Inc.'], '1st discount brokerage incorporated')
})

test_that('Indexed docs are returned with names', {
    expect_null(names(tf_noname$docs[1]))
    expect_equal(names(tf_intname$docs['1']), '1')
    expect_equal(names(tf_strname$docs['1st Discount Brokerage, Inc.']), '1st Discount Brokerage, Inc.')
})

test_that('Multiple docs can be returned by index', {
    valid_result <- c('1st discount brokerage incorporated', '1st global capital corporation')
    expect_equivalent(tf_noname$docs[1:2], valid_result)
    expect_equivalent(tf_intname$docs[c('1','2')], valid_result)
    expect_equivalent(tf_strname$docs[names(tf_strname$docs[1:2])], valid_result)
})

context('eztfidf$values')

test_that('Indexing works with numbers or letters - list mode', {
    expect_equal(length(tf_noname$values(1:3)), 3)
    expect_equal(length(tf_intname$values(c('1','2','3'))), 3)
    expect_equal(length(tf_strname$values(names(tf_strname$docs)[1:3])), 3)
})

test_that('Indexing works with numbers or letters - matrix mode', {
    expect_equal(nrow(tf_noname$values(1:3, mode = 'matrix')), 3)
    expect_equal(nrow(tf_noname$values(1, mode = 'matrix')), 1)
    expect_is(tf_noname$values(1, mode = 'matrix'), 'matrix')
    expect_equal(nrow(tf_intname$values(c('1','2','3'), mode = 'matrix')), 3)
    expect_equal(nrow(tf_strname$values(names(tf_strname$docs[1:3]), mode = 'matrix')), 3)

})
