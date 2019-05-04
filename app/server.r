library(shiny)
library(ggplot2)
library(ggthemes)
library(magrittr)
library(leaflet)
library(dplyr)

pizza <- jsonlite::fromJSON(
    'FavoriteSpots.json'
) %>% 
    tidyr::unnest()

house3 <- readr::read_rds('house3.rds')
house_new <- readr::read_rds('house_new.rds')

shinyServer(function(input, output, session){
    
    output$Preds <- renderTable({
        predict(house3, newx=house_new, 
                s=as.numeric(input$Lambda))
    })
    
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
        leaflet(
            data=pizza %>% 
                dplyr::slice(
                    as.integer(
                        input$PizzaTable_rows_selected
                    )
                )
        ) %>% 
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
