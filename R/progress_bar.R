library(tcltk)
library(beepr)

if(length(commandArgs(trailingOnly = TRUE))==0) {
  time.limit <- 120
  lang <- "fr"
} else {
  time.limit <- as.numeric(commandArgs(trailingOnly = TRUE)[1])
  lang <- commandArgs(trailingOnly = TRUE)[2]
}

if(time.limit %in% c(NA, NaN))
  time.limit <- 1

msg <- ifelse(lang=="fr", "Temps restant", "Time Left")
secs <- ifelse(lang=="fr", "secondes", "Seconds")

# http://www.sciviews.org/_rgui/tcltk/
beep(1)
pb <- tkProgressBar(msg, "", 0, time.limit, time.limit)

for(i in time.limit:0) {
 setTkProgressBar(pb, i, label = paste(i, secs))
 Sys.sleep(1)
}

pb$kill()
beep(1)
Sys.sleep(2)
