
source('src/newnode.r')
nodes <- newnode(name = 'stations', inputs = c('asdf','web'), outputs = c('ddd','Clean Weather Data'), append=F)
nodes <- newnode(name = 'observations', inputs = 'database', outputs = 'Clean Weather Data')
nodes <- newnode(name = 'clean', inputs = 'abs', outputs = 'outcome')
nodes <- newnode(name = 'outcome', inputs = 'Clean Weather Data', outputs = 'join')
nodes <- newnode(name = 'epxosure', inputs ='flu', outputs = 'join')
nodes <- newnode(name = 'other', inputs =c('aihw','state','abs'), outputs = 'join')
nodes <- newnode(name = 'hospitalFlu', inputs ='state', outputs ='flu')
nodes <- newnode(name = 'DeathsFlu', inputs ='abs', outputs ='flu')
nodes <- newnode(name = 'pops', inputs ='abs', outputs ='join')
nodes <- newnode(name = 'seifa', inputs ='abs', outputs ='epxosure')

nodes <- newnode(name = 'radha', inputs ='newinput', outputs ='DeathsFlu')
nodes <- newnode(name = 'radha', inputs ='newinput2', outputs ='outcome')
nodes <- newnode(name = 'radha', inputs ='newinput3', outputs ='newinput2')
nodes <- addEdge(from='newinput2',to='newinput3',graph=nodes,weights=1)
nodes <- addEdge(from='radha',to='pops',graph=nodes,weights=1)


dev.off()
plot(nodes,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))

# dev.off()