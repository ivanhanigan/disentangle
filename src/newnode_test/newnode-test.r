
source('src/newnode.r')
rEG <- newnode(dsc = 'stations', i = 'web', o = 'Clean Weather Data', append=F)
rEG <- newnode(dsc = 'observations', i = 'database', o = 'Clean Weather Data')
rEG <- newnode(dsc = 'clean', i = 'abs', o = 'outcome')
rEG <- newnode(dsc = 'outcome', i = 'Clean Weather Data', o = 'join')
rEG <- newnode(dsc = 'epxosure', i ='flu', o = 'join')
rEG <- newnode(dsc = 'other', i =c('aihw','state','abs'), o = 'join')

dev.off()
plot(rEG,attrs=list(node=list(label="foo", fillcolor="grey",shape="ellipse", fixedsize=FALSE), edge=list(color="black")))

# dev.off()