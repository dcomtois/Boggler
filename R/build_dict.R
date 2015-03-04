# Dictionary sources:
# http://www.pallier.org/ressources/dicofr/liste.de.mots.francais.frgut.txt"
# http://www.lexique.org/public/Lexique380.zip
# https://github.com/inouire/baggle/archive/v3.2.zip
# http://gboggle.sourceforge.net/

# build.dict <- function(in.file = NA, out.file = NA, header = FALSE, sep = "\t", quote = "",
#                        fileEncoding = "utf8", ...) {
#
#   if(is.na(in.file)) {
#     base.dir <- find.package("Boggler")
#     in.file <- paste(base.dir, "inst/includes/dict_concat.csv")
#   }
#
#   words <- read.table(file = in.file, header = header, stringsAsFactors = FALSE,
#                       sep = sep, quote = quote, fileEncoding = fileEncoding, ...)
#
#   # Remove words with a dash or space
#   words <- grep("\\-|\\s|\\'", x = words$V1, perl = TRUE, value = TRUE, invert = TRUE)
#
#   # all lowercase
#   words <- tolower(words)
#
#   # Remove diacritics
#   words <- iconv(words, to="ASCII//TRANSLIT//IGNORE")
#
#   # Remove dots
#   words <- gsub(pattern = ".", replacement = "", x = words, fixed = TRUE)
#
#   # Get unique words
#   words <- unique(words)
#
#   # Keep only words having between 3 and 16 letters
#   words <- words[(nchar(words) >= 3) & (nchar(words) <= 16)]
#
#   # sort words
#   words <- sort(words)
#
#   # Remove last entry (zzzz !)
#   # words <- words[-length(words)]
#
#   # save dictionnary data to disk
#   dict.fr <- data.frame(mot=words, taille=nchar(words))
#
#   if(is.na(out.file))
#     save(dict.fr, file = paste(base.dir, "inst/includes/dict_fr.RData"))
#   else
#     save(dict.fr, file = file.out)
# }
