library(tidyverse)
library(visNetwork)

library(hgchmagic)

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
tags <- read_csv("data/desc_tags_data.csv")
## Número de temas por organización
d <- tags %>% group_by(uid_org) %>%
  summarise(n_temas = n())
hist(d$n_temas)

## Temas más recurrentes
d <- tags %>% group_by(uid) %>%
  summarise(n_orgs = n())
hgch_bar_CatNum(d, opts = list(orientation = "hor", sort = "asc"))


# Cantidad de proyectos por tema

tags_proj <- read_csv("data/desc_proj_tags_data.csv")
## Número de temas por proyecto
d <- tags_proj %>% group_by(uid_proj) %>%
  summarise(n_temas = n())
hist(d$n_temas)

## Temas más recurrentes en los proyectos
d <- tags_proj %>% group_by(uid) %>%
  summarise(n_proj = n())


# Proyecto colaborativo (de uno o mas organizaciones)

org_proj <- read_csv("data/exploralatam-network.csv")

n_orgs <- length(unique(org_proj$org_uid)) # 679
n_proj <- length(unique(org_proj$proj_uid)) # 695

d <- org_proj %>% group_by(proj_uid) %>%
  filter(n() > 1)
nrow(d) # 442

# Por paises


cities <- read_csv("data/cities_data.csv")

## Número de organizaciones por país
d <- cities %>% group_by(country) %>%
  summarise(n_orgs = n())
hgch_bar_CatNum(d, opts = list(orientation = "hor", sort = "asc"))

# pequenas , medianas y grandes






