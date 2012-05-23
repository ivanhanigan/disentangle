#################################################################
# My Dropbox/tools/transformations.r
# author:
# ihanigan
# date:
# 2010-07-19
# description:
# a function to create workflow diagrams using Joe Guillaume's graphviz tool
# requires graphviz, pyparsing, pydot, transformations.py
#################################################################
 
if (!require(R2HTML)) install.packages('R2HTML', repos='http://cran.csiro.au'); require(R2HTML)
# TASKS
# add a sanitizer to code to replace \' with \\' for cat.?
# remove reports/
# add the work different py? transformationsWork.py
# check py on r server
# currnode, o = dsc?
# choose colour

#################################################################
 Sys.Date()
# changelog
# 2012-03-13    change run to src
# 2012-02-20    ADD KEYNODE WITH COLOUR
# 2011-09-12 subsection, nosectionheading, gsub reports, title...
# 2010-10-18	go back to writing out to 'run' directory
# 2010-08-25	added more sweave stuff and task list
# 2010-08-20	modify the way that notes are written to include tabs.  add dontshow_doc
# 2010-07-19 	add arg document=c('html','sweave') writes html, add args for insert graph, table, etc
# 2010-12-10	change defaults from html to sweave

# todo
# add sweave stff


newnode=function(project=unlist(strsplit(getwd(),"/"))[length(unlist(strsplit(getwd(),"/")))],
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
        KEYNODE=NA){
if(is.na(ttype)) ttype=dsc

if(!file.exists('reports')) dir.create('reports',showWarnings=F)

node=paste("Transformation
	description
		",dsc,
if(!is.na(i[1])){
	paste("
	inputs
		",
    paste(i,sep="", collapse="\n\t\t")
    ,sep='')
    },
	if(!is.na(o[1])){
	paste("
	output
		",
    paste(o,sep="", collapse="\n\t\t")
	,sep='')
    } else {
		paste("
	output
		",
    paste(ttype,sep="", collapse="\n\t\t")
	,sep='')
	},"
	notes
		",gsub('\n','\n\t\t',notes),"
	ttype
		",ttype,"\n",sep=""
)
		
if ( !is.na(code) ) {
	if(!file.exists('src')) dir.create('src', showWarnings =F) #
	# if(ttype=='lib') ttype2 <- 'utilities' else ttype2 <- ttype # 

	node=paste(node,"\n\tcode\n\t\t",gsub("\n","\n\t\t",code),"\n\n",sep="")
	write.table(
		paste("###############################################################################\n# newnode ",
		dsc
		,"\n\t",
		code
		,sep="")
	,
	paste('src/',project,"_",ttype,".r",sep=""),
	sep="",row.names=F,col.names=F,quote=F,append=append)

}

if ( !is.na(code)  & length(grep('TASK', code)) > 0 & is.na(TASK)) {
	node=paste(node,"\n\tTASK\n\t\t","\n\t\tTASK\n\n",sep="")
}

if ( !is.na(TASK) ) {
	node=paste(node,"\n\tTASK\n\t\t",gsub("\n","\n\t\t",TASK),"\n\n",sep="")
# NOT IMPLEMENTED, BUNCH OF OTHER WAYS TO FIND A LIST OF TASKS.
	# write.table(
		# paste("###############################################################################\n# ",
		# dsc
		# ,"\n\t",
		# code
		# ,sep="")
	# ,
	# paste('run/',project,"_",ttype,".r",sep=""),
	# sep="",row.names=F,col.names=F,quote=F,append=append)
      }

if ( !is.na(KEYNODE) ) {
  node=paste(node,"\n\tKEYNODE\n\t\t",gsub("\n","\n\t\t",KEYNODE),"\n\n",sep="")
}

if ( !is.na(dontshow) ) {
	node=paste(node,"\n\tdontshow\n\t\t",dontshow,"\n\n",sep="")
	}

write.table(node,paste('reports/',project,"_transformations.txt",sep=""),sep="",row.names=F,col.names=F,quote=F,append=append)

################################################################
if ( document == 'html' & is.na(dontshow_doc) ) {
	#.HTML.file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep=""))
	if(append==F) {
	HTML(as.title(paste(project," transformations",sep="")),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")), append = FALSE)
	
	HTML.title(paste('Ivan C. Hanigan',sep=''),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	#HTML.title(paste('National Centre for Epidemiology and Population Health',sep=''),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	#HTML.title(paste('Australian National University.',sep=''),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	HTML.title(paste(Sys.Date(),sep=''),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	sink(paste('reports/',project,"_transformations_doc_index.txt",sep=""),append=F)
	cat(paste("HTML.title(\"Index\", file = '",project,"_transformations_doc.html')\n",sep=""))
	sink()
	}
	
	HTML.title(paste("<a name='",dsc,"'>",dsc,"</a>",sep=""),file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	# HTML(notes,file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
	
	sink(paste('reports/',project,"_transformations_doc_index.txt",sep=""),append=T)
	cat(paste("HTML('<a href=\"#",dsc,"\">",dsc,"</a>', file = \"",project,"_transformations_doc.html\")\n",sep=""))
	sink()
	
	for(codeline in unlist(strsplit(notes,'\n'))){
		HTML(codeline,file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))
		}
	
if(!is.na(code) & doc_code==T) {
	code_df=as.data.frame(unlist(strsplit(code,'\n')))
	names(code_df)='CODE:'
	HTML(code_df,align='left',file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")),row.names=F)	
	} 
	# else {
	# code_df=as.data.frame('code hidden')
	# names(code_df)='R CODE'
	# HTML(code_df,align='left',file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")),row.names=F)
	# }
if(!is.na(insertgraph)) HTMLInsertGraph(insertgraph,Align='left',WidthHTML=850,file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")))

if(!is.na(inserttable)){
foo <- read.csv(file.path('reports',inserttable))
HTML(foo,align='left',file = file.path(getwd(), paste('reports/',project,"_transformations_doc.html",sep="")),row.names=F)
}
}

################################################################
if ( document == 'sweave' & is.na(dontshow_doc) ) {

# file.copy('~/My Dropbox/tools/Sweave.sty','reports/Sweave.sty')
# not needed if running from RStudio
  
if(append==F) {
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = FALSE)
cat(
paste('\\documentclass[a4paper]{article}   
\\usepackage{cite} 
\\usepackage{hyperref} 
\\usepackage{longtable} 
\\usepackage{verbatim} 
\\usepackage{rotating}
\\begin{document}
\\title{',gsub('_',' ',ifelse(!is.na(title),title,toupper(project))),'} 
\\author{Ivan C. Hanigan$^{1}$}
\\date{\\today}                 
\\maketitle
\\begin{itemize}
\\item [$^1$] National Centre for Epidemiology and Population Health, \\\\Australian National University.
\\end{itemize}

\\setcounter{page}{1}
\\pagenumbering{roman}
\\tableofcontents 
\\pagenumbering{arabic}
\\setcounter{page}{1}

\\section{',dsc,'}
',notes,'
',sep=""))
sink()
} else {
 if(nosectionheading==F){
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
if(subsection != F){
cat(
paste('
\\subsection{',dsc,'}
',notes,'
',sep="")
) 
} else {
cat(
paste('
\\section{',dsc,'}
',notes,'
',sep="")
)
}
sink()
} else {
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
if(subsection != F){
cat(
paste('
%% \\subsection{',dsc,'}
',notes,'
',sep="")
) 
} else {
cat(
paste('
%% \\section{',dsc,'}
',notes,'
',sep="")
)
}
sink()
}
}

if(!is.na(code) & doc_code == T) {
 code <- gsub('reports/','',code)
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat(
paste('<<eval=',evalCode,',echo=',echoCode,',keep.source=TRUE>>=	',
paste('
######################
#',ttype,',  ',dsc,'
######################
      
', sep = ''),      
paste(unlist(strsplit(code,'\n')),sep='',collapse='\n')
,'
@
',sep=""))
sink()
}	

if(!is.na(insertgraph)){
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat(paste('
\\begin{figure}[!h]
\\centering
\\includegraphics[width=\\textwidth]{',insertgraph,'}
\\caption{',gsub('.jpg','',insertgraph),'}
\\label{fig:',gsub('.jpg','',insertgraph),'}
\\end{figure}
\\clearpage
',sep=""))
sink()
}

if(!is.na(inserttable)){

 if(tabsideways == F){
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat(paste("
<<label=",tablabel,",echo=FALSE,results=tex>>=
library(xtable)
foo <- read.csv('",inserttable,"')

print(xtable(foo, caption = '",caption,"', label = 'tab:",tablabel,"',
	digits = ",digits,", align = ",align,"), table.placement = 'ht',
	caption.placement = 'top',include.rownames=F)
@
",sep=""))
sink()
} else {
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat(paste("
<<label=",tablabel,",echo=FALSE,results=tex>>=
library(xtable)
foo <- read.csv('",inserttable,"')

print(xtable(foo, caption = '",caption,"', label = 'tab:",tablabel,"',
 digits = ",digits,", align = ",align,"), table.placement = 'ht',
	caption.placement = 'top',include.rownames=F,
 floating.environment='sidewaystable')
@
",sep=""))
sink()
 } 
}

if(clearpage==T){
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat('\\clearpage\n')
sink()
}

if( end_doc == T) {	
sink(file.path(getwd(), paste('reports/',project,"_transformations_doc.Rnw",sep="")), append = T)
cat('
\n
\\end{document}')
sink()
cat(paste("now run 
oldwd <- getwd()
setwd('reports')
Sweave('",project,"_transformations_doc.Rnw')
setwd(oldwd)
",sep="")
)
}

}

	
}

# for eg
#newnode('testin.txt',dsc='test',i=c('an input','another input'),o='an output',notes='some guff',app=F)
#newnode('testin.txt','test2','even another input','an output','some guff',app=T)
#newnode('testin.txt','test3','an output','another output','some guff',app=T)
#shell("Testin.txt")
# shell("i:\\tools\\read_t.py testin.txt test")
project=unlist(strsplit(getwd(),"/"))[length(unlist(strsplit(getwd(),"/")))]
cat(' suggest run line when running')
cat("\n\nshell(\"i:\\tools\\transformations.py ",paste(project,"_transformations.txt",sep="")," ",paste(project,"_transformations.txt",sep=""),"\")")

# TO DO

##
# make more tags available
#	instructions
#	documentation
#	script_location
#	function_call
#	time
#	ttype
# dontshow

##
# make a 'go' function
# one for graph and one for analysis?

##
# look into making newnode insert between existing nodes and edit their input/output automatically based on insert

## 
# make a package?



cat("\n\n
#################################################################
newnode(dsc = 'Introduction', ttype = 'reports', 
dontshow = T,
notes = '', 
append = F,
document='sweave',
code = NA)

#################################################################
newnode(dsc = 'functions', ttype = 'lib', 
i = NA, 
o = '', 
notes = '', 
append = T,
document='sweave',
code = \"

\")

#################################################################
newnode(dsc = 'The end', ttype = 'reports', 
dontshow = T,
append = T,
document='sweave',
end_doc = T)

Sweave('foo.Rnw')
")
cat("\n\nwhen developing the code it is useful to remove the run files")
cat("\n\nfile.remove(dir('src',full.names=T))")
cat("\n\nand then you get to run the run files")
cat("\n\nsource(dir('src',pattern='tools',full.names=T))")

#\"
	
header=function(project=unlist(strsplit(getwd(),"/"))[length(unlist(strsplit(getwd(),"/")))],requires=c('RODBC'),desc='a project of great importance',auth='ihanigan',datecreated=as.Date(format(Sys.time())) ){

cat(  paste("#################################################################",
paste(getwd(),"/",paste(project,"_overview.r",sep=""),sep=""),
"author:",auth,"date:",datecreated,"description:",desc, sep="\n# "))
cat( paste("\n#################################################################\n","\n"))
cat( paste("require(",requires,")",collapse="\n"))  
cat( paste("\n#################################################################\n\n\n",sep=""))
}

ask4package <- function(package, mirror = 'http://cran.csiro.au' ){
 cat(sprintf("if (!require(%s)) install.packages('%s', repos='%s'); require(%s)",package,package, mirror,package))
}
#ask4package('Hmisc')

packages<-function(x){
   x<-as.character(match.call()[[2]])
   if (!require(x,character.only=TRUE)){
      install.packages(pkgs=x,repos="http://cran.r-project.org")
      require(x,character.only=TRUE)
   }
}
#packages(Hmisc)

