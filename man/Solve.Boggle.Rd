\name{Solve.Boggle}
\alias{Solve.Boggle}
\title{Find all valid words in a Boggle game}
\description{Finds all valid words from 3 to 16 letters and reports them along with the maximum possible score.}
\usage{
Solve.Boggle(bog.letters = NA, lang = "fr", n.letters = 3:16)
}
\arguments{
  \item{bog.letters}{The 16 letters to be checked for. If not provided, the user will be asked to enter them.}
  \item{lang}{Language of the game; one of "fr" (default), "en" and "fi"}
  \item{n.letters}{Vector indicating the lengths of words to look for. Defaults to 3:11.}
}
\references{\url{https://github.com/dcomtois/Boggler}}
\author{Dominic Comtois <dominic.comtois@gmail.com>}
\keyword{Boggle}
\keyword{games}
