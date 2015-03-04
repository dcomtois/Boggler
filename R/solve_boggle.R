Solve.Boggle <- function(bog.letters = NA, n.letters = 3:11) {

  base.dir <- find.package("Boggler")

  load(file = paste(base.dir, "includes/dict_fr.RData", sep="/"))
  load(file = paste(base.dir, "includes/paths_by_length.RData", sep="/"))
  #sourceCpp(file = paste(base.dir, "includes/cpp_str_split.cpp", sep="/"))

  if(any(is.na(bog.letters))) {
    message("Entrer les 16 lettres (4 lettres par ligne ou toutes les lettres sur la 1\u00e8re ligne):")
    bog.letters <- tolower(strsplit(paste(scan(file = "", what = "character", nlines = 4),collapse=""),split = "")[[1]])
  } else if(length(bog.letters) == 1 && nchar(bog.letters) == 16) {
      bog.letters <- tolower(strsplit(paste(bog.letters, sep = ""), split = "")[[1]])
  } else if(length(bog.letters) != 16 || any(mapply(nchar, bog.letters)!=1)) {
      stop("le nombre de lettres doit \u00eatre \u00e9gal \u00e0 16, r\u00e9unis dans une seule cha\u00eene de caract\u00e8res, ou un vecteur de caract\u00e8res uniques de taille 16")
  }


  # Plot the board
  # http://www.r-bloggers.com/going-viral-with-rs-igraph-package/
  # http://lists.nongnu.org/archive/html/igraph-help/2007-07/msg00011.html
  boggle.graph <- graph.lattice(length = c(4,4), dim = 1, directed = FALSE)
  plot(boggle.graph,
       layout = layout.grid,
       vertex.label=toupper(bog.letters[c(13:16,9:12,5:8,1:4)]),
       vertex.size = 60,
       vertex.shape = "square",
       vertex.color="white",
       vertex.frame.color= "black",
       vertex.label.color = "black",
       vertex.label.family = "sans",
       #edge.label.family="Palatino",
       vertex.label.cex=3,
       #edge.width=2,
       edge.color="white")

  last.search.empty = FALSE
  find.words <- function(n.letters) {
    paths <- t(as.matrix(paths.by.length[[n.letters - 2]]))
    longstring <- stri_c(bog.letters[paths], collapse="")
    candidates <- cpp_str_split(longstring, n.letters)[[1]]
    # candidates <- apply(X = paths, MARGIN = 1, FUN = function(x) stri_c(bog.letters[x], collapse=""))
    dict.words <- dict.fr$mot[dict.fr$taille == n.letters]
    words <- intersect(candidates, dict.words)
    message(n.letters, " ... (", length(words), ")")
    return(words)
  }

  all.words <- character(0)
  for(i in n.letters) {
    words.tmp <- find.words(i)
    if(length(words.tmp) == 0) {
      break
    } else {
      all.words <- c(all.words, words.tmp)
    }
  }

  return(all.words)
}
