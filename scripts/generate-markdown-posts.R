library(tidyverse)
library(glue)

library(airtabler)
dotenv::load_dot_env()
exploralatam <- airtable(
    base = "appphYUEy3ncxEeJr",
    tables = c("organizations", "initiatives", "cities")
  )

orgs <- exploralatam$organizations$select_all()
initiatives <- exploralatam$initiatives$select_all()
cities <- exploralatam$cities$select_all()

org_tpl <- read_lines("scripts/org-template.md") %>% paste(collapse = "\n")

orgs <- transpose(orgs)

org <- orgs[[1]]

org$initiative <- NULL

org_defaults <- list(
  date = "???",
  description = "???",
  title = "TITLE",
  projects = "projects"
)
org <- modifyList(org, org_defaults)
initiatives <- list(list(name = "uno", link = "un-link"), list(name = "dos", link = "dos-link"))
org$projects <- map(initiatives, ~glue_data(.,"-[{name}]({link})")) %>% paste(collapse = "\n")
glue_data(org, org_tpl)


### Generate files
orgs <- orgs[1:5]

map(orgs, function(org){
  org <- modifyList(org, org_defaults)
  initiatives <- list(list(name = "uno", link = "un-link"), list(name = "dos", link = "dos-link"))
  org$projects <- map(initiatives, ~glue_data(.,"-[{name}]({link})")) %>% paste(collapse = "\n")
  md <- glue_data(org, org_tpl)
  write_lines(md, paste0("content/org/", org$uid, ".md"))
})


