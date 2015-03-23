Solve.Boggle <- function(bog.letters = NA, lang = "fr", n.letters = 3:16) {

  if(any(is.na(bog.letters))) {
    if(lang == "fr")
      message("Entrer les 16 lettres (4 lettres par ligne ou toutes les lettres sur la 1\u00e8re ligne):")
    else if(lang == "en")
      message("Enter the 16 letters (4 per line or all on same line:")
    bog.letters <- tolower(strsplit(paste(scan(file = "", what = "character", nlines = 4),collapse=""),split = "")[[1]])
  } else if(length(bog.letters) == 1 && nchar(bog.letters) == 16) {
      bog.letters <- tolower(strsplit(paste(bog.letters, sep = ""), split = "")[[1]])
  } else if(length(bog.letters) != 16 || any(mapply(nchar, bog.letters)!=1)) {
    if(lang == "fr")
      stop("le nombre de lettres doit \u00eatre \u00e9gal \u00e0 16, r\u00e9unis dans une seule cha\u00eene de caract\u00e8res, ou un vecteur de caract\u00e8res uniques de taille 16")
    else if(lang == "en")
      stop("number of letters must equal 16, either as a sole string or as a vector of unique characters")
  }

  base.dir <- find.package("Boggler")

  load(file = paste(base.dir, "includes/paths_by_length.RData", sep="/"))
  if(lang == "fr")
    load(file = paste(base.dir, "includes/dict_fr.RData", sep="/"))
  else if(lang == "en")
    load(file = paste(base.dir, "includes/dict_en.RData", sep="/"))

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

    calc.points <- function(word) {
    switch(EXPR = as.character(nchar(word)), "3"=1, "4"=1, "5"=2,
           "6"=3, "7"=5, "8"=11, "9"=20, "10"=50, "11"=100, "12"=150,
           "13"=200, "14"=250, "15"=250, "16"=250)
  }


  find.words <- function(n.letters) {
    paths <- t(as.matrix(paths.by.length[[n.letters - 2]]))
    longstring <- stri_c(bog.letters[paths], collapse="")
    candidates <- cpp_str_split(longstring, n.letters)[[1]]
    dict.words <- dict$word[dict$length == n.letters]
    words <- intersect(candidates, dict.words)
    message(n.letters, " ... (", length(words), ")")
    return(words)
  }

  all.words <- character(0)
  for(i in n.letters) {
    words <- find.words(i)
    if(length(words) == 0) {
      break
    } else {
      all.words <- c(all.words, words)
    }
  }

  if(lang=="fr")
    solutions <- data.frame(mots = all.words, pts = sapply(all.words, calc.points), stringsAsFactors = FALSE)
  else
    solutions <- data.frame(word = all.words, pts = sapply(all.words, calc.points), stringsAsFactors = FALSE)

  solutions <- solutions[order(solutions[[2]],solutions[[1]]),]
  rownames(solutions) <- NULL
  return(solutions)

}
