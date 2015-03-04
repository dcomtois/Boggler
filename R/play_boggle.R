Play.Boggle <- function(shuffle.mode = "obs", time.limit = 120) {

  if(time.limit < 10) {
    stop("le temps limite ne peut \u00eatre de moins de 10 secondes")
  }

  base.dir <- find.package("Boggler")

  message("Chargement des fonctions...")

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


  # Find solutions
  message("Veuillez patienter pendant la recherche des solutions...")
  solutions <- Solve.Boggle(bog.letters)

  # Prepare responses dataframe
  reponses <- data.frame(mot=character(), pts=numeric(), stringsAsFactors = FALSE)
  time.start <- Sys.time()

  shell(cmd = sprintf('Rscript.exe R/progress_bar.R "%i"', time.limit + 1), wait=FALSE)

  repeat {

    time.diff <- Sys.time()-time.start
    units(time.diff) <- "secs"

    if(time.diff > time.limit)
      break

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

    if(word %in% solutions$mot && !word %in% reponses$mot) {
      reponses <- rbind(reponses, solutions[which(solutions$mot==word),])
      message("+", tail(reponses$pts,1), "pt(s) (temps restant: ", round(time.limit - time.diff), " secs)")

    } else {
      message("Mot non valide ou d\u00e9j\u00e0 entr\u00e9 (temps restant: ", round(time.limit - time.diff), " secs)")
    }
  }

  message("\nTotal: ", sum(reponses$pts), " points!")
  message(sprintf("\nMaximum possible : %i (solutions cherch\u00e9es jusqu'\u00e0 %i lettres)",
                  sum(solutions$pts), nchar(tail(solutions$mot,1)) + 1 ))
  return(invisible(list(reponses=reponses, solutions=solutions)))
}
