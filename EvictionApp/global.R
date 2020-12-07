#libraries
require(plyr)
require(dplyr)
require(sqldf)
require(magrittr)
require(ggplot2)
require(ggmap)
require(tidyr)
require(reshape2)
require(extrafont)
require(plotly)
require(extrafont)
require(leaflet)
require(shiny)
require(maps)
require(rgdal)
require(htmltools)
require(stringr)
require(readr)
require(lubridate)
require(shiny)
require(gdata)

#read blockgroup shp file
blockgroups <- readOGR("Data/allevictionsbg.shp", layer = "allevictionsbg", GDAL1_integer64_policy = TRUE)

#read eviction point file
#evictionpoints <- readOGR(dsn="Data", layer="evictions_owner")
evictionpoints <- readOGR(dsn="Data", layer="evictionowners")

#set bins
bins <- c(0, 1, 5, 12, 30, 50, Inf)

#set palette
bostonPalette2 <- c("#ffffff", "#6280DF", "#9AA9D8", "#D79D9A", "#DD6862", "#E3342B")

#set bin pal
pal <- colorBin(bostonPalette2, domain = blockgroups$Count_, bins = bins)
