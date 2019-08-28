library(tidyverse)
library(shiny)
library(dsAppWidgets)
library(leaflet)
library(igraph)
library(visNetwork)
library(hgchmagic)

net <- read_csv("data/exploralatam-network.csv")

cities_base <- read_csv('data/cities_data.csv')
tags_info <- read_csv('data/desc_tags_data.csv')
tags_info <- tags_info %>%
  group_by(uid_org) %>%
  summarise(tag_name = paste(name,collapse='_'))
cities_base <- cities_base %>% 
  left_join(tags_info)
cities_base$tag_name[is.na(cities_base$tag_name)] <- 'Sin tags'

org_info <- read_csv('data/desc_org_data.csv')
org_info$org_type[is.na(org_info$org_type)] <- 'Sin etiqueta'


ui <- fluidPage(
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="style.css"),
    includeScript("js/iframeSizer.contentWindow.min.js")
  ),
  div(class = 'panel',
      div(class = 'panel_div',
          div(class = 'panel_iconos',
              uiOutput('controls')
          ),
          div( class = 'panel_info',
               uiOutput('filter_org'),
               uiOutput('filter_tags'),
               HTML('<div class = "filter_opts">Da click en el grafico para obtener información</div>')
          )
      ),
      conditionalPanel(
        condition =  "input.graphs == 'Map'",
        leafletOutput('mapa_viz', height = "100%")
      ),
      conditionalPanel(
        condition =  "input.graphs == 'Red'",
        visNetworkOutput('red_viz', height = "100%")
      ),
      conditionalPanel(
        condition =  "input.graphs == 'Bubbles'",
        highchartOutput('bubbles_map', height = "100%")
      )
  )
)

