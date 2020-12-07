#This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic 
shinyServer(function(input, output) {
  
  #assign evictionpoints the same project as blockgroups
  evictionpoints@proj4string <- CRS("+proj=lcc +lat_1=41.71666666666667 +lat_2=42.68333333333333 +lat_0=41 +lon_0=-71.5 +x_0=199999.9999999999
                                    +y_0=750000 +datum=NAD83 +units=us-ft +no_defs +ellps=GRS80 +towgs84=0,0,0")
  
  #output$propmanSelection <- renderUI({
  #  selectInput("propmanSelection", 
  #              label = "Property Manager:", 
  #              choices = c("All", as.character(levels(evictionpoints$Landlord_1[evictionpoints$Year==input$year]))))
  #})
  
  
  #change this value based on user input for property type
  props2 = reactive({
    if (input$prop=="Subsidized") props <- 'S' 
    else if (input$prop=="Private Market") props <- 'PM' 
    else props <- levels(evictionpoints$Subsidiz_1)
  })
  
  #change this value based on user input for statistic
  stats2 = reactive({
    if (input$stat=="Executions") stats <- 'Y' else stats <- c('Y', 'N')
  })
  
  #owner2 = reactive({
  #  if(input$owner=="All") owners <- levels(evictionpoints$OWNER)
  #  else owners <- input$owner
  #})
  
  rep2 = reactive({
    if(input$rep=="All") reps <- levels(evictionpoints$LandlordRe)
    else reps <- input$rep
  })
  
  #change this value based on user input for property manager
  propmans2 = reactive({
    #if(input$propman=="WINN") propmans <- 'WINN'
    #else if(input$propman=="BHA") propmans <- 'BHA'
    #else if(input$propman=="MAL") propmans <- 'MAL'
    #else if(input$propman=="TRIN") propmans <- 'TRIN'
    #else if(input$propman=="CRUZ") propmans <- 'CRUZ'
    #else if(input$propman=="BRM") propmans <- 'BRM'
    #else propmans <- levels(evictionpoints$Landlord_1)
    if(input$propman=="All") propmans <- levels(evictionpoints$Landlord_1)
    else propmans <- input$propman
    #if(input$propmanSelection=="All") propmans <- levels(evictionpoints$Landlord_1)
    #else propmans <- input$propmanSelection
  })
  
  
  
  #change this value based on user input for property manager
  sort2 = reactive({
    if(input$sort=="Docket Date") sort <- 'DocketDate'
    else if(input$sort=="Amount Owed When Filed") sort <- 'AmountOwed'
    else if(input$sort=="Months Owed") sort <- 'MonthsOwed'
    else if(input$sort=="Months Share Owed") sort <- 'MoShareOwe'
    else if(input$sort=="Execution Date") sort <- 'ExecutionD'
    else if(input$sort=="Amount Owed When Executed") sort <- 'OwedWhenEx'
    else sort <- 'DocketDate'
  })
  
  
  #change this value based on user input for year
  year2 = reactive({
    #if(input$year==2014) year <- 2014
    #else if(input$year==2015) year <- 2015
    year <- input$year
  })
  
  
  
  #filter eviction points based on user input
  evictionpoints2 = reactive({
    points <- evictionpoints[which(evictionpoints$Subsidiz_1%in%props2()),]
    points <- points[which(points$ExecutionI%in%stats2()),]
    points <- points[which(points$Landlord_1%in%propmans2()),]
    points <- points[which(points$Year%in%year2()),]
    points <- points[which(points$LandlordRe%in%rep2()),]
    #points <- points[which(points$OWNER%in%owner2()),]
    points
  })
  
  
  
  #render map based on user input
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
      addProviderTiles(providers$Stamen.TonerBackground) %>%
      addProviderTiles(providers$Stamen.TonerLines,
                       options = providerTileOptions(opacity = 0.35)) %>%
      addProviderTiles(providers$Stamen.TonerLabels) %>%
      addCircleMarkers(data=evictionpoints2(), 
                       lat=~as.numeric(MatchLatit), 
                       lng=~as.numeric(MatchLongi), 
                       radius=0.5, 
                       layerId=~DocketNo, 
                       opacity = .5,
                       group="Evictions",
                       color="#E3342B",
                       popup = ~StreetAddr) %>%
      #add neighborhood labels
      addLabelOnlyMarkers(
        lng=-71.100384, lat=42.343511, 
        label='FENWAY',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.091491, lat=42.316078, 
        label='ROXBURY',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.105223, lat=42.330166, 
        label='MISSION HILL',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.077586, lat=42.339557, 
        label='SOUTH END',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.080848, lat=42.350976, 
        label='BACK BAY',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.061579, lat=42.352752, 
        label='CHINATOWN',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.070550, lat=42.366537, 
        label='WEST END',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.055227, lat=42.365056, 
        label='NORTH END',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.058059, lat=42.359221, 
        label='DOWNTOWN',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.040893, lat=42.345964, 
        label='WATERFRONT',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.047674, lat=42.338542, 
        label='SOUTH BOSTON',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.126898, lat=42.284170, 
        label='ROSLINDALE',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.090506, lat=42.278709, 
        label='MATTAPAN',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.124495, lat=42.257621, 
        label='HYDE PARK',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.163877, lat=42.280995, 
        label='WEST ROXBURY',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.067675, lat=42.302582, 
        label='DORCHESTER',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.036432, lat=42.371357, 
        label='EAST BOSTON',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.060486, lat=42.378554, 
        label='CHARLESTOWN',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      addLabelOnlyMarkers(
        lng=-71.115204, lat=42.310072, 
        label='JAMAICA PLAIN',
        labelOptions = labelOptions(noHide=T, textOnly=T, textsize = "14px", style=list(
          'color'='#000000',
          'font-family'= 'Montserrat',
          'font-style' = 'bold',
          'font-size' = '14px',
          'border-color' = '#ffffff'
        ))
      ) %>%
      #allow the user to decide which layers to display on the map
      addLayersControl(overlayGroups = c("Block Groups", "Evictions"), 
                       options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup("Evictions") #eviction points hidden by default
  })
  
  
  
  #render blockgroup chloropleth based on user input
  observe({
    blockgroups <- spTransform(blockgroups, CRS("+proj=lcc +lat_1=41.71666666666667 +lat_2=42.68333333333333 +lat_0=41 +lon_0=-71.5 +x_0=199999.9999999999
                                                +y_0=750000 +datum=NAD83 +units=us-ft +no_defs +ellps=GRS80 +towgs84=0,0,0"))
    x <- aggregate(evictionpoints2()["DocketNo"], by=blockgroups, FUN=length) #aggregate evictions by block group
    blockgroups$n_evictions <- x$DocketNo #create n_evictions field based on the output of the aggregate function
    blockgroups$n_evictions[which(is.na(blockgroups$n_evictions))] <- 0
    blockgroups <- blockgroups[blockgroups$GEOID!=250259901010,] #get rid of harbor tract
    #get rid of winthrop tracts
    blockgroups$TRACTCE <- as.character(blockgroups$TRACTCE)
    blockgroups <- blockgroups[which(!startsWith(blockgroups$TRACTCE, '16')),]
    blockgroups <- blockgroups[which(!startsWith(blockgroups$TRACTCE, '17')),]
    blockgroups <- blockgroups[which(!startsWith(blockgroups$TRACTCE, '18')),]
    blockgroups <- spTransform(blockgroups, CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0 "))
    leafletProxy("mymap", data=blockgroups) %>%
      addPolygons(fillColor = ~pal(n_evictions),
                  weight = 1,
                  opacity = 1,
                  color = "gray",
                  fillOpacity = 0.8,  
                  highlightOptions = highlightOptions(color = "white",
                                                      weight = 2,
                                                      bringToFront = TRUE),
                  label = ~as.character(n_evictions),
                  layerId=~GEOID,
                  group="Block Groups") %>%
      addLegend("bottomright", pal = pal, values = ~n_evictions,
                title = "Number of evictions",
                opacity = 1
      )
  })
  
  
  output$propertytable <- renderTable({
    table <- data.frame(evictionpoints2())
    out <- data.frame(length(table$Landlord_1))
    names(out) <- "Count for selected statistic"
    out
  })
  
  #render Table based on user input and selected map polygon
  observeEvent(input$mymap_shape_click, { #
    p <- input$mymap_shape_click
    output$evictionTable <- renderTable({
      blockgroups <- spTransform(blockgroups, CRS("+proj=lcc +lat_1=41.71666666666667 +lat_2=42.68333333333333 +lat_0=41 +lon_0=-71.5 +x_0=199999.9999999999
                                                  +y_0=750000 +datum=NAD83 +units=us-ft +no_defs +ellps=GRS80 +towgs84=0,0,0"))
      #retrieve indices for which evictions fall within the clicked polygon
      indices <- !is.na(over(as(evictionpoints2(), "SpatialPoints"), as(blockgroups[blockgroups$GEOID==p$id,], "SpatialPolygons")))
      
      table <- select(data.frame(evictionpoints2())[indices,], 
                      c(DocketNo,
                        DocketDate,
                        Reason,
                        StreetAddr,
                        Zip,
                        Landlord_1,
                        #OWNER,
                        SiteRepres, 
                        LandlordRe, 
                        AmountOwed, 
                        MonthsOwed, 
                        MoShareOwe, 
                        AnswerDisc, 
                        LegalRepre, 
                        TenantRepr, 
                        Subsidiz_1, 
                        AgreementT,
                        Ruling, 
                        ExecutionI, 
                        ExecutionD, 
                        OwedWhenEx, 
                        ExecutionR, 
                        CaseNotes))
      names(table) <- c("Docket Number", "Docket Date", "Reason", "Address", "ZIP", "Landlord Name", "Site Represented",
                        "Landlord Representative", "Amount Owed When Filed", "Months Owed", "Months Share Owed", "Answer Discovery Filed?",
                        "Legal Representation", "Tenant Representative", "Subsidized or Private Market", "Agreement Type", "Ruling", "Execution Issued",
                        "Execution Date", "Amount Owed When Executed", "Execution Returned", "Case Notes")
      table
      
    })
    
  })
  
})