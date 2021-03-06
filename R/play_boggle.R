Play.Boggle <- function(lang = "fr", shuffle.mode = "dice", time.limit = 120) {

  msgs <- list()
  if(lang == "fr") {
    msgs <- list(limit.err = "le temps limite ne peut \u00eatre de moins de 10 secondes",
                 charging = "chargement des fonctions",
                 mode.err = "shuffle.mode doit \u00eatre 'dice' ou 'obs'",
                 patient = "Veuillez patienter pendant la recherche des solutions",
                 time.is.up = "Temps \u00e9coul\u00e9!",
                 quit = 'Entrer "q" pour quitter\n',
                 min.letters = "Seuls les mots de 3 lettres ou plus sont accept\u00e9s\n",
                 already.entered = "Mot d\u00e9j\u00e0 entr\u00e9 (temps restant: ",
                 invalid.word = "Mot non valide (temps restant: ",
                 time.left = "temps restant: ",
                 conclusion = "\nMaximum possible : %i (solutions cherch\u00e9es jusqu'\u00e0 %i lettres)")
  }

  if(lang == "en") {
    msgs <- list(limit.err = "time limit cannot be less than 10 seconds",
                 charging = "loading functions",
                 mode.err = "Shuffle mode must be either 'obs' or 'dice'",
                 patient = "finding solutions... please wait",
                 time.is.up = "time's up!",
                 quit = 'Enter "q" to quit game\n',
                 min.letters = "Only 3 letter words or more are accepted",
                 already.entered = "Word already entered (time left: ",
                 invalid.word = "Invalid word (time left: ",
                 time.left = "time left: ",
                 conclusion = "\nMaximum score: %i (searched for solutions up to %i letters)")
  }

  if(lang == "fi") {
    msgs <- list(limit.err = "Aikarajaei voi olla alle 10 sekuntia!",
                 charging = "Ladataan funtioita...",
                 mode.err = "Arvontatavan t�ytyy olla joko 'obs' or 'dice'!",
                 patient = "Etsit��n ratkaisuja... odota...",
                 time.is.up = "Aika loppui!",
                 quit = 'Paina "q" poistuaksesi pelist�\n',
                 min.letters = "Sanojen tulee olla v�hint��n 3 merkki� pitki�!",
                 already.entered = "Tuo sana on jo l�ydetty (aikaa j�ljell�: ",
                 invalid.word = "Sanaa ei l�ydy Kotuksen sanakirjasta (aikaa j�ljell�: ",
                 time.left = "Aikaa j�ljell�: ",
                 conclusion = "\nMaksimipistem��r�: %i (etsittiin ratkaisuja %i kirjaimeen saakka)")
  }

  if(time.limit < 10) {
    stop(msgs[["limit.err"]])
  }

  base.dir <- find.package("Boggler")

  message(msgs[["charging"]])

  # Read relevant RData files
  load(paste(base.dir, "includes/paths_by_length.RData", sep="/"))

  if(lang == "fr") {
    load(paste(base.dir, "includes/dict_fr.RData", sep="/"))
    load(paste(base.dir, "includes/weights_and_dice_fr.RData", sep="/"))
  } 
  if(lang == "en") {
    load(paste(base.dir, "includes/dict_en.RData", sep="/"))
    load(paste(base.dir, "includes/weights_and_dice_en.RData", sep="/"))
  } 
  if(lang == "fi") {
    load(paste(base.dir, "includes/dict_fi.RData", sep="/"))
    load(paste(base.dir, "includes/weights_and_dice_fi.RData", sep="/"))
  }

  # Define functions
  shuffle <- function(shuffle.mode="dice") {
    if(shuffle.mode == "obs") {
      sample(x = letters, size = 16, replace = TRUE, prob = weights.obs$weight)
    } else if(shuffle.mode == "dice") {
      sapply(sapply(dice, strsplit, ""), sample, size=1)
    } else {
      stop(msgs[["mode.err"]])
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
  message(msgs[["patient"]])
  solutions <- Solve.Boggle(bog.letters = bog.letters, lang = lang, n.letters = 3:16)

  # Prepare responses dataframe
  responses <- data.frame(word=character(), pts=numeric(), stringsAsFactors = FALSE)
  time.start <- Sys.time()

  shell(cmd = sprintf('Rscript.exe R/progress_bar.R %i %s', time.limit - 2, lang), wait=FALSE)

  repeat {

    time.diff <- Sys.time()-time.start
    units(time.diff) <- "secs"

    if(time.diff > time.limit)
      break

    cat("\n")
    word <- scan(what = "character", nlines = 1, quiet = TRUE)

    time.diff <- Sys.time()-time.start
    units(time.diff) <- "secs"

    if(time.diff > time.limit) {
      message(msgs[["time.is.up"]])
      next
    }

    if(length(word) == 0) {
      message(msgs[["quit"]])
      next
    } else if(tolower(word) == "q") {
      break
    } else if(nchar(word) < 3) {
      message(msgs[["min.letters"]])
      next
    }

    if(word %in% solutions[[1]] && !word %in% responses[[1]]) {
      responses <- rbind(responses, solutions[which(solutions[[1]]==word),])
      message("+", tail(responses$pts,1), "pt(s) (", msgs[["time.left"]], round(time.limit - time.diff), " secs)")

    } else if(word %in% responses[[1]]) {
      message(msgs[["already.entered"]], round(time.limit - time.diff), " secs)")
    } else {
      message(msgs[["invalid.word"]], round(time.limit - time.diff), " secs)")
    }
  }

  message("\nTotal: ", sum(responses$pts), " points!")
  message(sprintf(msgs[["conclusion"]],
                  sum(solutions$pts), nchar(tail(solutions[[1]],1)) + 1 ))

  rownames(responses) <- NULL

  if(lang=="fr") {
    colnames(responses) <- c("mot", "pts")
    return(invisible(list(responses=responses, solutions=solutions)))
  } else {
    return(invisible(list(responses=responses, solutions=solutions)))
  }
}
