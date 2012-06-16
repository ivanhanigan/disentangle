require(Rgraphviz)
require(biocGraph)

fhtml = paste(tempfile(), ".html", sep="")
fpng  =paste(tempfile(), ".png", sep="")

if(capabilities()["png"] && interactive()) {
  
  ## Create a random graph, make tooltips and hyperlinks
  set.seed(123)
  g  = randomEGraph(letters[14:22], 0.2)
  
  tooltip = paste("This is node", nodes(g))
  url = paste("This could be a link for node", nodes(g))
  names(url) = names(tooltip) = nodes(g)
  
  ## Open plot device
  width = height = 512
  png(fpng, width=width, height=height)
  par(mai=rep(0,4))
  
  ## Layout and render
  lg = agopen(g, name="My layout")
  plot(lg)
  
  ## Write an HTML file with the image map
  con = file(fhtml, open="wt")
  writeLines("<html><head><title>Click Me</title></head><body>\n", con)
  
  imageMap(object=lg,con= con, imgname=fpng, tags=list(HREF=url, TITLE=tooltip), width=width, height=height)
  
  writeLines("</body></html>", con)
  close(con)
  dev.off()
  
  cat("Now have a look at file", fhtml, "with your browser.\n")
  browseURL(fhtml)
}