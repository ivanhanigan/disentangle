
# name:newgraph
library(DiagrammeR)
library(stringr)
nodes  <- read.csv(textConnection('causes,         effect, colour, pos
                , Rainfall deficit,                           , "-1,3!"
Rainfall deficit, Drought,                                 indianred, "-0.5,2!"
               , Insular society, ,                             "1.5,3!"
Insular society, Anomie, ,                                      "1,2!"
"Drought, Anomie", Altered social structures and dynamics, gray,  "0,0!"
Altered social structures and dynamics, Depression, lightblue,         "4,0!"
Depression,                             Suicide   , lightgreen,        "7,0!"
'), stringsAsFactors = F, strip.white = T)
nodes

dotty <- newgraph(
  indat2  = nodes
  ,
  in_col = "causes"
  ,
  out_col  = "effect"
  ,
  colour_col = "colour"
  ,
  pos_col = "pos"
  )
#cat(dotty$dot_code)

# just test this out
#render_graph(dotty)
#render_graph(dotty, output = "visNetwork")

# actual control
dotty2 <- gsub("digraph \\{",
"digraph \\{
graph [layout = neato]
node [fontname = Helvetica,
     style = filled]
edge [color = gray20,
     arrowsize = 1,
     fontname = Helvetica]",
dotty$dot_code)
#cat(dotty2)
grViz(dotty2)
