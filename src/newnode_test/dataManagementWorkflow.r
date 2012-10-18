#setwd('~/tools/disentangle')
dir()
source('../newnode.r')
nodes <- newnode(name = 'aquire the raw data',
                 inputs = c('plan', 'external sources',
                   'collected by researcher'),
                 outputs = 'cleaning',
                 newgraph=T)

nodes <- newnode(name = 'file server',
                 inputs = 'cleaning'
                 )

#c('file server','metadata database','cleaning'),
nodes <- newnode(name = 'database server',
                 inputs = 'file server',
                 outputs = c('metadata database')
                 )

nodes <- newnode(name = 'search engine web server',
                 inputs ='metadata database',
                 outputs = NA
                 )


nodes <- newnode(name = 'calculate new data',
                 inputs = 'database server',
                 outputs =
                 c('analyse using stats package','database server',
                   'metadata database', 'technical documentation')
                 )

nodes <- newnode(name = 'analyse using stats package',
                 inputs = c('database server','simulation',
                   'file server', 'cleaning'),
                 outputs = c('results', 'metadata database',
                   'cleaning', 'technical documentation')
                 )

# I want to feedback to database
#nodes <- addEdge(from='analyse using stats package',
#                 to='database server',graph=nodes,weights=1)

nodes <- newnode(name = 'communicate the results',
                 inputs ='results',
                 outputs = c('journal publication')
                 )

nodes <- newnode(name='technical documentation',
                 inputs = c('aquire the raw data',
                   'communicate the results'),
                 outputs = 'cleaning'
                 )

nodes <- newnode(name = 'archive at end of project',
                 inputs ='journal publication',
                 outputs = c('repurposed data','file server',
                   'destroy')
                 )


#plot(nodes,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))
#dev.off()
dev.copy2pdf(file='transformations_overview.pdf')
dev.off();
