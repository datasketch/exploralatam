library(tidyverse)
library(glue)

library(airtabler)
dotenv::load_dot_env()
exploralatam <- airtable(
    base = "appphYUEy3ncxEeJr",
    tables = c("organizations", "initiatives", "cities", "tags")
  )

orgs0 <- exploralatam$organizations$select_all()
orgs0 <- mop::na_to_empty_chr(orgs0, empty = c(NA, "NA"))
exclude_cols <- c("ID_org","Ciudad ID", "IDS IMPACT", "ID UNICO",
                  "employees", "reach",
                  "name_altec", "org_altec", "leader_name", "type_altec")
include_cols <- setdiff(names(orgs0), exclude_cols)
orgs0 <- orgs0 %>% select(one_of(include_cols))

initiatives0 <- exploralatam$initiatives$select_all()
initiatives0 <- mop::na_to_empty_chr(initiatives0, empty = c(NA, "NA"))
cities0 <- exploralatam$cities$select_all()
cities0 <- mop::na_to_empty_chr(cities0, empty = c(NA, "NA"))
tags0 <- exploralatam$tags$select_all()
tags0 <- mop::na_to_empty_chr(tags0, empty = c(NA, "NA"))

exclude_cols <- c("ID_initiative","ID IMPACT", "ID UNICO", "ID_org",
                  "ID_city",
                  "type2", "sector", "Nombre org",
                  "name_altec", "org_altec", "tags_notes", "orgs_ds",
                  "participation"
                  )
include_cols <- setdiff(names(initiatives0), exclude_cols)
initiatives0 <- initiatives0 %>%
  filter(!is.null(orgs), orgs != "NULL") %>%
  select(one_of(include_cols))

org_tpl <- read_lines("scripts/org-template.md") %>% paste(collapse = "\n")

orgs <- transpose(orgs0)

# Test with one Org
set.seed(20190722)
org <- orgs[[sample(length(orgs),1)]]

org$org_type <- "NNN"

org_defaults <- list(
  date_last_modified = NULL,
  name = "_NOMBRE NO ENCONTRADO_",
  legal_name = NULL,
  description = NULL,
  org_type = "Desconocido",
  website = "No website",
  year_founded = NULL,
  projects = "No información sobre proyectos de esta organización"
)
org2 <- modifyList(org_defaults, org)

org_inits <- initiatives0 %>% filter(id %in% org$initiatives) %>% select(uid, name) %>% transpose()
org2$projects <- map(org_inits, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
org_tags <- tags0 %>% filter(id %in% org$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
org2$tags <- map(org_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
org_cities <- cities0 %>% filter(id %in% org$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
org2$cities <- map(org_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
glue_data(org2, org_tpl)

## Delete current md
unlink("content/organizaciones/", recursive = TRUE)
unlink("content/proyectos/", recursive = TRUE)
dir.create("content/organizaciones")
dir.create("content/proyectos")
### Generate files
#my_orgs <- c("datasketch", "socialtic", "project-poder","economica-feminista", "ojo-publico")
#my_orgs <- c(my_orgs, sample(orgs0$uid,10))
#orgs <- orgs0 %>% filter(uid %in% my_orgs) %>% transpose()
orgs <- orgs0 %>% transpose()

all_orgs <- map(orgs, safely(function(org){
  org2 <- modifyList(org_defaults, org)
  org_inits <- initiatives0 %>% filter(id %in% org$initiatives) %>% select(uid, name) %>% transpose()
  org2$projects <- map(org_inits, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
  org_tags <- tags0 %>% filter(id %in% org$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
  org2$tags <- map(org_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  org_cities <- cities0 %>% filter(id %in% org$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
  org2$cities <- map(org_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(org2, org_tpl)
  write_lines(md, paste0("content/organizaciones/", org$uid, ".md"))
  org2$id <- NULL
  org2$projects <- org_inits
  org2$initiatives <- NULL
  org2$cities <- org_cities
  org2$tags <- org_tags
  org2$createdTime <- NULL
  org2
}))

org_failed <- all_orgs %>% keep(~!is.null(.$error))
org_success <-  all_orgs %>% keep(~is.null(.$error))
all_orgs2 <- transpose(org_success)[["result"]]

## Initiatives
ini_tpl <- read_lines("scripts/ini-template.md") %>% paste(collapse = "\n")

inis <- transpose(initiatives0)
ini <- inis[[sample(length(inis),1)]]
ini$type <- "NNN"

ini_defaults <- list(
  name = "_NOMBRE INICIATIVA NO ENCONTRADO_",
  description = NULL,
  type = "Desconocido"
)
ini2 <- modifyList(ini_defaults, ini)

ini_orgs <- orgs0 %>% filter(id %in% ini$orgs) %>% select(uid, name) %>% transpose()
ini2$organizations <- map(ini_orgs, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
ini_tags <- tags0 %>% filter(id %in% ini$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
ini2$tags <- map(ini_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
ini_cities <- cities0 %>% filter(id %in% ini$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
ini2$cities <- map(ini_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
glue_data(ini2, ini_tpl)

### Generate files
#my_inis <- c("rio-abierto", "reporte-ciudad", "sobrevivientes","cargografias", "dbjj-abiertas","igualdata")
#my_inis <- c(my_inis, sample(initiatives0$uid,10))
#inis <- initiatives0 %>% filter(uid %in% my_inis) %>% transpose()
inis <- initiatives0 %>% transpose()

all_proy <- map(inis, safely(function(ini){
  ini2 <- modifyList(ini_defaults, ini)
  ini_orgs <- orgs0 %>% filter(id %in% ini$orgs) %>% select(uid, name) %>% transpose()
  ini2$organizations <- map(ini_orgs, ~glue_data(.,"- [{name}](/i/{uid}.html)")) %>% paste(collapse = "\n")
  ini_tags <- tags0 %>% filter(id %in% ini$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
  ini2$tags <- map(ini_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  ini_cities <- cities0 %>% filter(id %in% ini$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
  ini2$cities <- map(ini_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(ini2, ini_tpl)
  write_lines(md, paste0("content/proyectos/", ini$uid, ".md"))
  ini2$id <- NULL
  ini2$orgs <- NULL
  ini2$organizations <- ini_orgs
  ini2$cities <- ini_cities
  ini2$tags <- ini_tags
  ini2$createdTime <- NULL
  ini2
}))

proy_failed <- all_proy %>% keep(~!is.null(.$error))
proy_success <-  all_proy %>% keep(~is.null(.$error))
all_proy2 <- transpose(proy_success)[["result"]]


jsonlite::write_json(list(organizaciones = all_orgs2, proyectos = all_proy2),
                     "data/exploralatam.json", auto_unbox = TRUE)
