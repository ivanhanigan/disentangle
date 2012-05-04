#################################################################
# ~/tools/disentangle/src/transformations_test/colour.r
# author:
# ihanigan
# date:
# 2012-05-04
# description:
# a test of the newnode function and transformations.r/py combo
#################################################################

source('~/tools/disentangle/src/transformations.r')
if(file.exists('src/transformations_test/')) setwd('src/transformations_test/')
if(file.exists('src/')) file.remove(dir('src',full.names=T))

newnode(dsc = "functions", ttype = 'tools', 
i = NA, o = "tools", 
notes = "", 
append = F,
code = "
require(splines)

")

newnode(dsc = "data", 
i =c('scope', 'outcome','population','exposure'), 
o = c('mydata',"metadata"), 
code="
",
KEYNODE = 'a key dataset')

newnode(dsc = "load", ttype = 'load', 
i = c('tools','mydata'), o = "load", 
notes = "", 
code = "
# TASK get some data loaded
")

newnode(dsc = "clean", ttype = 'clean', 
i = 'load', o = c("clean","qc1"), 
notes = "", 
code = "
")

newnode(dsc = 'do',
        i = 'clean', o = c('do','qc2'), 
        notes = "model selection procedure"
        )

newnode(dsc = "report", ttype = 'report', 
i = 'do', o = 'report',
notes = "", 
end_doc = T,
code = "
",
TASK='collate results')

# oldwd <- getwd()
# setwd('reports')
# Sweave('colour_transformations_doc.Rnw')
# setwd(oldwd)

# under windoof can paste into command prompt
# cat("\"~\\tools\\disentangle\\src\\transformations.py\"  transformations_test_transformations.txt transformations_test_transformations")

# under ubuntu
# oldwd <- getwd()
# setwd('reports')
# system('python ~/tools/disentangle/src/transformations.py transformations_test_transformations.txt transformations_test_transformations')
# setwd(oldwd)