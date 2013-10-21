expect_that(helper.function(), equals(NULL))
expect_that(helper.function(), equals(NULL))

## test.newnode
source('tests/test.newnode.R')
expect_that(newnode(name = 'node1',
                   inputs = c('input1', 'input2'),
                   outputs = c('output1', 'output2'),
                   newgraph = T
                   ),
            is_identical_to(nodesTest)
            )
