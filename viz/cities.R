cities <- jsonlite::fromJSON('data/cities.json',
                             simplifyDataFrame = FALSE)

tmp <- cities %>%
  transpose() %>%
  as_tibble()

tmp <- tmp %>%
  unnest(orgs,
         .id = 'ind',
         .preserve = c('name', 'country', 'lat', 'lon'))

list_org <- map(seq_along(tmp$orgs), function(z) {
  data.frame(names_org = tmp$orgs[[z]]$name, uid_org = tmp$orgs[[z]]$uid)
}) %>% bind_rows()


org_base <- bind_cols(tmp, list_org) %>% select(-orgs) %>% unnest()
org_base <- org_base %>%
  filter(lat != "", name != "")
cities_base <- org_base %>%
  group_by(name) %>%
  summarise(radius = n()) %>%
  left_join(org_base)

cities_base$lat <- as.numeric(cities_base$lat)
cities_base$lon <- as.numeric(cities_base$lon)
write_csv(cities_base, 'data/cities_data.csv')
