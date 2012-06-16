
# http://www.bioconductor.org/packages/2.9/bioc/html/Rgraphviz.html
    source("http://bioconductor.org/biocLite.R")
# http://vladinformatics.blogspot.com.au/2012/03/my-experience-with-installing-rgraphviz.html
# using ubuntu 12.04 make sure libgraphviz-dev is installed. It is needed for some header files (e.g. gvc.h)
# then
     biocLite("Rgraphviz", configure.args=c("--with-graphviz=/usr"))
  # update all
  require(Rgraphviz)
  example(layoutGraph)
      

set.seed(123)
V <- letters[1:10]
M <- 1:4
g1 <- randomGraph(V, M, 0.2)
plot(g1)  


biocLite("biocGraph")
require(biocGraph)
# http://www.bioconductor.org/packages/release/bioc/vignettes/biocGraph/inst/doc/biocGraph.R
data("integrinMediatedCellAdhesion")


###################################################
### code chunk number 51: dummyPlots
###################################################
outdir=tempdir()
nd = nodes(IMCAGraph)
plotFiles = paste(seq(along=nd), 'png', sep='.')
for(i in seq(along=nd)) {
  png(file.path(outdir, plotFiles[i]), width=400, height=600)
  plot(cumsum(rnorm(100)), type='l', col='blue', lwd=2, main=nd[i])
  dev.off()
}


###################################################
### code chunk number 52: indexhtml
###################################################
fhtml = file.path(outdir, "index.html")
con = file(fhtml, open="wt")
cat("<HTML><HEAD><TITLE>",
"Integrin Mediated Cell Adhesion graph with tooltips and hyperlinks, please click on the nodes.",
"</TITLE></HEAD>",
"<FRAMESET COLS=\"3*,2*\" BORDER=0>",
"  <FRAME SRC=\"graph.html\">",
"  <FRAME NAME=\"nodedata\">",
"</FRAMESET></HTML>", sep="\n", file=con)
close(con)


###################################################
### code chunk number 53: makegraph (eval = FALSE)
###################################################
width = 600
height = 512
imgname = "graph.png"
png(file.path(outdir, imgname), width=width, height=height)
par(mai=rep(0,4))

lg = agopen(IMCAGraph, name="foo", 
  attrs = list(graph=list(rankdir="LR", rank=""), node=list(fixedsize=FALSE)), 
  nodeAttrs = makeNodeAttrs(IMCAGraph), 
  subGList = IMCAAttrs$subGList)
plot(lg)    
 
con = file(file.path(outdir, "graph.html"), open="wt")
writeLines("<html><body>\n", con)
imageMap(lg, con=con,
         tags=list(HREF=plotFiles,
           TITLE = nd,
           TARGET = rep("nodedata", length(nd))),
         imgname=imgname, width=width, height=height)
writeLines("</body></html>", con)
close(con)
dev.off()


###################################################
### code chunk number 54: browseurl
###################################################
fhtml
if(interactive())
  browseURL(fhtml)
