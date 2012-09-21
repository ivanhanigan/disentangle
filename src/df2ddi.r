#################################################################
# df2ddiNCEPH.r
# author:
# ihanigan
# date:
# 2010-07-29
# description:
# a set of functions to create the tables used by ddiindex-nceph.anu.edu.au (NB these are not actually valid DDI 2 files)

# changes
# 2011-02-22	upgrade with xml options, still operates remotely from oracle of delphe.

##############
# newnode to do
# solve issues caused by being remote from oracle, ie upload data descriptions via html, 
# sync with pkeys?  can this be unique within stdy.file combos? is it even necessary at local level?
# make_xml needs work
# date variables need to be '23-FEB-2011'


if (!require(sqldf)) install.packages('sqldf')
require(sqldf)
if (!require(R2HTML)) install.packages('R2HTML')
require(R2HTML)
##############
# newnode add study
add_stdydscr=function(idno=NA,titl=NA,abstract=NA,authoring_entity_of_data=NA,distrbtr='NCEPH data manager',bibliographic_citation=NA,notes='NCEPH Unrestricted', restrctn=NA,datakind='OTHER',ask=F){

elements = c('TITL','IDNO','PRODUCER','PRODDATEDOC','BIBLCITDOC','AUTHENTY','COPYRIGHT','PRODDATESTDY','FUNDAG','DISTRBTR','SERNAME','VERSION','BIBLCITSTDY','TIMEPRD','COLLDATE','GEOGCOVER','GEOGUNIT','ANLYUNIT','UNIVERSE','DATAKIND','CLEANOPS','CONFDEC','SPECPERM','RESTRCTN','NOTES','ABSTRACT')

stdydscr=as.data.frame(matrix(nrow=1,ncol=length(elements), byrow=TRUE))
names(stdydscr)=elements
if(is.na(titl)) {titl<- readline('title of study: ')}
stdydscr$TITL =titl
if(is.na(idno)) {idno<- readline('ID code of study: ')}
stdydscr$IDNO =idno
if(is.na(abstract)) {abstract<- readline('abstract: ')}
stdydscr$ABSTRACT =abstract
if(is.na(authoring_entity_of_data)) {authoring_entity_of_data<- readline('authoring_entity_of_data: ')}
stdydscr$AUTHENTY =authoring_entity_of_data
# auto
stdydscr$PRODDATEDOC =Sys.Date()

if(ask==F){
stdydscr$PRODUCER =''

stdydscr$BIBLCITDOC =''
stdydscr$COPYRIGHT =''
stdydscr$PRODDATESTDY =''
stdydscr$FUNDAG =''
stdydscr$DISTRBTR = distrbtr
stdydscr$SERNAME =''
stdydscr$VERSION =''
stdydscr$BIBLCITSTDY =bibliographic_citation
stdydscr$TIMEPRD =''
stdydscr$COLLDATE =''
stdydscr$GEOGCOVER =''
stdydscr$GEOGUNIT =''
stdydscr$ANLYUNIT =''
stdydscr$UNIVERSE =''
stdydscr$DATAKIND =datakind
stdydscr$CLEANOPS =''
stdydscr$CONFDEC =''
stdydscr$SPECPERM =''
stdydscr$RESTRCTN =restrctn
stdydscr$NOTES =notes

} else {
for(i in c(7:(length(elements)-1))){
	element=elements[i]
	stdydscr[1,i]=readline(paste("enter descriptions for the ",element,": "))
	}
}
# TASK add a caveat that if NOTES is null then NCEPH Unrestricted
return(stdydscr)
}


