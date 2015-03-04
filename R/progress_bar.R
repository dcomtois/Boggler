# library(tcltk)
# library(beepr)
#
# if(length(commandArgs(trailingOnly = TRUE))==0) {
#   time.limit <- 120
# } else {
#   time.limit <- as.numeric(commandArgs(TRUE)[1])
# }
#
# # http://www.sciviews.org/_rgui/tcltk/
# beep(1)
# pb <- tkProgressBar("Temps restant", "", 0, time.limit, time.limit)
#
# for(i in time.limit:0) {
#   setTkProgressBar(pb, i, label = sprintf("%i secondes", i))
#   Sys.sleep(1)
# }
# pb$kill()
# beep(1)
# Sys.sleep(2)
