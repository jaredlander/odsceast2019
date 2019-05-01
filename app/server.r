library(shiny)
library(ggplot2)
library(ggthemes)
library(magrittr)
library(leaflet)

pizza <- jsonlite::fromJSON(
    'FavoriteSpots.json'
) %>% 
    tidyr::unnest()

shinyServer(function(input, output, session){
    
    output$DisplayCountry <- renderText(
        input$CountrySelector
    )
    
    output$CarHist <- renderPlot({
        ggplot(mtcars, aes_string(input$CarColumn)) +
            geom_histogram() + 
            theme_economist() + 
            scale_color_economist()
    })
    
    output$PizzaTable <- DT::renderDataTable({
        pizza
    }, rownames=FALSE)
    
    output$PizzaMap <- leaflet::renderLeaflet({
        leaflet(data=pizza) %>% 
            addProviderTiles(
                provider='Esri.WorldImagery'
            ) %>% 
            addMarkers(
                lng = ~ longitude,
                lat = ~ latitude,
                popup = ~ Name
            )
    })
    
})
