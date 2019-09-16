library(tidyverse)
library(visNetwork)

nodes <- read_csv("viz/data/nodes.csv")
edges <- read_csv("viz/data/edges.csv")

edg <- edges %>%
  #sample_n(100) %>%
  mutate(size = weight)
nod <- nodes %>% filter(id %in% c(edg$from, edg$to))
nod <- nod %>% mutate(size = 20*centrality/max(centrality) + 10)

layoutMat <- nod %>% select(x,y) %>% as.matrix()

visNetwork(nodes = nod, edges = edg) %>%
visIgraphLayout("layout.norm",layoutMatrix = layoutMat)



# Asociaciones entre si


# Cantidad de temas




# Cantidad de proyectos por tema
# Proyecto colaborativo (de uno o mas organizaciones)
# Por paises
# pequenas , medianas y grandes



