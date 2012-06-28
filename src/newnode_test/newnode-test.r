
source('src/newnode.r')
rEG <- newnode(name = 'stations', inputs = 'web', outputs = 'Clean Weather Data', append=F)
rEG <- newnode(name = 'observations', inputs = 'database', outputs = 'Clean Weather Data')
rEG <- newnode(name = 'clean', inputs = 'abs', outputs = 'outcome')
rEG <- newnode(name = 'outcome', inputs = 'Clean Weather Data', outputs = 'join')
rEG <- newnode(name = 'epxosure', inputs ='flu', outputs = 'join')
rEG <- newnode(name = 'other', inputs =c('aihw','state','abs'), outputs = 'join')
rEG <- newnode(name = 'hospitalFlu', inputs ='state', outputs ='flu')
rEG <- newnode(name = 'DeathsFlu', inputs ='abs', outputs ='flu')
rEG <- newnode(name = 'pops', inputs ='abs', outputs ='join')
rEG <- newnode(name = 'seifa', inputs ='abs', outputs ='epxosure')

rEG <- newnode(name = 'radha', inputs ='newinput', outputs ='DeathsFlu')
rEG <- newnode(name = 'radha', inputs ='newinput2', outputs ='outcome')
rEG <- newnode(name = 'radha', inputs ='newinput3', outputs ='newinput2')
rEG <- addEdge(from='newinput2',to='newinput3',graph=rEG,weights=1)
rEG <- addEdge(from='radha',to='pops',graph=rEG,weights=1)


dev.off()
plot(rEG,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))

# dev.off()