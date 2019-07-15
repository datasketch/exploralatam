
library(readxl)
library(tidyverse)
library(mop)

initiatives <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = 1)

cities <- projects %>% select(Ciudad, País, Latitud, Longitud) %>% distinct()
copy_clipboard(cities)


project_impact <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "project-impact")
project_impact_tags <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "project-impact-tags")
project_impact <- project_impact %>% left_join(project_impact_tags, by = c("ID IMPACT" = "ID")) %>%
  select(ID_initiative, `ID IMPACT`, TAG, NoteTAG = ...11)
initiatives <- initiatives %>% left_join(project_impact)
initiatives$uid_initiative <- mop::create_slug(initiatives$`Nombre de la Iniciativa`)
initiatives$uid_org <- mop::create_slug(initiatives$`Nombre de la organización`)
length(unique(initiatives$ID_initiative))
initiatives_unique <- mop::coalesce_rows(initiatives, group = ID_initiative, sep = ',')
initiatives_unique <- initiatives_unique %>% select(uid_initiative, everything())
#initiatives_unique <- mop::coalesce_rows(initiatives, group = ID_initiative, sep = '","')
initiatives_unique <- initiatives_unique %>% select(-Latitud, -Longitud, -`Rango Empleados`)
copy_clipboard(initiatives_unique)
#many_orgs <- grepl('","', initiatives_unique$uid_org)
#initiatives_unique$uid_org <- paste0('"', initiatives_unique$uid_org, '"')
#initiatives_unique$TAG <- paste0('"', initiatives_unique$TAG, '"')

#### Country region
#country_region <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "country-region")
#country_region <- country_region %>% select(-ID_initiative) %>% distinct()
#copy_clipboard(country_region)


##### ORGS

##Join organization type
orgs <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "organizations")
types <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "orgs type")
org_impact <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "organization-impact")
org_impact_tags <- read_excel("~/Downloads/exploralatam_011819222_basecorreciones.xlsx", sheet = "organization-impact-tags")
org_impact <- org_impact %>% left_join(org_impact_tags, by = c("IDS IMPACT" = "ID"))
orgs <- orgs %>% left_join(org_impact)

orgs_unique <- mop::coalesce_rows(orgs, group = ID_org, sep = ",")
orgs_unique$uid_org <- mop::create_slug(orgs_unique$`Nombre de la organización`)
orgs_unique <- orgs_unique %>% select(uid_org, everything())
copy_clipboard(orgs_unique)


