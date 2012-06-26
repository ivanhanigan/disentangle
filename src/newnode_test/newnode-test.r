
source('src/newnode.r')
rEG <- newnode(dsc = 'stations', i = 'web', o = 'Clean Weather Data', append=F)
rEG <- newnode(dsc = 'observations', i = 'database', o = 'Clean Weather Data')
rEG <- newnode(dsc = 'clean', i = 'abs', o = 'outcome')
rEG <- newnode(dsc = 'outcome', i = 'Clean Weather Data', o = 'join')
rEG <- newnode(dsc = 'epxosure', i ='flu', o = 'join')
rEG <- newnode(dsc = 'other', i =c('aihw','state','abs'), o = 'join')
rEG <- newnode(dsc = 'hospitalFlu', i ='state', o ='flu')
rEG <- newnode(dsc = 'DeathsFlu', i ='abs', o ='flu')
rEG <- newnode(dsc = 'pops', i ='abs', o ='join')
rEG <- newnode(dsc = 'seifa', i ='abs', o ='epxosure')

rEG <- newnode(dsc = 'radha', i ='newinput', o ='DeathsFlu')
rEG <- newnode(dsc = 'radha', i ='newinput2', o ='outcome')
rEG <- newnode(dsc = 'radha', i ='newinput3', o ='newinput2')
rEG <- addEdge(from='newinput2',to='newinput3',graph=rEG,weights=1)
rEG <- addEdge(from='radha',to='pops',graph=rEG,weights=1)


dev.off()
plot(rEG,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))

# dev.off()