server <- function(input, output, session) {
  
  output$controls <- renderUI({
    
    labels <- c('Map', 'Red', 'Bubbles')
    values <- c('Map', 'Red', 'Bubbles')
    buttonImage(id = 'graphs', labels, values, file = 'img/', format = 'svg')
  })
  
  output$filter_org <- renderUI({
    # Filtro tipo de organización
    type_org <- unique(org_info$org_type)
    # Filtro por tag
    tag_list <- unique(tags_info$name)
    div(class = 'filter_opts',
        selectizeInput(
          inputId = "type_organization",
          label = " ",
          choices = type_org,
          multiple = TRUE,
          selected = NULL,
          options = list(placeholder = "Filtra por tipo de organización",
                         plugins= list('remove_button'))
        )
    )
  })
  
  data_org <- reactive({
    t_org <- input$type_organization
    org_info <- cities_base %>% 
      left_join(org_info)
    
    if (is.null(t_org)) {
      org_info <- org_info
    } else {
      org_info <- org_info %>%
        filter(org_type %in% t_org)
    }
    org_info
  })  
  
  output$filter_tags <- renderUI({
    # Filtro tipo de organización
    dt <- data_org() 
    tag_list <- unique(strsplit(dt$tag_name, "_") %>% unlist())
    div(class = 'filter_opts',
        selectizeInput(
          inputId = "tag_org",
          label = " ",
          choices = tag_list,
          multiple = TRUE,
          selected = NULL,
          options = list(placeholder = "Filtra por tag",
                         plugins= list('remove_button'))
        )
    )
  })
  
  data_filter <- reactive({
    
    dta_map <- data_org()
    tags_sel <- input$tag_org
    if (is.null(tags_sel)) {
      dta_map <- dta_map
    } else {
      tags_sel <- paste0(tags_sel, collapse = "|")
      dta_map <- dta_map[grep(tags_sel, dta_map$tag_name),]
    }
    dta_map
  })
  
  output$mapa_viz <- renderLeaflet({
    cities_base_filt <- data_filter() 
    
    data_map <- cities_base_filt %>% #distinct(name, .keep_all = T)
      group_by(name, country, lat, lon) %>% 
      summarise(radius = n())
    
    labels <- sprintf(
      paste0('<div class="tool_map"><b>País: </b>', data_map$country,
             '<br/><b>Ciudad: </b>', data_map$name,
             '<br/>Total organizaciones: ', data_map$radius, '</div>'
      )) %>% lapply(htmltools::HTML)
    topoData <- readLines('data/american-countries.topojson')
    b_box <- geojson::bbox_get(topoData)
    lf <- leaflet() %>% 
      addTopoJSON(topoData, weight = 1, 
                  color = '#333', fill = FALSE)
    lf <- lf %>% 
      addProviderTiles('CartoDB') %>% 
      setView(lng = mean(c(b_box[1], b_box[3])),
              lat = mean(c(b_box[2], b_box[4])), 
              zoom = 3) %>% 
      addCircleMarkers(
        lng = data_map$lon,
        lat = data_map$lat,
        radius =  scales::rescale(data_map$radius, to = c(5, 21)),
        color = '#f55d26',
        stroke = FALSE,
        fillOpacity = 0.7,
        label = labels,
        layerId = data_map$name)
    lf
  })
  
  
  output$bubbles_map <- renderHighchart({
    cities_base_filt <- data_filter() 
    data_map <- cities_base_filt %>% #distinct(name, .keep_all = T)
      group_by(country, name) %>% 
      summarise(radius = n())
    #myFunc <- JS("function(event) {Shiny.onInputChange('hcClicked',  {id:event.point.category.name, cat:this.name, timestamp: new Date().getTime()});}")
    myFunc <- JS("function(event) {Shiny.onInputChange('hcClicked',  {id:event.point.name, timestamp: new Date().getTime()});}")
    
    hgch_bubbles_CatCatNum(data_map, opts = list(bubble_min = "1%",
                                                 bubble_max = "5%", 
                                                 clickFunction = myFunc,
                                                 background = 'transparent',
                                                 allow_point = TRUE,
                                                 cursor =  'pointer',
                                                 color_hover = "#fa8223",
                                                 color_click  = "#fa8223",
                                                 tooltip = list(headerFormat = " ",
                                                                pointFormat = '<b>País: </b>{point.name}</br>
                                                                               <b>Ciudad: </b>{series.name}</br>
                                                                               Total organizaciones: {point.y}'))
    )
  })
  
  output$red_viz <- renderVisNetwork({
    cities_base_filter <- data_filter() %>% 
      select(org_uid = uid_org) %>% distinct()
    
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
    
    coords <- layout_nicely(g)
    V(g)$x <- coords[,1]
    V(g)$y <- coords[,2]
    
    nds <- igraph::as_data_frame(g, "vertices")
    edges<- igraph::as_data_frame(g, "edges")
    
    nodes <- nds %>% select(id = name, label = org_name, everything())
    
    edg <- edges %>%
      mutate(size = weight)
    nod <- nodes %>%
      filter(id %in% c(edg$from, edg$to))
    nod <- nod %>%
      mutate(size = 20*centrality/max(centrality) + 10)
    
    layoutMat <- nod %>% select(x,y) %>% as.matrix()
    
    visNetwork(nodes = nod, edges = edg, background = "transparent") %>%
      visIgraphLayout("layout.norm",layoutMatrix = layoutMat) %>% 
      visEdges(arrows = 'from', scaling = list(min = 2, max = 10)) %>% 
      visNodes(color = list(background = "#62caa1", 
                            border = "#015d54",
                            highlight = "#015d54")) %>% 
      visEvents(
        click = "function(nodes) {
        console.info('click')
        console.info(nodes)
        Shiny.onInputChange('clickRed', {nodes : nodes.nodes[0]});
        ;}"
      )
    
  })
  
  output$map_text_ciudades <- renderUI({
    city <- input$mapa_viz_marker_click$id
    dt <- data_filter() %>% filter(name %in% city)
   
    # website, year_founded, facebook, twitter
    map(1:nrow(dt), function(i) {
      descripcion <- ifelse(is.na(dt$description[i]), 'Sin información', dt$description[i])
     
      # twitter <- ifelse(is.na(dt$twitter[i]), 'https://twitter.com/', dt$twitter[i])
      # 
      HTML( paste0( '<div class = "name_org">',dt$names_org[i], ' ',
                    '<a href=', dt$facebook[i],'>', tags$img(src = "img/facebook.png"),'</a> ',
                    '<a href=', dt$twitter[i],'>', tags$img(src = "img/twitter.png"),'</a></div>',
                    '<p>', descripcion, '</p>',
                    '<i class="fab fa-twitter"></i>'))
    })
  })
  
  
  observeEvent(input$mapa_viz_marker_click, {
    id = input$mapa_viz_marker_click$id
    showModal(modalDialog(
      title = toupper(input$mapa_viz_marker_click$id),
      easyClose = TRUE,
      footer = modalButton("Cerrar"), 
      uiOutput('map_text_ciudades')
    )
    )
  })
  
  
  output$red_text <- renderUI({
    org <- input$clickRed
    red_inf <- net %>% 
                filter(org_uid %in% org)
    proj <- map(1:nrow(red_inf), 
                function(z){ paste0('<li>',
                                    red_inf$proj_name[z], 
                                    '</li>')}) %>% unlist()
    proj <- paste0(proj, collapse = "")
    HTML(paste0(unique(red_inf$org_name), '</br><b>Proyectos: </b>',
         '<ul>', proj, '</ul>'
         ))
  })
  
  observeEvent(input$clickRed, {
    id = input$clickRed
    showModal(modalDialog(
      title = '',
      easyClose = TRUE,
      footer = modalButton("Cerrar"), 
      uiOutput('red_text')
    )
    )
  })
  
  output$bub_text_ciudades <- renderUI({
    city <- input$hcClicked$id
    dt <- data_filter() %>% filter(name %in% city)
    
    # website, year_founded, facebook, twitter
    map(1:nrow(dt), function(i) {
      descripcion <- ifelse(is.na(dt$description[i]), 'Sin información', dt$description[i])
  
      HTML( paste0( '<div class = "name_org">',dt$names_org[i], ' ',
                    '<a href=', dt$facebook[i],'>', tags$img(src = "img/facebook.png"),'</a> ',
                    '<a href=', dt$twitter[i],'>', tags$img(src = "img/twitter.png"),'</a></div>',
                    '<p>', descripcion, '</p>',
                    '<i class="fab fa-twitter"></i>'))
    })
  })
  
  observeEvent(input$hcClicked, {
    id = input$hcClicked$id
    showModal(modalDialog(
      title = toupper(input$hcClicked$id),
      easyClose = TRUE,
      footer = modalButton("Cerrar"), 
      uiOutput('bub_text_ciudades'), 
      br()
    )
    )
  })
}



shinyApp(ui, server)



