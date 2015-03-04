build.weights.dice <- function() {

  # read dictionnary data from disk
  base.dir <- find.package("Boggler")
  load(file = paste(base.dir, "includes/dict.fr.RData", sep="/"))

  # Create weights for letter randomization
  # This is used when playing only
  # a) weights based on real frequencies of letters
  all.letters <- strsplit(paste(dict.fr$mot,collapse=""),"")
  weights.obs <- prop.table(table(all.letters))
  weights.obs <- data.frame(letter=names(weights.obs), weight=as.numeric(weights.obs), stringsAsFactors = FALSE)

  # Assign real Boggle dice to the dice variable
  dice.fr <- c("elupst", "zdvnea", "sdtnoe", "amoris", "fxraoi", "moqabj", "fsheei",
               "hrsnei", "etnkou", "tarilb", "tieaoa", "acepdm", "rlasec", "uliwer",
               "vgtnie", "lenuyg")

  save(dice.fr, weights.obs, file = paste(base.dir, "includes/weights_and_dice.RData", sep="/"))

  rm(dict.fr, all.letters, weights.obs, dice.fr)
}
