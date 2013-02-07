
################################################################
# name:oldnode2orgmode
#maybe args dsc, ttype, title, dontshow, notes, append, code)
oldnode2orgmode <- function(project = unlist(strsplit(getwd(),"/"))[length(unlist(strsplit(getwd(),"/")))],
          title = NA,
          dsc='',ttype=dsc,
          i=NA,
          o=NA,
          notes='',
          code=NA,
          TASK=NA,subsection=T,nosectionheading=F,
          dontshow=NA,append=T, document='sweave',insertgraph=NA,
          doc_code=T, end_doc=F,dontshow_doc=NA,evalCode='FALSE',echoCode='TRUE',inserttable=NA,caption='',
          tablabel='tabx',digits='',align='', tabsideways=F, clearpage=F,
          KEYNODE=NA)
{
if(is.na(ttype)) ttype <- dsc
if(is.na(i[1]))
{
i <- paste(dsc,1,sep = '-')
} else {
i <- paste(i,sep="", collapse="','")
}
if(is.na(o[1]))
{
o <- 'NA'
} else {
o <- paste(o,sep="", collapse="','")
}
if (!is.na(dontshow))
{
tangle <- "no"
} else {
tangle <- "transformations_overview.r"
}
if(append)
{
  newgraph <- "F"
} else {
  newgraph <- "T"
}
node <- paste("
** ",ttype,"-",dsc,"\n",
notes,"\n
*** newnode-",dsc,"\n
\\#+name:newnode-",dsc,"
\\#+begin_src R :session *R* :tangle ",tangle," :exports none :eval no
nodes <- newnode(name='",dsc,"',
inputs = c('",i ,"'),
outputs = c('",o,"'),
newgraph = ",newgraph,"
)
\\#+end_src
", sep = "")

#cat(node)
if ( !is.na(code) ) {
node <- paste(node,"\n
*** src-",dsc,"\n
\\#+name:src-",dsc,"
\\#+begin_src R :session *R* :tangle src/",ttype,"-",dsc,".r :exports none
", code,"
\\#+end_src\n
", sep="")
}
#cat(node)



##################################
fout <- paste(project,'overview.org', sep = "-")
# if the file already exists don't clobber it
#  if(file.exists(fout)) fout <- gsub('overview','overview-nodes', fout)
if(append)
{
sink(fout, append = T)
cat(node)
sink()
} else {
sink(fout)
cat(node)
sink()
}

}