##############
# newnode add file
add_filedscr=function(fileid=NA,idno=NA,filename=NA,notes='NCEPH_Unrestricted',filelocation=NA,file_description='',ask=F){
elements = c('IDNO','FILENAME','FILETYPE','PROCSTAT','SPECPERMFILE','DATEARCHIVED','DATEDESTROY','FILEDSCR','NOTES','REQID','PUBLISHDDI','BACKUPVALID','DATEBACKUPVALID','CHECKED','BACKUPLOCATION')
filedscr=as.data.frame(matrix(nrow=1,ncol=length(elements), byrow=TRUE))
names(filedscr)=elements
stopifnot(!is.na(idno)) 
filedscr$IDNO =idno
if(is.na(fileid)) {fileid<- readline('fileid, one number for each file in the study: ')}
filedscr$FILEID =fileid
if(is.na(filename)) {filename<- readline('filename: ')}
filedscr$FILENAME =filename
if(is.na(notes)) {notes<- readline('notes: ')}
filedscr$NOTES =notes
if(is.na(filelocation)) {filelocation <- getwd()}
filedscr$FILELOCATION =filelocation
if(is.na(file_description)) {file_description<- readline('file_description: ')}
filedscr$FILEDSCR=file_description

if(ask==F){
filedscr$FILETYPE =''
filedscr$PROCSTAT =''
filedscr$SPECPERMFILE =''
filedscr$DATEARCHIVED =''
filedscr$DATEDESTROY =''
filedscr$REQID =''
filedscr$PUBLISHDDI =''
filedscr$BACKUPVALID =''
filedscr$DATEBACKUPVALID =''
filedscr$CHECKED =''
filedscr$BACKUPLOCATION =''
} else {
for(i in 3:length(elements)){
	element=elements[i]
	filedscr[1,i]=readline(paste("enter descriptions for the ",element,": "))
	}
}

return(filedscr)
}


