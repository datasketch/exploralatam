library(tidyverse)
library(glue)

library(airtabler)
dotenv::load_dot_env()
exploralatam <- airtable(
    base = "appphYUEy3ncxEeJr",
    tables = c("organizations", "projects", "cities", "tags")
  )

orgs0 <- exploralatam$organizations$select_all()
orgs0 <- mop::na_to_empty_chr(orgs0, empty = c(NA, "NA"))
exclude_cols <- c("ID_org","Ciudad ID", "IDS IMPACT", "ID UNICO",
                  "employees", "reach",
                  "name_altec", "org_altec", "leader_name", "type_altec")
include_cols <- setdiff(names(orgs0), exclude_cols)
orgs0 <- orgs0 %>% select(one_of(include_cols))

projects0 <- exploralatam$projects$select_all()
projects0 <- mop::na_to_empty_chr(projects0, empty = c(NA, "NA"))
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
include_cols <- setdiff(names(projects0), exclude_cols)
projects0 <- projects0 %>%
  filter(!is.null(orgs), orgs != "NULL") %>%
  select(one_of(include_cols))

## GENERATE POSTS

org_tpl <- read_lines("scripts/organizacion-template.md") %>% paste(collapse = "\n")

orgs <- transpose(orgs0)

# Test with one Org
set.seed(20190722)
org <- orgs[[sample(length(orgs),1)]]
org <- orgs[[30]]

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
org2$name <- gsub("'", "\\\\'", org2$name)
org2$description <- gsub("'", "\\\\'", org2$description)
org_projs <- projects0 %>% filter(id %in% org$projects) %>% select(uid, name) %>% transpose()
org2$projects <- map(org_projs, ~glue_data(.,"- [{name}](/proyectos/{uid})")) %>% paste(collapse = "\n")
org2$projects_uids_yaml <-  map(org_projs, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
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
  org2$name <- gsub("'", "\\\\'", org2$name)
  org2$description <- gsub("'", "\\\\'", org2$description)
  org_projs <- projects0 %>% filter(id %in% org$projects) %>% select(uid, name) %>% transpose()
  org2$projects <- map(org_projs, ~glue_data(.,"- [{name}](/proyectos/{uid})")) %>% paste(collapse = "\n")
  org2$projects_uids_yaml <-  map(org_projs, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  org_tags <- tags0 %>% filter(id %in% org$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
  org2$tags <- map(org_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  org_cities <- cities0 %>% filter(id %in% org$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
  org2$cities <- map(org_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(org2, org_tpl)
  write_lines(md, paste0("content/organizaciones/", org$uid, ".md"))
  org2$id <- NULL
  org2$projects <- org_projs
  org2$cities <- org_cities
  org2$tags <- org_tags
  org2$createdTime <- NULL
  org2$projects_uids_yaml <- NULL
  org2
}))
orgs_uids <- orgs %>% map_chr("uid")
all_orgs <- all_orgs %>% set_names(orgs_uids)
org_failed <- all_orgs %>% keep(~!is.null(.$error))
if(length(org_failed)>0){
  message("failed orgs:", length(org_failed))
  org_failed2 <- transpose(org_failed)[["error"]] %>%
  map(`[`,"message") %>%
  mop::named_list_to_df()
}
org_success <-  all_orgs %>% keep(~is.null(.$error))
all_orgs2 <- transpose(org_success)[["result"]]

## projects
proj_tpl <- read_lines("scripts/proyecto-template.md") %>% paste(collapse = "\n")

projs <- transpose(projects0)
proj <- projs[[sample(length(projs),1)]]
proj$type <- ""

proj_defaults <- list(
  name = "_NOMBRE INICIATIVA NO ENCONTRADO_",
  description = NULL,
  type = "Desconocido"
)
proj2 <- modifyList(proj_defaults, proj)
proj2$name <- gsub("'", "\\\\'", proj2$name)
proj2$description <- gsub("'", "\\\\'", proj2$description)
proj_orgs <- orgs0 %>% filter(id %in% proj$orgs) %>% select(uid, name) %>% transpose()
proj2$organizations <- map(proj_orgs, ~glue_data(.,"- [{name}](/organizaciones/{uid})")) %>% paste(collapse = "\n")
proj2$organizations_uids_yaml <-  map(proj_orgs, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
proj_tags <- tags0 %>% filter(id %in% proj$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
proj2$tags <- map(proj_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
proj_cities <- cities0 %>% filter(id %in% proj$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
proj2$cities <- map(proj_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
glue_data(proj2, proj_tpl)

### Generate files
#my_projs <- c("rio-abierto", "reporte-ciudad", "sobrevivientes","cargografias", "dbjj-abiertas","igualdata")
#my_projs <- c(my_projs, sample(projects0$uid,10))
#projs <- projects0 %>% filter(uid %in% my_projs) %>% transpose()
projs <- projects0 %>% transpose()

all_proj <- map(projs, safely(function(proj){
  proj2 <- modifyList(proj_defaults, proj)
  proj2$name <- gsub("'", "\\\\'", proj2$name)
  proj2$description <- gsub("'", "\\\\'", proj2$description)
  proj_orgs <- orgs0 %>% filter(id %in% proj$orgs) %>% select(uid, name) %>% transpose()
  proj2$organizations <- map(proj_orgs, ~glue_data(.,"- [{name}](/organizaciones/{uid})")) %>% paste(collapse = "\n")
  proj2$organizations_uids_yaml <-  map(proj_orgs, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  proj_tags <- tags0 %>% filter(id %in% proj$tags) %>% filter(uid != "NA") %>% select(uid, name) %>% transpose()
  proj2$tags <- map(proj_tags, ~glue_data(.,"  - {uid}")) %>% paste(collapse = "\n")
  proj_cities <- cities0 %>% filter(id %in% proj$cities) %>% filter(name != "NA") %>% select(name) %>% transpose()
  proj2$cities <- map(proj_cities, ~glue_data(.,"  - {name}")) %>% paste(collapse = "\n")
  md <- glue_data(proj2, proj_tpl)
  write_lines(md, paste0("content/proyectos/", proj$uid, ".md"))
  proj2$id <- NULL
  proj2$orgs <- NULL
  proj2$organizations <- proj_orgs
  proj2$cities <- proj_cities
  proj2$tags <- proj_tags
  proj2$createdTime <- NULL
  proj2$organizations_uids_yaml <- NULL
  proj2
}))

proj_uids <- projs %>% map_chr("uid")
all_proj <- all_proj %>% set_names(proj_uids)
proj_failed <- all_proj %>% keep(~!is.null(.$error))
if(length(proj_failed) > 0){
  message("proj failed: ", length(proj_failed))
  proj_failed2 <- transpose(proj_failed)[["error"]] %>%
    map(`[`,"message") %>%
    mop::named_list_to_df()
}
proj_success <-  all_proj %>% keep(~is.null(.$error))
all_proj2 <- transpose(proj_success)[["result"]]

message("orgs: ", length(all_orgs2), "\nproys: ", length(all_proj2))

library(jsonlite)

json <- list(organizaciones = unname(all_orgs2), proyectos = unname(all_proj2))
jsonlite::write_json(json,
                     "data/exploralatam.json", auto_unbox = TRUE)
