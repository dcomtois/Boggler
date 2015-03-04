# Boggler
### Generate solutions and play Boggle (in French only... for now!)

#### Getting Started
First, install the package:

```r
library(devtools)
install_github("dcomtois/Boggler")
```

Next, just use one of `Play.Boggle()` or `Solve.Boggle()` functions. That's it!

#### What to expect
When you use `Play.Boggle()`, the letters are shuffled and you get a plot looking like this one:
![Boggle letters](inst/includes/Boggle_letters.png)

Behind the scenes, letters are connected via an igraph:
![Boggle igraph](inst/includes/Boggle_graph.png)

#### Et puis après?
```r
> Play.Boggle()
Veuillez patienter pendant la recherche des solutions...

1: ait
+1pt(s) (temps restant: 99 secs)

1: 
```

At the end, you get your score, as well as the maximum possible score.

To get the list of all possible words, just proceed like this:

```r
> solutions <- Play.Boggle()
...
> solutions
```
