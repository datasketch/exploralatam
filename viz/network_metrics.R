library(igraph)
library(tidyverse)

nodes <- read_csv("viz/data/nodes.csv")
edges <- read_csv("viz/data/edges.csv")
g <- graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)

# https://kateto.net/networks-r-igraph

edge_density(g, loops=F) # Densidad del grafo
transitivity(g, type="global") # ratio of triangles (direction disregarded) to connected triples.
diameter(g, directed=F)
mean_distance(g, directed=F)

deg <- degree(g, mode="all")
hist(deg)
deg_table <- tibble(deg = deg) %>% count("deg")

tibble(deg = names(table(deg)),
       count = as.numeric(table(deg)),
       percent = as.numeric(table(deg)/sum(table(deg))))

deg_dist <- degree_distribution(g, cumulative=T, mode="all")
plot( x=0:max(deg), y=1-deg_dist, pch=19, cex=1.2, col="orange",
      xlab="Degree", ylab="Cumulative Frequency")



#cliques(g) # list of cliques
#sapply(cliques(g), length) # clique sizes
#largest_cliques(g) # cliques with max number of nodes



library(ggraph)
ggraph(g, layout = 'kk') +
  geom_edge_fan(aes(alpha = stat(index)), show.legend = FALSE) +
  geom_node_point(aes(size = size))

ggraph(g, layout = "linear") +
  geom_edge_arc(aes(width = weight), alpha = 0.8) +
  scale_edge_width(range = c(0.2, 2)) +
  #geom_node_text(aes(label = label)) +
  #labs(edge_width = "Letters") +
  theme_graph()

