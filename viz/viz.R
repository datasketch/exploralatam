library(tidyverse)
library(visNetwork)

nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

edg <- edges %>%
  #sample_n(100) %>%
  mutate(size = weight)
nod <- nodes %>% filter(id %in% c(edg$from, edg$to))
nod <- nod %>% mutate(size = 20*centrality/max(centrality) + 10)

layoutMat <- nod %>% select(x,y) %>% as.matrix()

visNetwork(nodes = nod, edges = edg) %>%
visIgraphLayout("layout.norm",layoutMatrix = layoutMat)
