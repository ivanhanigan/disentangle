% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/big_pt_intersect.r
\name{big_pt_intersect}
\alias{big_pt_intersect}
\title{big points intersect}
\usage{
big_pt_intersect(pts, ply, chunks = 100)
}
\arguments{
\item{pts}{a points spatial}

\item{ply}{a polygons spatial}

\item{chunks}{how many to split into}
}
\value{
a combined data frame that avoids run out of memory with big points file
}
\description{
big points intersect
}

