
source('http://bioconductor.org/biocLite.R')
biocLite("Rgraphviz", configure.args=c("--with-graphviz=/usr"))
#the reason is that at least on my comp the dot program was in /usr/bin, but not in /usr/local/bin as Rgraphviz defaults
