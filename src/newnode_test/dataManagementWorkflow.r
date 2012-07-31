source('src/newnode.r')
nodes <- newnode(name = 'aquire the raw data', 
                 inputs = c('external sources','collected by researcher'),
                 outputs = c('file server','metadata database','cleaning'), newgraph=T)

nodes <- newnode(name = 'database server', 
                 inputs = 'file server', 
                 outputs = c('metadata database'))

nodes <- newnode(name = 'search engine web server', inputs ='metadata database', 
                 outputs = NA)


nodes <- newnode(name = 'calculate new data', inputs = 'database server', 
                 outputs = c('analyse using stats package','database server', 'metadata database'))

nodes <- newnode(name = 'analyse using stats package', 
                 inputs = c('aquire the raw data','database server','simulation', 
                            'file server'), 
                 outputs = c('results', 'metadata database'))
# I want to feedback to database
nodes <- addEdge(from='analyse using stats package',
                 to='database server',graph=nodes,weights=1)

nodes <- newnode(name = 'communicate the results', inputs ='results', 
                 outputs = c('technical documentation','journal publication'))
nodes <- newnode(name = 'archive at end of project', inputs ='journal publication', 
                 outputs = c('repurposed data','file server', 'destroy'))


#plot(nodes,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))
#dev.off()
