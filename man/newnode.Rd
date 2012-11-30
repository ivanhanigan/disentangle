\name{newnode}
\alias{newnode}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{new node
%%  ~~function to do ... ~~
}
\description{adds to a graphviz graph
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newnode(name, inputs = NA, outputs = NA, graph = "nodes", newgraph = F, notes = F, code = NA, ttype = NA, plot = T)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{name}{
%%     ~~Describe \code{name} here~~
}
  \item{inputs}{
%%     ~~Describe \code{inputs} here~~
}
  \item{outputs}{
%%     ~~Describe \code{outputs} here~~
}
  \item{graph}{
%%     ~~Describe \code{graph} here~~
}
  \item{newgraph}{
%%     ~~Describe \code{newgraph} here~~
}
  \item{notes}{
%%     ~~Describe \code{notes} here~~
}
  \item{code}{
%%     ~~Describe \code{code} here~~
}
  \item{ttype}{
%%     ~~Describe \code{ttype} here~~
}
  \item{plot}{
%%     ~~Describe \code{plot} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
require(disentangle)
nodes <- newnode(name = 'aquire the raw data',
                 inputs = c('plan', 'external sources',
                   'collected by researcher'),
                 outputs = 'cleaning',
                 newgraph=T)

nodes <- newnode(name = 'file server',
                 inputs = 'cleaning'
                 )

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

#dev.copy2pdf(file='transformations_overview.pdf')
#dev.off();                 

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
