# build.paths <- function() {
#
#   base.dir <- find.package("Boggler")
#
#   # A graph will represent permitted connections between letters
#   temp.graph <- graph.lattice(length = c(4,4), dim = 1, directed = FALSE)
#   plot(temp.graph)
#
#   # We need to add diagonal connections; we'll get the adjacency matrix and add them to it
#   adjacency.matrix <- get.adjacency(graph=temp.graph, type = "both", attr = NULL, edges = FALSE, sparse = TRUE)
#
#   # define pairs of links to add
#   indices <- rbind(c(1,6), c(2,5), c(2,7), c(3,6), c(3,8), c(4,7), c(5,10),
#                    c(6,9), c(7,10), c(6,11), c(8,11), c(7,12), c(9,14), c(10,13),
#                    c(10,15), c(11,14), c(11,16), c(12,15))
#
#
#   for(i in 1:nrow(indices)) {
#     adjacency.matrix[indices[i,1],indices[i,2]] <- 1
#   }
#
#   boggle.graph <- graph.adjacency(adjmatrix = adjacency.matrix, diag = TRUE, mode = "undirected")
#
#   # Make sure we have the correct graph
#   plot(boggle.graph)
#
#   # Make a nicer plot
#   png(filename = paste(base.dir, "includes/Boggle_graph.png", sep="/"))
#   plot(boggle.graph,
#        layout = layout.grid,
#     vertex.label=c(13:16,9:12,5:8,1:4),
#     vertex.size = 30,
#     vertex.shape = "square",
#     vertex.color="white",
#     vertex.frame.color= "black",
#     vertex.label.color = "black",
#     vertex.label.family = "sans",
#     vertex.label.cex=1,
#     edge.width=2)
#   dev.off()
#
#   # Generate all legit paths with this recursive function
#   # credits: http://stackoverflow.com/users/919872/zelazny7
#   # reference: http://stackoverflow.com/questions/28609703/boggle-cheat-erm-solutioning-with-graphs-in-r/
#   getPaths <- function(v, g, L = 4) {
#    paths <- list()
#
#    recurse <- function(g, v, path = NULL) {
#      path <- c(v, path)
#
#      if (length(path) >= L) {
#        paths[[length(paths) + 1]] <<- rev(path)
#      } else {
#        for (i in neighbors(g, v)) {
#          if (!(i %in% path)) recurse(g, i, path)
#        }
#      }
#    }
#    recurse(g, v)
#    return(paths)
#   }
#
#   cl <- makeCluster(4)
#   registerDoSNOW(cl)
#
#   all.paths <- foreach(i = 3:16) %:%
#    foreach(v = V(boggle.graph), .packages = c('igraph')) %dopar% getPaths(v, boggle.graph, i)
#
#   stopCluster(cl)
#
#   paths.by.length <- list()
#   for (i in 1:14) {
#    paths.by.length[[i]] <- do.call(rbind, lapply(all.paths[[i]],
#                                            function(x) do.call(rbind, x)))
#   }
#
#   # Save the paths to disk
#   save(all.paths, file = paste(base.dir, "includes/all_paths_RData", sep="/"))
#   save(paths.by.length, file = paste(base.dir, "includes/paths_by_length.RData", sep="/"))
# }
