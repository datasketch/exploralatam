library(shiny)
library(lfltmagic)

ui <- fluidPage(
  column(1,
        uiOutput("controls"),
        uiOutput("info")
         ),
  column(11,
         uiOutput("viz")
         )
)

server <- function(input,ouput,session){

  output$controls <- renderUI({
    selectInput("chart", "Tipo de gráfico", c("Mapa", "Red"))
  })

  output$info <- renderUI({
    if(is.null(input$selectedOrg))
      return()
    div(
      h4("This is info")
    )
  })

  output$viz <- renderUI({
    if(input$chart == "Mapa"){
      # viz <- lflt_choropleth_Gcd(data = NULL, mapName = "world_countries")

    }
  })

}

