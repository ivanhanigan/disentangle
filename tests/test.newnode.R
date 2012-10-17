
# newnodeTest
# TODO remove depencencies (nodesTest shouldn't require newnode)
# TODO include colours and test
# TODO include colours in tests
# TODO incorporate test of newgraph = T or F

nodesTest <- newnode(name = 'node1',
                 inputs = c('input1', 'input2'),
                 outputs = c('output1', 'output2'),
                 newgraph = T, graph = "nodesTest")

## nodesTest <- newnode(name = 'node2',
##                  inputs = 'output2',
##                  outputs = 'final',
##                  graph = "nodesTest")

## identical(nodesTest, nodes)

expect_that(newnode(name = 'node1',
                   inputs = c('input1', 'input2'),
                   outputs = c('output1', 'output2'),
                   newgraph = T
                   ),
            is_identical_to(nodesTest)
            )
