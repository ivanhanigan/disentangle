
################################################################
# name:newnode
source("R/newnode.r")
nodes <- newnode("merge", c("d1", "d2", "d3"), c("EDA"),
                 newgraph =T)
nodes <- newnode("qc", c("data1", "data2", "data3"), c("d1", "d2", "d3"))
nodes <- newnode("modelling", "EDA")
nodes <- newnode("model checking", "modelling", c("data checking", "reporting"))
