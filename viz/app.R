library(tidyverse)
library(shiny)
library(leaflet)
library(dsAppWidgets)

cities_base <- read_csv('data/cities_data.csv')

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
     @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');

    .col_viz {
      display: grid;
      grid-template-columns: 0.4fr 0.6fr;
      }

    "))
  ),
  div(class = 'col_viz',
    div(
  uiOutput('controls'),
  uiOutput('text_org')
  ),
  uiOutput('viz')
  )
  )

server <- function(input, output, session) {

  output$controls <- renderUI({
    radioButtons("chart", "Tipo de gráfico", c("Mapa", "Red"))
  })

  output$mapViz <- renderLeaflet({

    labels <- sprintf(
      paste0('<b>País: </b>', cities_base$country,
             '<br/><b>Ciudad: </b>', cities_base$name,
             '<br/>Total organizaciones: ', cities_base$radius
      )) %>% lapply(htmltools::HTML)

    lf <- leaflet() %>%
      addProviderTiles('CartoDB') %>%
      setView(lng = -90, lat = 0, zoom = 3) %>%
      addCircleMarkers(
        lng = cities_base$lon,
        lat = cities_base$lat,
        radius =  scales::rescale(cities_base$radius, to = c(1, 11)),
        color = '#f55d26',
        stroke = FALSE,
        fillOpacity = 0.7,
        label = labels,
        layerId = cities_base$name)
    lf
  })

  output$text_org <- renderUI({
    p_sel <- input$mapViz_marker_click$id

    if (is.null(p_sel)) return('Selecciona una Ciudad para ver la lista de organizaciones')

    dt_org <- cities_base %>%
               filter(name %in% p_sel)
    map(dt_org$names_org, function(i) {
      HTML(paste0('<b>', i, '</b><br/>'))
    })
  })

  output$viz <- renderUI({

    inp_viz <- input$chart
    if (is.null(input$chart)) return()

    if (inp_viz == 'Mapa') {
      viz <- leafletOutput('mapViz', width = "100%", height = "900px")
    } else {
      viz <- 'acá va la red'
    }

    viz
  })


}



shinyApp(ui, server)



