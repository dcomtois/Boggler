build.weights.dice <- function() {

  # French
  # read dictionnary data from disk
  #base.dir <- find.package("Boggler")
  base.dir <- "./inst"
  load(file = paste(base.dir, "includes/dict_fr.RData", sep="/"))

  # Create weights for letter randomization
  # This is used when playing only
  # a) weights based on real frequencies of letters
  all.letters <- strsplit(paste(dict$word,collapse=""),"")
  weights.obs <- prop.table(table(all.letters))
  weights.obs <- data.frame(letter=names(weights.obs), weight=as.numeric(weights.obs), stringsAsFactors = FALSE)

  # Assign real Boggle dice to the dice variable
  dice <- c("elupst", "zdvnea", "sdtnoe", "amoris", "fxraoi", "moqabj", "fsheei",
            "hrsnei", "etnkou", "tarilb", "tieaoa", "acepdm", "rlasec", "uliwer",
            "vgtnie", "lenuyg")

  save(dice, weights.obs, file = paste(base.dir, "includes/weights_and_dice_fr.RData", sep="/"))

  rm(dict, all.letters, weights.obs, dice)

  # English
  load(file = paste(base.dir, "includes/dict_en.RData", sep="/"))

  # Create weights for letter randomization
  # This is used when playing only
  # a) weights based on real frequencies of letters
  all.letters <- strsplit(paste(dict$word,collapse=""),"")
  weights.obs <- prop.table(table(all.letters))
  weights.obs <- data.frame(letter=names(weights.obs), weight=as.numeric(weights.obs), stringsAsFactors = FALSE)

  dice <- c("aaeegn", "elrtty", "aoottw", "abbjoo", "ehrtvw", "cimotu", "distty",
               "eiosst", "delrvy", "achops", "himnqu", "eeinsu", "eeghnw", "affkps",
               "hlnnrz", "deilrx")

  save(dice, weights.obs, file = paste(base.dir, "includes/weights_and_dice_en.RData", sep="/"))

  rm(dict, all.letters, weights.obs, dice)

}