##############
# newnode add data
add_datadscr=function(data_frame, fileid = NA,notes=NA,specperm=F,ask=F){
labls=names(data_frame)
datadscr=as.data.frame(matrix(nrow=length(labls),ncol=4, byrow=TRUE))
names(datadscr)=c('LABL','NOTES','SPECPERMVAR', 'FILEID')
datadscr$LABL=labls
if( !is.na(notes) ){ stopifnot(length(notes) == length(labls))}

if(!is.na(notes[1])) {
	datadscr$NOTES=notes
} else if(ask==F){
datadscr$NOTES=rep('',length(labls))
} else {
for(i in 1:length(labls) ){
#if element is null then
labl=labls[i]
datadscr[i,1]=labl
datadscr[i,2]=readline(paste("enter descriptions for the ",labl,": "))
if(specperm==T) datadscr[i,3]=readline(paste("special permissions for ",labl,": "))
}
}
datadscr$FILEID=fileid
cat(paste("write.table(f,'metadata/{study}_ddi_filedscr.csv',sep=',',row.names=F)
# OR
write.table(f,'metadata/{study}_ddi_filedscr.csv',sep=',',row.names=F, append=T, col.names=F)
",sep=''))
return(datadscr)

}

##############
# newnode stitch together to make a 
make_ddi=function(s,f,d,exportCsv=F,export_xml=F,makeHtml=T,addMap=NA){
stdyDscr=s
fileDscrJ=f
dataDscr=d
idno=stdyDscr$IDNO
filename=gsub('\\.csv','',fileDscrJ$FILENAME)
ddi=list(stdyDscr,fileDscrJ,dataDscr)

if(exportCsv==T) {
write.table(stdyDscr,paste(toupper(idno),'ddi_stdydscr.csv',sep='_'),sep=',',row.names=F)
if(file.exists(paste(toupper(idno),'ddi_filedscr.csv',sep='_'))){
write.table(fileDscrJ,paste(toupper(idno),'ddi_filedscr.csv',sep='_'),sep=',',row.names=F, col.names=F, append=T)
} else {
write.table(fileDscrJ,paste(toupper(idno),'ddi_filedscr.csv',sep='_'),sep=',',row.names=F)
}
if(file.exists(paste(toupper(idno),'ddi_datadscr.csv',sep='_'))){
write.table(dataDscr,paste(toupper(idno),'ddi_datadscr.csv',sep='_'),sep=',',row.names=F,col.names=F,  append=T)
} else {
write.table(dataDscr,paste(toupper(idno),'ddi_datadscr.csv',sep='_'),sep=',',row.names=F)
}
} 



# make a html

if(makeHtml==T){
	names(stdyDscr)=toupper(names(stdyDscr))
	attach(stdyDscr)
	names(fileDscrJ)=toupper(names(fileDscrJ))
	attach(fileDscrJ)
	outdir=file.path(getwd(),'metadata')
	if(!file.exists('metadata')){dir.create('metadata')}
	abbreviation=idno
	outfilename=paste(outdir,'/',tolower(abbreviation),'_',fileDscrJ$FILEID,".html",sep='')
	#.HTML.file = file.path(outfilename)
	

	HTML(as.title(
	paste("Dataset ID= ",tolower(abbreviation),"_",fileDscrJ$FILEID,sep="")
	), append = FALSE,file=outfilename)
	HTML(as.title(
	paste("Dataset Name = ",paste(toupper(abbreviation),FILENAME,sep='_'),sep="")
	), append = T,file=outfilename)
	
	HTML('<a href="#File Notes">File Notes</a>', file = outfilename)
	HTML('<a href="#File Description">File Description</a>', file = outfilename)
	HTML('<a href="#Variable Descriptions">Variable Descriptions</a>', file = outfilename)
	HTML('<a href="#Study Abstract">Study Abstract</a>', file = outfilename)
	HTML('<a href="#Study Description">Study Description</a>', file = outfilename)
	HTML('<a href="#Download metadata documents">Download metadata documents</a>', file = outfilename)
	
	HTML(as.title("<a name='File Notes'>File Notes</a>"), append = T,file=outfilename)
	fnotes=data.frame(ifelse(fileDscrJ$NOTES=='','NONE',strsplit(fileDscrJ$NOTES,'\n')))
	names(fnotes)='FILE NOTES'
	HTML(fnotes,file=outfilename,align='left',row.names=F)
	
	
	HTML(as.title("<a name='File Description'>File Description</a>"), append = T,file=outfilename)
	fileDscrJ=fileDscrJ[,-grep('NOTES',names(fileDscrJ))]
	# filedet=data.frame(na.omit(t(fileDscrJ[,-grep('PROCSTAT',names(fileDscrJ))])))
	filedet=data.frame(na.omit(t(fileDscrJ)))
	names(filedet)=c('file_details')
	filedet$ddi_element=row.names(filedet)
	filedet=sqldf("select * from filedet where file_details not like ''",drv='SQLite')
	HTML(filedet[,c(2,1)],append=T,file=outfilename,align='left',innerBorder=1)

	if(nrow(dataDscr)>0) {
	HTML(as.title("<a name='Variable Descriptions'>Variable Descriptions</a>"), append = T,file=outfilename)
	HTML(dataDscr[,1:ncol(dataDscr)],innerBorder=1,append=T,file=outfilename,align='left')
	}
	
	if(!is.na(addMap)){
	#if(exists
	HTML(as.title("Map"), append = T,file=outfilename)
	HTMLInsertGraph(GraphFileName=addMap,append=T,file=outfilename,Align='left')
	}
	
	HTML(as.title("<a name='Study Abstract'>Study Abstract</a>"), append = T,file=outfilename)
	
	abst=data.frame(strsplit(stdyDscr$ABSTRACT,'\n'))
	names(abst)='abstract'
	HTML(abst,file=outfilename,align='left',row.names=F)
		
	HTML(as.title("<a name='Study Description'>Study Description</a>"), append = T,file=outfilename)
	stdydet=data.frame(na.omit(t(stdyDscr[,-grep('ABSTRACT',names(stdyDscr))])))
	names(stdydet)='study_details'
	row.names(stdydet)=gsub('PRODUCER','producer_metadata',row.names(stdydet))
	row.names(stdydet)=gsub('PRODDATEDOC','production_date_metadata',row.names(stdydet))
	row.names(stdydet)=gsub('AUTHENTY','authoring_entity_of_data',row.names(stdydet))
	row.names(stdydet)=gsub('DISTRBTR','contact',row.names(stdydet))
	row.names(stdydet)=gsub('BIBLCITSTDY','bibliographic_citation',row.names(stdydet))
	stdydet$ddi_element=row.names(stdydet)
	stdydet=sqldf("select * from stdydet where study_details not like ''",drv='SQLite')
	HTML(stdydet[,c(2,1)],append=T,file=outfilename,align='left',innerBorder=1)
	
	HTML(as.title("<a name='Download metadata documents'>Download metadata documents</a>"), append = T,file=outfilename)
	HTML(paste('<a href="http://alliance.anu.edu.au/access/content/group/bf77d6fc-d1e1-401c-806a-25fbe06a82d0/ddiindex-nceph/',fileDscrJ$IDNO,'_',fileDscrJ$FILEID,'.html"> Available as html</a>',sep=''), file = outfilename)
	HTML(paste('<a href="http://alliance.anu.edu.au/access/content/group/bf77d6fc-d1e1-401c-806a-25fbe06a82d0/ddiindex-nceph/',fileDscrJ$IDNO,'_',fileDscrJ$FILEID,'.xml"> Available as xml</a>',sep=''), file = outfilename)
		
	detach(stdyDscr)
	detach(fileDscrJ)
	}
	
return(ddi)
}

##############
# newnode xml
#for(k in 1:nrow(idnos)){
# print(idnos[k])
make_xml <- function(s,f,d){
abbreviation=toupper('ecoregions_hutchclass')
print(abbreviation) 
# get study data
stdyDscr=s
head(t(stdyDscr))
tail(t(stdyDscr))

# get othrstdymat
# othrstdymat <- sqlQuery(ch,
# sprintf("
# select t1.titl, t2.*
# from stdyDscr t1
# join othrstdymat t2
# on t1.idno=t2.idno
# where t1.idno='%s'
# ",abbreviation)
# ,stringsAsFactor=F)

# if(nrow(othrstdymat)>0){
# stdyDscr$ABSTRACT <- paste(stdyDscr$ABSTRACT,
# '\n\nRELATED MATERIAL:\n',
# paste(othrstdymat$RELPUBL[!is.na(othrstdymat$RELPUBL)],collapse='\n ',sep=''),
# '\n\nRELATED NCEPH STUDIES:\n',
# paste(othrstdymat$RELSTDYID[!is.na(othrstdymat$RELSTDYID)],collapse='\n ',sep='')
# ,sep='')
# }
# cat(stdyDscr$ABSTRACT)

# TASK if files then 'http://alliance.anu.edu.au/access/content/group/bf77d6fc-d1e1-401c-806a-25fbe06a82d0/ddiindex-nceph/',tolower(abbreviation),'_',fileid,'.html'

# get file data
 fileDscr=f

head(fileDscr)
fileDscr[,1:4]


if(nrow(fileDscr)==0){
fileDscr=data.frame(t(c(1,abbreviation,stdyDscr$TITL,'Metadata','','','','','','NCEPH','NCEPH Restricted','','','','')),stringsAsFactors =F)
names(fileDscr) = c('FILEID','IDNO','FILENAME','FILETYPE','PROCSTAT','SPECPERMFILE','DATEARCHIVED','DATEDESTROY','FILEDSCR','FILELOCATION','NOTES','REQID','PUBLISHDDI','BACKUPVALID','DATEBACKUPVALID')
} 
# get variable details

#for(j in 1:nrow(fileDscr)){
j=1
fileDscrJ= fileDscr[j,]
names(fileDscrJ)=toupper(names(fileDscrJ))
filej=fileDscr[j,1]
filej
dataDscr=d
head(dataDscr)
dataDscr$PKEY <- seq(1:nrow(dataDscr))
dataDscr<- dataDscr[,c(5,1:4)]
#V1="V1"
#vardesc1="variable description stuff"
#varlabels1="theNameOfTheVariable"
if(nrow(dataDscr)==0) {
variablesList=paste("<var ID='V1' name ='",fileDscrJ$FILENAME,"'>
	<location></location>
	<labl>
	  <![CDATA[
		",fileDscrJ$NOTES,"
	  ]]>
	</labl>
	<qstn></qstn>
	<qstnLit></qstnLit>
	<invalrng></invalrng>
	<range></range>
	<item></item>
	<notes></notes>
	<universe></universe>
	<sumStat></sumStat>
	<txt></txt>
	<catgryGrp></catgryGrp>
	<labl></labl>
	<catStat></catStat>
	<catgry></catgry>
	<catValu></catValu>
	<labl></labl>
	<txt></txt>
	<catStat></catStat>
	<concept></concept>
	<derivation></derivation>
	<drvdesc></drvdesc>
	<varFormat></varFormat>
	<notes>
	  <![CDATA[
		",fileDscrJ$NOTES,"		
	  ]]>
	</notes>
	</var>",sep=""
	)
} else {

	for(i in 1:nrow(dataDscr)){

	#i=2
	if (i == 1) {
	variablesList=paste("<var ID='V",i,"' name ='",dataDscr[i,2],"'>
	<location></location>
	<labl>
	  <![CDATA[
		",dataDscr[i,3],"
	  ]]>
	</labl>
	<qstn></qstn>
	<qstnLit></qstnLit>
	<invalrng></invalrng>
	<range></range>
	<item></item>
	<notes></notes>
	<universe></universe>
	<sumStat></sumStat>
	<txt></txt>
	<catgryGrp></catgryGrp>
	<labl></labl>
	<catStat></catStat>
	<catgry></catgry>
	<catValu></catValu>
	<labl></labl>
	<txt></txt>
	<catStat></catStat>
	<concept></concept>
	<derivation></derivation>
	<drvdesc></drvdesc>
	<varFormat></varFormat>
	<notes>
	  <![CDATA[
		",dataDscr[i,3],"
	  ]]>
	</notes>
	</var>",sep=""
	)
	} 
	else {
	variablesList=rbind(variablesList,
	paste("<var ID='V",i,"' name ='",dataDscr[i,2],"'>
	<location></location>
	<labl>
	  <![CDATA[
		",dataDscr[i,3],"
	  ]]>
	</labl>
	<qstn></qstn>
	<qstnLit></qstnLit>
	<invalrng></invalrng>
	<range></range>
	<item></item>
	<notes></notes>
	<universe></universe>
	<sumStat></sumStat>
	<txt></txt>
	<catgryGrp></catgryGrp>
	<labl></labl>
	<catStat></catStat>
	<catgry></catgry>
	<catValu></catValu>
	<labl></labl>
	<txt></txt>
	<catStat></catStat>
	<concept></concept>
	<derivation></derivation>
	<drvdesc></drvdesc>
	<varFormat></varFormat>
	<notes>
	  <![CDATA[
		",dataDscr[i,3],"
	  ]]>
	</notes>
	</var>",sep=""))
	}
	}
	cat(variablesList)
}

# get keywords
keywords=abbreviation

keywords=c(keywords,
unlist(strsplit(dataDscr$LABL,"_")),
unlist(strsplit(fileDscrJ$FILENAME,"_"))
)

keywords=data.frame(toupper(keywords))
names(keywords)='keywords'
keywords=sqldf('select distinct keywords from keywords')

for(i in 1:nrow(keywords)){
#i=2
if (i == 1) {
keywordslist=paste("<keyword>
  <![CDATA[  
    ",keywords[i,1],"
  ]]>
</keyword>",sep="")
} else {
keywordslist=rbind(keywordslist,
paste("<keyword>
  <![CDATA[  
    ",keywords[i,1],"
  ]]>
</keyword>",sep="")
)
}
}
cat(keywordslist)

#################################################################################
# save to an xml

names(stdyDscr)=tolower(names(stdyDscr))
attach(stdyDscr)
names(fileDscr)=tolower(names(fileDscr))
names(fileDscrJ)=tolower(names(fileDscrJ))
attach(fileDscrJ)




xml=paste("
<codeBook version=\"1.2.2\" ID=\"",tolower(abbreviation),"_",fileDscrJ$fileid,"\">
  <docDscr>
    <citation>
      <titlStmt>
        <titl>
          <![CDATA[  
",paste(toupper(abbreviation),filename,sep='_'),"
          ]]> 
        </titl>
        <IDNo>
          <![CDATA[  
",tolower(abbreviation),"_",fileDscrJ$fileid,"
          ]]> 
        </IDNo>
      </titlStmt>
      <prodStmt>
        <producer>
          <![CDATA[  
",producer,"
          ]]>
        </producer>
        <copyright>
          <![CDATA[  
",copyright,"
          ]]>
        </copyright>
        <prodDate date='",as.Date(proddatedoc,'%d/%M/%Y'),"'>'",as.Date(proddatedoc,'%d/%M/%Y'),"'
        </prodDate>
        <software></software>
      </prodStmt>
      <verStmt>
        <version></version>
        <notes></notes>
      </verStmt>
      <biblCit>
          <![CDATA[  
",biblcitdoc,"
          ]]>
      </biblCit>
    </citation>
    <notes></notes>
  </docDscr>
  <stdyDscr >
    <citation >
      <titlStmt>
        <titl>
          <![CDATA[  
",paste(toupper(abbreviation),filename,sep='_'),"
          ]]>
        </titl>
        <IDNo>
          <![CDATA[  
",tolower(abbreviation),"_",fileDscrJ$fileid,"
          ]]>
        </IDNo>
      </titlStmt>
      <rspStmt>
        <AuthEnty>
          <![CDATA[  
",authenty,"
          ]]>
        </AuthEnty>
        <othId></othId>
      </rspStmt>
      <prodStmt>
        <producer></producer>
        <copyright>
          <![CDATA[  
",copyright,"
          ]]>
        </copyright>
        <prodDate>
          <![CDATA[  
",proddatestdy,"
          ]]>
        </prodDate>
        <fundAg>
          <![CDATA[  
",fundag,"
          ]]>          
        </fundAg>
      </prodStmt>
      <distStmt>
        <distrbtr>
          <![CDATA[  
",distrbtr,"
          ]]>  
        </distrbtr>
        <contact>
          <![CDATA[  
",distrbtr,"
          ]]>  
        </contact>
        <distDate></distDate>
      </distStmt>
      <serStmt>
        <serName>
          <![CDATA[  
",sername,"
          ]]>  
        </serName>
      </serStmt>
      <verStmt>
        <version>
          <![CDATA[  
",version,"
          ]]>  
        </version>
        <notes></notes>
      </verStmt>
      <biblCit>
        <![CDATA[  
",biblcitstdy,"
          ]]>  
      </biblCit>
    </citation >
    <stdyInfo>
    <subject>
",paste(t(keywordslist),collapse="\n"),"
      <topcClas>
          <![CDATA[ 
",stdyDscr$notes," 
          ]]> 
        </topcClas>
        <topcClas>
          <![CDATA[  
",titl,"
          ]]> 
        </topcClas>
      </subject>
    <abstract>
       <![CDATA[
",

paste("\n\nSTUDY TITLE:\n",titl,
"\n\nFILE DESCRIPTION:\n",fileDscr$filetype[j],"\n",fileDscr$filedscr[j],"\n",fileDscr$notes[j],
paste("\nMETADATA DOCUMENTS:
 http://alliance.anu.edu.au/access/content/group/bf77d6fc-d1e1-401c-806a-25fbe06a82d0/ddiindex-nceph/",fileDscrJ$idno,'_',fileDscrJ$fileid,'.html (and xml)',sep=''),
"\n\nSTUDY DESCRIPTION:\n",abstract,sep="",collapse="\n")

,"
        ]]>
      </abstract>
      <sumDscr>
        <timePrd>
          <![CDATA[
",timeprd,"           
          ]]> 
        </timePrd>
        <collDate>
          <![CDATA[
 ",colldate," 
         ]]>
        </collDate>
        <nation></nation>
        <geogCover>
          <![CDATA[
",geogcover,"        
 ]]>
        </geogCover>
        <geogUnit>
          <![CDATA[
",geogunit," 
        ]]> 
          </geogUnit>
        <anlyUnit>
          <![CDATA[
",anlyunit,"
         ]]> 
          </anlyUnit>
        <universe>
          <![CDATA[
",universe,"
         ]]> 
        </universe>
        <dataKind>
          <![CDATA[
",datakind,"
]]>
        </dataKind>
      </sumDscr>
      <notes></notes>
    </stdyInfo>
    <method>
      <dataColl>
      <timeMeth></timeMeth>
      <dataCollector></dataCollector>
      <sampProc></sampProc>
      <collMode></collMode>
      <sources></sources>
      <weight></weight>
      <cleanOps>
        <![CDATA[
",cleanops,"
        ]]>
      </cleanOps>
      </dataColl>
      <notes></notes>
    </method>
    <dataAccs>
      <setAvail>
        <collSize></collSize>
        <fileQnty></fileQnty>
      </setAvail>
      <useStmt>
        <confDec>
          <![CDATA[
",confdec,"
          ]]>
        </confDec>
        <specPerm>
          <![CDATA[
",paste("STUDY PERMISSIONS:\n",specperm,"\nFILE PERMISSIONS:\n",fileDscrJ$specpermfile,sep=""),"
          ]]>
        </specPerm>
        <restrctn></restrctn>
      </useStmt>
    </dataAccs>
    <notes>
      <![CDATA[
",notes," 
      ]]>
    </notes>
  </stdyDscr >
  <fileDscr>
    <fileTxt>
    <fileName>
      <![CDATA[
",paste(tolower(abbreviation),filename,sep='_'),"
      ]]>
    </fileName>
    <dimensns>
      <caseQnty></caseQnty>
      <varQnty></varQnty>
      <logRecL></logRecL>
      <recPrCas></recPrCas>
    </dimensns>
    <fileType>
      <![CDATA[
",filetype,"
      ]]>
    </fileType>
      <ProcStat>
        <![CDATA[
",'processing description suppressed',"
        ]]>
      </ProcStat>
    </fileTxt>
    <notes>
      <![CDATA[
",notes," 
      ]]>
    </notes>
  </fileDscr>
  <dataDscr>
    <varGrp></varGrp>
    <labl></labl>
    <notes></notes>
 ",paste(t(variablesList),collapse="\n"),"
  </dataDscr>
</codeBook>
",sep="")
#    ",paste(t(othermatlist),collapse="\n"),"
detach(stdyDscr)
detach(fileDscrJ)

cat(xml)
outdir <- getwd()
write.table(xml,sprintf("%s/%s%s%s.xml",outdir,tolower(abbreviation),"_",fileDscrJ$fileid),row.names=F,col.names=F,quote=F)

}


#############################################################
# newnode load to oracle unconnected
inserts <- function(){
cat(
'
insert into ivan.stdydscr ("TITL", "IDNO", "PRODUCER", "PRODDATEDOC", "BIBLCITDOC", "AUTHENTY", "COPYRIGHT", "PRODDATESTDY", "FUNDAG", "DISTRBTR", "SERNAME", "VERSION", "BIBLCITSTDY", "TIMEPRD", "COLLDATE", "GEOGCOVER", "GEOGUNIT", "ANLYUNIT", "UNIVERSE", "DATAKIND", "CLEANOPS", "CONFDEC", "SPECPERM", "RESTRCTN", "NOTES", "ABSTRACT")
select TITL, IDNO, PRODUCER, to_date(PRODDATEDOC), BIBLCITDOC, AUTHENTY, COPYRIGHT, to_date(PRODDATESTDY), FUNDAG, DISTRBTR, SERNAME, VERSION, BIBLCITSTDY, TIMEPRD, COLLDATE, GEOGCOVER, GEOGUNIT, ANLYUNIT, UNIVERSE, DATAKIND, CLEANOPS, CONFDEC, SPECPERM, RESTRCTN, NOTES, ABSTRACT from nustdy;

drop table nustdy;

drop sequence nustdy_seq;

insert into ivan.filedscr ("IDNO", "FILENAME", "FILETYPE", "PROCSTAT", "SPECPERMFILE", "DATEARCHIVED", "DATEDESTROY", "FILEDSCR", "NOTES", "REQID", "PUBLISHDDI", "BACKUPVALID", "DATEBACKUPVALID", "CHECKED", "BACKUPLOCATION", "FILEID", "FILELOCATION")
select IDNO, FILENAME, FILETYPE, PROCSTAT, SPECPERMFILE, to_date(DATEARCHIVED), DATEDESTROY, FILEDSCR, NOTES, REQID, PUBLISHDDI, BACKUPVALID, to_date(DATEBACKUPVALID), CHECKED, BACKUPLOCATION, FILEID, FILELOCATION from nufiles;

drop table nufiles;

drop sequence nufiles_seq;

# NOW NEED TO IDENTIFY ID NUMBERS
SELECT IDNO, min(FILEID), max(FILEID) FROM FILEDSCR WHERE IDNO = \'{stdy}\'
# FILEIDS ARE 
minfileid <- 2962
maxfileid <- 2965
fileids <- seq(minfileid,maxfileid)

datarows <- read.csv(dir(\'metadata\',full.names=T)[grep("ddi_datadscr.csv",dir(\'metadata\',full.names=T))])
names(table(datarows$FILEID))
for(i in 1:length(names(table(datarows$FILEID)))){
rows <- names(table(datarows$FILEID))[i]
fid<-fileids[i]
cat(paste(\'insert into ivan.datadscr (\"\',
paste(names(read.csv(dir(\'metadata\',full.names=T)[grep("ddi_datadscr.csv",dir(\'metadata\',full.names=T))])),sep=\'\',collapse=\'\", \"\'),
\'\")
select \',
gsub(\'FILEID\',fid,paste(names(read.csv(dir(\'metadata\',full.names=T)[grep("ddi_datadscr.csv",dir(\'metadata\',full.names=T))])),sep=\'\',collapse=\', \')),
\' from nudata
WHERE FILEID = \',rows,\';\n\',
sep=\'\')
)
}

drop table nudata;

drop sequence nudata_seq;

')

}

###################################################3
