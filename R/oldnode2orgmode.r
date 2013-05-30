
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


node <- paste("
** ",ttype,"-",dsc,"\n",
notes,"\n
*** newnode-",dsc,"\n
\\#+name:newnode-",dsc,"
\\#+begin_src R :session *R* :tangle transformations_overview.r :exports none :eval no
nodes <- newnode(name='",dsc,"',
 inputs = c('",i ,"'),
 outputs = c('",o,"')
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
\\#+end_src\n"
 sep="")
}
cat(node)
##################################
sink(paste(project,'overview-TEST.org', sep = "-"))
cat(node)
sink()


}
