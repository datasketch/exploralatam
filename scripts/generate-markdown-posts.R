library(tidyverse)
library(glue)

library(airtabler)
dotenv::load_dot_env()
exploralatam <- airtable(
    base = "appphYUEy3ncxEeJr",
    tables = c("organizations", "initiatives", "cities", "tags")
  )

orgs0 <- exploralatam$organizations$select_all()
initiatives0 <- exploralatam$initiatives$select_all()
cities0 <- exploralatam$cities$select_all()
tags0 <- exploralatam$tags$select_all()

initiatives0 <- initiatives0 %>% filter(!is.null(orgs), orgs != "NULL")

org_tpl <- read_lines("scripts/org-template.md") %>% paste(collapse = "\n")

orgs <- transpose(orgs0)

# Test with one Org

org <- orgs[[sample(length(orgs),1)]]

org$type <- "NNN"

org_defaults <- list(
  date_last_modified = NULL,
  name = "_NOMBRE NO ENCONTRADO_",
  legal_name = NULL,
  description = NULL,
  type = "Desconocido",
  url = "No url",
  year_founded = NULL,
  projects = "No información sobre proyectos de esta organización"
)
org2 <- modifyList(org_defaults, org)

org_inits <- initiatives0 %>% filter(id %in% org$initiatives) %>% select(uid, name) %>% transpose()
org2$projects <- map(org_inits, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
org_tags <- tags0 %>% filter(id %in% org$tags) %>% select(uid, name) %>% transpose()
org2$tags <- map(org_tags, ~glue_data(.,"  - {uid}]")) %>% paste(collapse = "\n")
org_cities <- cities0 %>% filter(id %in% org$cities) %>% select(name) %>% transpose()
org2$cities <- map(org_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
glue_data(org2, org_tpl)

### Generate files
my_orgs <- c("datasketch", "socialtic", "project-poder","economica-feminista", "ojo-publico")
my_orgs <- c(my_orgs, sample(orgs0$uid,10))
orgs <- orgs0 %>% filter(uid %in% my_orgs) %>% transpose()

map(orgs, function(org){
  org2 <- modifyList(org_defaults, org)
  org_inits <- initiatives0 %>% filter(id %in% org$initiatives) %>% select(uid, name) %>% transpose()
  org2$projects <- map(org_inits, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
  org_tags <- tags0 %>% filter(id %in% org$tags) %>% select(uid, name) %>% transpose()
  org2$tags <- map(org_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  org_cities <- cities0 %>% filter(id %in% org$cities) %>% select(name) %>% transpose()
  org2$cities <- map(org_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(org2, org_tpl)
  write_lines(md, paste0("content/org/", org$uid, ".md"))
})


## Initiatives
ini_tpl <- read_lines("scripts/ini-template.md") %>% paste(collapse = "\n")

inis <- transpose(initiatives0)
ini <- inis[[sample(length(inis),1)]]
ini$type <- "NNN"

ini_defaults <- list(
  date_last_modified = NULL,
  name = "_NOMBRE INICIATIVA NO ENCONTRADO_",
  description = NULL,
  type = "Desconocido",
  url = "No url",
  year_founded = NULL,
  projects = "No información sobre proyectos de esta inianización"
)
ini2 <- modifyList(ini_defaults, ini)

ini_orgs <- orgs0 %>% filter(id %in% ini$orgs) %>% select(uid, name) %>% transpose()
ini2$organizations <- map(ini_orgs, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
ini_tags <- tags0 %>% filter(id %in% ini$tags) %>% select(uid, name) %>% transpose()
ini2$tags <- map(ini_tags, ~glue_data(.,"  - {uid}]")) %>% paste(collapse = "\n")
ini_cities <- cities0 %>% filter(id %in% ini$cities) %>% select(name) %>% transpose()
ini2$cities <- map(ini_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
glue_data(ini2, ini_tpl)

### Generate files
my_inis <- c("rio-abierto", "reporte-ciudad", "sobrevivientes","cargografias", "dbjj-abiertas","igualdata")
my_inis <- c(my_inis, sample(initiatives0$uid,10))
inis <- initiatives0 %>% filter(uid %in% my_inis) %>% transpose()

map(inis, function(ini){
  ini2 <- modifyList(ini_defaults, ini)
  ini_orgs <- orgs0 %>% filter(id %in% ini$orgs) %>% select(uid, name) %>% transpose()
  ini2$organizations <- map(ini_orgs, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
  ini_tags <- tags0 %>% filter(id %in% ini$tags) %>% select(uid, name) %>% transpose()
  ini2$tags <- map(ini_tags, ~glue_data(.,"  - {uid}]")) %>% paste(collapse = "\n")
  ini_cities <- cities0 %>% filter(id %in% ini$cities) %>% select(name) %>% transpose()
  ini2$cities <- map(ini_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(ini2, ini_tpl)
  write_lines(md, paste0("content/ini/", ini$uid, ".md"))
})

