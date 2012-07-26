source('src/newnode.r')
nodes <- newnode(name = 'aquire the raw data', 
                 inputs = c('external sources','collected by researcher'),
                 outputs = c('file server','metadata'), append=F)

nodes <- newnode(name = 'cleaning and importing to database server', 
                 inputs = 'file server', outputs = c('database server', 'metadata'))
nodes <- addEdge(from='cleaning and importing to database server',to='metadata',graph=nodes,weights=1)

nodes <- newnode(name = 'calculate new data', inputs = 'database server', 
                 outputs = c('new data in database server', 'metadata'))
nodes <- addEdge(from='calculate new data',to='metadata',graph=nodes,weights=1)

nodes <- newnode(name = 'analyse using stats package', inputs = c('aquire the raw data','new data in database server','simulation', 'file server'), 
                 outputs = c('results', 'metadata'))
nodes <- addEdge(from='analyse using stats package',to='new data in database server',graph=nodes,weights=1)
#nodes <- addEdge(from='analyse using stats package',to='metadata',graph=nodes,weights=1)


nodes <- newnode(name = 'manage metadata', inputs ='metadata', outputs = 'metadata database')
nodes <- newnode(name = 'manage metadata', inputs ='metadata', outputs = 'metadata in web server')

nodes <- newnode(name = 'communicate the results', inputs ='results', 
                 outputs = 'technical documentation')
nodes <- newnode(name = 'communicate the results', inputs ='results', 
                 outputs = 'journal publication')
nodes <- newnode(name = 'archive at end of project', inputs ='journal publication', 
                 outputs = 'repurposed data')
nodes <- addEdge(from = 'archive at end of project', to ='file server',graph=nodes,weights=1)
nodes <- addEdge(from = 'repurposed data', to ='database server',graph=nodes,weights=1)

nodes <- newnode(name = 'archive at end of project',  inputs ='journal publication', 
                 outputs = 'destroy')

dev.off()
plot(nodes,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))

# dev.off()