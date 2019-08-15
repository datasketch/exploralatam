library(tidyverse)
library(glue)
library(jsonlite)
## ORGANIZE NETWORK DATA

exp <- fromJSON("data/exploralatam.json", simplifyDataFrame = FALSE)

orgs <- exp$organizaciones
orgs_proj <- map(orgs, function(x){
  #x <- orgs[[1]]
  #message(x$uid)
  if(length(x$projects) > 0){
    df <- x$projects %>% bind_rows()
    df$org_uid <- x$uid
    df$org_name <- x$name
    return(df)
  }
  tibble(uid = character(0), name = character(0), org_uid = character(0))
}) %>% bind_rows() %>% select(org_uid, org_name, proj_uid = uid, proj_name = name)

write_csv(orgs_proj, "data/exploralatam-network.csv")

# Create network

library(tidyverse)
library(igraph)

net <- read_csv("data/exploralatam-network.csv")


# https://www.williamrchase.com/post/finding-combinations-in-the-tidyverse/
edges <- net %>%
  select(proj_uid, org_uid) %>%
  group_by(proj_uid) %>%
  filter(n() > 1) %>%
  split(.$proj_uid) %>%
  map(., 2) %>%
  map(~combn(.x, m = 2)) %>%
  map(~t(.x)) %>%
  map_dfr(as_tibble) %>%
  rename(source = V1, target = V2) %>%
  filter(source != target) %>%
  group_by(source, target) %>%
  summarize(weight = n())

nodes <- net %>% select(org_uid, org_name) %>% distinct()

g <- graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)

V(g)$size <- strength(g)

V(g)$degree <- igraph::degree(g)
V(g)$centrality <- igraph::betweenness(g)

nds <- igraph::as_data_frame(g, "vertices")
edg <- igraph::as_data_frame(g, "edges")

write_csv(nds, "data/nodes.csv")
write_csv(edg, "data/edges.csv")





