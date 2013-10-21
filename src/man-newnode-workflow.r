
################################################################
# name:man-newnode-workflow
"
Most people seem to collect multiple datasets together in a single spot that can be split into 2 or more separate data packages.  
I think your database the other day was an example, and probably we'll find one key challenge for users will be to disentangle their own filing systems just as you are with that example you got sent.

In my experience the way people store research data is often one (or a couple, or all) of these three types:
a) a database with heaps of tables and views
b) a directory (and sub-directories) with heaps of files 
c) a spreadsheet workbook with heaps of sheets (and links to other workbooks)

This is a natural set up from an analysts perspective, where the results of multiple steps accumulate as 'stepping stones' toward the file they end up analysing.  

My tool I am developing addresses the challenge of graphing the links between these sequential steps.  It can be used in two ways.  The first is more suited to what you might need to do retrospectively.
Example one, the composite view:
"
require(disentangle)
# either edit a spreadsheet with filenames, inputs and outputs 
# fileslist <- read.csv("exampleFilesList.csv", stringsAsFactors = F)
# or 
fileslist <- read.csv(textConnection(
'FILE,        INPUTS,           OUTPUTS,         DESCRIPTION
FileA,        TableXYZ,         Input1,          Transformed variable
FileB,        TableABC,         Input2,          Collapsed dimensions
analysisFile, "Input1,Input2",  analysisResults, Merged inputs and analysed
'), stringsAsFactors = F, strip.white = T)
fileslist
# start the graph

graphNodesFile(fileslist)
dev.copy2pdf(file='fileRelationships.pdf')
dev.off();
"
Example two, tracking the steps while analysing data:
Structure a script into sections and document each section before evaluating the code to execute the step.  
For example:
"
#### step one ####
nodes <- newnode("merge", c("d1", "d2", "d3"), c("EDA"),
                 newgraph =T)

#### step two ####
nodes <- newnode("qc", c("data1", "data2", "data3"), c("d1", "d2", "d3"))

#### step two ####
nodes <- newnode("modelling", "EDA")

#### step two ####
nodes <- newnode("model checking", "modelling", c("data checking", "reporting"))

"

It is not aimed at visualising the linked structure of a tree or semi-lattice but can be used in such a way but changing the nodename and inputs concept to parent/child relationships.

I am a great fan of Josh Reich due to his LCFD workflow http://stackoverflow.com/a/1434424, but I also like his work on the Simple Bank https://www.simple.com/#
In this blog post he says
http://blog.i2pi.com/post/52812976752/joshs-postgresql-database-conventions
'Show me your flowchart and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won’t usually need your flowchart; it’ll be obvious.'



Cheers,
Ivan Hanigan
Data Management Officer.
National Centre for Epidemiology and Population Health (NCEPH).
Research School of Population Health.
College of Medicine, Biology and Environment. 
Australian National University Canberra, ACT, 0200.
Ph: +61 2 6125 7767.
Fax: +61 2 6125 0740.
Mob: 0428 265 976.
CRICOS provider #00120C.
"
