Play.Boggle <- function(shuffle.mode = "obs", time.limit = 120) {

  if(time.limit < 10) {
    stop("le temps limite ne peut \u00eatre de moins de 10 secondes")
  }

  base.dir <- find.package("Boggler")

  # Read relevant RData files
  load(paste(base.dir, "includes/dict_fr.RData", sep="/"))
  load(paste(base.dir, "includes/weights_and_dice.RData", sep="/"))
  load(paste(base.dir, "includes/paths_by_length.RData", sep="/"))

  # Define functions
  shuffle <- function(shuffle.mode="obs") {
    if(shuffle.mode == "obs") {
      sample(x = letters, size = 16, replace = TRUE, prob = weights.obs$weight)
    } else if(shuffle.mode == "dice") {
      sapply(sapply(dice.fr, strsplit, ""), sample, size=1)
    } else {
      stop("Shuffle mode must be either 'obs' or 'dice'")
    }
  }

  calc.points <- function(word) {
    switch(EXPR = as.character(nchar(word)), "3"=1, "4"=1, "5"=2,
           "6"=3, "7"=5, "8"=11, "9"=20, "10"=50, "11"=100, "12"=150,
           "13"=200, "14"=250, "15"=250, "16"=250)
  }

  find.words <- function(n.letters) {
    paths <- paths.by.length[[n.letters - 2]]
    candidates <- apply(X = paths, MARGIN = 1, FUN = function(x) paste(bog.letters[x], collapse=""))
    dict.words <- dict.fr$mot[dict.fr$taille == n.letters]
    words <- intersect(candidates, dict.words)
    # message("\n", n.letters, " lettres... ")
    return(words)
  }

  # Shuffle (randomize) letters
  bog.letters <- shuffle(shuffle.mode)

  # visualize the letters
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
       vertex.label.cex=3,
       edge.width=2,
       edge.color="white")


  # Create vector that keeps track of the lengths of letters
  # for which solutions have been looked for
  # solutions having more letters will be added as needed
  solutions.nchar <- 3:6

  # Find solutions in the range (# letters) of solutions.nchar
  solutions <- as.character(unlist(lapply(solutions.nchar, find.words)))
  solutions <- data.frame(mot = solutions, pts = sapply(solutions, calc.points), stringsAsFactors = FALSE)
  rownames(solutions) <- NULL

  reponses <- data.frame(mot=character(), pts=numeric(), stringsAsFactors = FALSE)
  time.start <- Sys.time()

  # shell(cmd = sprintf('Rscript.exe R/progress_bar.R "%i"', time.limit + 1), wait=FALSE)

  repeat {

    time.diff <- Sys.time()-time.start
    units(time.diff) <- "secs"

    if(time.diff > time.limit) {

      # print(reponses$mot[order(nchar(reponses$mot))])
      message("\nTotal: ", sum(reponses$pts), " points!")
      message("\nCalcul du maximum possible... ")

      additional.words <- character(0)
      for(i in setdiff(3:16, solutions.nchar)) {
        tmp <- find.words(i)
        if(length(tmp)==0)
          break
        additional.words <- append(additional.words, tmp)
        solutions.nchar <- append(solutions.nchar, i)
      }

      solutions <- rbind(solutions, data.frame(mot=tmp, pts=sapply(tmp, calc.points)))
      rownames(solutions) <- NULL
      message(sprintf("\nMaximum possible : %i (solutions cherch\u00e9es jusqu'\u00e0 %i lettres)",
                      sum(solutions$pts), tail(solutions.nchar,1)))
      return(invisible(list(reponses=reponses, solutions=solutions)))

    }

    word <- scan(what = "character", nlines = 1, quiet = TRUE)

    time.diff <- Sys.time()-time.start
    units(time.diff) <- "secs"

    if(time.diff > time.limit) {
      message("Temps \u00e9coul\u00e9!")
      next
    }


    if(length(word) == 0) {
      message('Entrer "q" pour quitter\n')
      next
    } else if(tolower(word) == "q") {
      break
    } else if(nchar(word) < 3) {
      message("Seuls les mots de 3 lettres ou plus sont accept\u00e9s\n")
      next
    }

    if(!nchar(word) %in% solutions.nchar) {
      tmp <- as.character(unlist(find.words(nchar(word))))
      solutions <- rbind(solutions, data.frame(mot=tmp, pts=sapply(tmp, calc.points)))
      solutions.nchar <- append(solutions.nchar, nchar(word))
    }

    if(word %in% solutions$mot && !word %in% reponses$mot) {
      reponses <- rbind(reponses,solutions[which(solutions$mot==word),])
      message("+", tail(reponses$pts,1), "pt(s) (temps restant: ", round(time.limit - time.diff), " secs)")

    } else {
      message("Mot non valide ou d\u00e9j\u00e0 entr\u00e9 (temps restant: ", round(time.limit - time.diff), " secs)")
    }
  }
}
