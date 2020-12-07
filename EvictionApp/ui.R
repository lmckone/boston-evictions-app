#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application
shinyUI(fluidPage(
        tags$head(
          tags$style(HTML("@import url('https://fonts.googleapis.com/css?family=Montserrat|Lora:400,700');
                          h1 {
                          font-family: 'Montserrat', sans-serif;
                          font-weight: bold;
                          line-height: 1.1;
                          color: #000000;
                          }
                          
                          p {
                          font-family: 'Lora';
                          font-weight: 400;
                          line-height: 1.1;
                          color: #58585B;
                          }

                          .selectize-control { 
                          font-family: 'Lora'; 
                          font-size: 16px; 
                          line-height: 28px; 
                          }

                          .selectize-input { 
                          font-family: 'Lora';
                          font-size: 16px; 
                          line-height: 32px;
                          }

                          .selectize-dropdown { 
                          font-family: 'Lora'; 
                          font-size: 16px; 
                          line-height: 28px; 
                          }

                          #propertytable {
                          font-family:'Montserrat';
                          }

                          #evictionTable {
                          font-family:'Lora';
                          }
                          
                          "))
          ),
        
        
        headerPanel(HTML(paste0("<b>","EVICTIONS BY BLOCKGROUP","</b>"))),
          p("      Hover over each block group to see the count of evictions for the property type and statistic that you have selected. Click on  a block group to see a table of evictions in that block group. Click on a red eviction marker for a popup of eviction details. Select or de-select layers using the toggle in the upper right corner."),
          
          p(fluidRow(column(width=4, selectInput(inputId="year", 
                                               label="Year", 
                                               choices = unique(evictionpoints$Year), 
                                               selected='2015')),
                   column(width=4, selectInput(inputId="prop", 
                                               label="Property Type", 
                                               choices = c("All", "Subsidized", "Private Market"))),
                   column(width=4, selectInput(inputId="stat", 
                                               label="Statistic", 
                                               choices = c("Cases", "Executions")))
                          
                          )),
        p(fluidRow(column(width=4, 
                          #uiOutput("propmanSelection")
                          selectInput(inputId="propman", 
                                      label="Property Manager", 
                                      choices = c("All", as.character(levels(evictionpoints$Landlord_1))),
                                      selected="All")),
                   #column(width=4, selectInput(inputId="owner",
                                               #label="Property Owner",
                                               #choices = c("All", as.character(levels(evictionpoints$OWNER))),
                                               #selected="All")),
                   column(width=4, selectInput(inputId="rep",
                                               label = "Landlord Representative",
                                               choices = c("All", as.character(levels(evictionpoints$LandlordRe))),
                                               selected="All")))),

          tableOutput("propertytable"),
        p(),
          leafletOutput("mymap", height=700),
          p(),
          selectInput(inputId="sort",
                      label="Sort By:",
                      choices = c('Docket Date', 
                                  'Amount Owed When Filed', 
                                  'Months Owed', 
                                  'Months Share Owed', 
                                  'Execution Date', 
                                  'Amount Owed When Executed'
                                  )),
          tableOutput("evictionTable")
        )
)
