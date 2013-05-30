
################################################################
# name:oldnode2orgmode
        project = unlist(strsplit(getwd(),"/"))[length(unlist(strsplit(getwd(),"/")))]
        title = NA
        dsc=''
        ttype=dsc
        i=NA
        o=NA
        notes=''
        code=NA
        TASK=NA
        subsection=T
        nosectionheading=F
        dontshow=NA
        append=T
        document='sweave'
        insertgraph=NA
        doc_code=T
        end_doc=F
        dontshow_doc=NA
        evalCode='FALSE'
        echoCode='TRUE'
        inserttable=NA
        caption=''
        tablabel='tabx'
        digits=''
        align=''
        tabsideways=F
        clearpage=F
        KEYNODE=NA

#oldnode2orgmode(
dsc = 'Introduction'

ttype = 'reports'

title = 'HF data prep'

 dontshow = T

 notes = '
 This is the workflow diagram for the health forecasting project at NCEPH \\cite{Dear2010} which can be viewed
 \\href{http://dl.dropbox.com/u/7075452/HF_data/data_transformations.html}{at this link}.

 The relationship between daily air quality and daily hospital admissions is being examined:
 \\begin{itemize}
 \\item Three cities, Brisbane, Melbourne and Sydney
 \\item Daily for seven years, 1998 - 2004 (2,557 days)
 \\item Twelve disease clusters; both emergency admissions and all admissions; though for most analyses only emergency admissions were considered
 \\item By age and sex  (twelve groups)
 \\item By spatial subunits of each city: statistical local area (SLA) for Melbourne and Sydney and, for Brisbane, larger zones (clusters of SLAs) designed specifically for this project.
 \\end{itemize}
 In all there were 0.76 million emergency admissions in Brisbane, 1.66m in Melbourne, and 2.54m in Sydney.
 '

 append = F

 code = NA
)
