#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(cluster)
library(readr)
library(factoextra)
library(leaflet)
library(tidyverse)
library(rgdal)
library(shinythemes)

images_list <- list.files(pattern = '.png')
images_cluster <- images_list[grepl('Cluster', images_list)]
images_forest <- images_list[grepl('Forest', images_list)]
heatmap <- images_list[grepl('Unkn', images_list)]

data <- read.csv("az_sources_merged.csv")
#~/shinymap/app/az_sources_merged.csv
datacl <- data %>% 
    mutate(across(Apache:Yuma, as.numeric)) %>% 
    pivot_longer(cols = -c(Time,Source), names_to = 'County')

# county_data <- rgdal::readOGR('gz_2010_us_050_00_500k.json')
# save(county_data, file = 'county_data.Rdata')
load('county_data.Rdata')
data_map <- county_data


# Define UI for application that draws a histogram
ui <- fluidPage(
     theme = shinytheme("lumen"),
    # Application title
    titlePanel("Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
             selectInput('year','Year', choices = unique(datacl$Time)),
            # sliderInput('year','Year',value = min(unique(datacl$Time)),
            #             step = 1,
            #             min = min(unique(datacl$Time)), max = max(unique(datacl$Time))),
            selectInput('factor','Factor', choices = unique(datacl$Source)),
            selectInput('county','County',
                        choices = c('All',datacl$County))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                
                tabPanel("Map",
                         br(), br(),
                         leafletOutput('map')
                         
                         ),
                tabPanel("Cluster",
                          
                         column(6,
                                br(),
                                imageOutput('cluster_images', height = '100%'),
                                br(),
                                imageOutput('cluster_images2', height = '100%'),
                                br(),
                                imageOutput('cluster_images3', height = '100%'),
                                br()
                                ),
                         
                         column(6,
                                br(),
                                imageOutput('cluster_images4', height = '100%'),
                                br(),
                                imageOutput('cluster_images5', height = '100%')
                         )
                         
                     
                         ),
                tabPanel("Forest",
                         
                         column(6,
                                br(),
                                imageOutput('forest_images1', height = '100%')
                         )
                         ),
                tabPanel("Heatmap",
                         
                         column(6,
                                br(),
                                imageOutput('heatmap1', height = '100%'),
                                br(),
                                imageOutput('heatmap2', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap3', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap4', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap5', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap6', height = '100%', width = '80%'),
                                br()
                         ),
                         
                         column(6,
                                br(),
                                imageOutput('heatmap7', height = '100%', width = '30%'),
                                br(),
                                imageOutput('heatmap8', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap9', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap10', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap11', height = '100%', width = '80%'),
                                br(),
                                imageOutput('heatmap12', height = '100%', width = '80%')
                         )
                         )
                ),
            
            plotlyOutput("clustPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$cluster_images <- renderImage({
        list(src = images_cluster[1],alt = "This is alternate text")})
    
    output$cluster_images2 <- renderImage({
        list(src = images_cluster[2],alt = "This is alternate text")})
    
    output$cluster_images3 <- renderImage({
        list(src = images_cluster[3],alt = "This is alternate text")})
    
    output$cluster_images4 <- renderImage({
        list(src = images_cluster[4],alt = "This is alternate text")})
    
    output$cluster_images5 <- renderImage({
        list(src = images_cluster[5],alt = "This is alternate text") })
    
    output$forest_images1 <- renderImage({
        list(src = images_forest[1],alt = "This is alternate text") })
    
    width_heatmap = 600
    output$heatmap1 <- renderImage({
        list(src = heatmap[1],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap2 <- renderImage({
        list(src = heatmap[2],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap3 <- renderImage({
        list(src = heatmap[3],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap4 <- renderImage({
        list(src = heatmap[4],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap5 <- renderImage({
        list(src = heatmap[5],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap6 <- renderImage({
        list(src = heatmap[6],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap7 <- renderImage({
        list(src = heatmap[7],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap8 <- renderImage({
        list(src = heatmap[8],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap9 <- renderImage({
        list(src = heatmap[9],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap10 <- renderImage({
        list(src = heatmap[10],alt = "This is alternate text", width = width_heatmap) })
    output$heatmap11 <- renderImage({
        list(src = heatmap[11],alt = "This is alternate text", width = width_heatmap) })
    # output$heatmap12 <- renderImage({
    #     list(src = heatmap[12],alt = "This is alternate text", width = width_heatmap) })
    
    
    output$map <- renderLeaflet({
        data_map <- county_data
        
        dataj <- datacl %>% 
            filter(Time == input$year) %>% 
            filter(Source == input$factor)
        
        if(input$county != 'All'){
            dataj <- dataj %>% 
                filter(County == input$county)
        }
            
        data_map@data <- data_map@data %>% 
            left_join(
                dataj,
            by = c('NAME' = 'County' )
            ) %>% 
            mutate(value2 = paste(NAME, value))
        
        pal = colorNumeric('RdYlGn', NULL, reverse = T)
        
        leaflet(data_map) %>% 
            addProviderTiles(providers$CartoDB) %>% 
            setView(lat = 34.0489, lng = -111.0937, zoom = 6) %>% 
            addPolygons(label = ~value2, 
                        smoothFactor = 0.9,
                        fillColor = ~pal(value),
                        stroke = F,
                        highlightOptions = highlightOptions(
                            fillOpacity = 0.9, opacity = 0.9,
                            bringToFront = T, sendToBack = T
                        )
                        
                        ) %>% 
            addLegend('bottomleft', pal = pal,
                      values = ~value)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

