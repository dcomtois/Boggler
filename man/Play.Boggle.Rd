\name{Play.Boggle}
\alias{Play.Boggle}
\title{Play a Boggle game (in French only... for now)}
\description{Will randomize letters and display a graphical representation
  of the Boggle "board"
}
\usage{
Play.Boggle(shuffle.mode = "dice", time.limit = 120)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{shuffle.mode}{One of "obs" (default) or "dice". The "obs" option uses letter frequencies in the language as weights to the sampling process. "dice" mode replicates the original Boggle dice game.}
  \item{time.limit}{Time limit in seconds. Defaults to 120.}
}
\references{\url{https://github.com/dcomtois/Boggler}}
\author{Dominic Comtois <dominic.comtois@gmail.com>}
\keyword{ Boggle }
\keyword{ Games }
