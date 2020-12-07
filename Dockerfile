FROM openanalytics/r-base

MAINTAINER Luis Sano-Espinosa "luis.sano@boston.gov"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0 \
    libgeos-dev \
    libgdal-dev \
    libproj-dev



# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

# basic app dependencies 
RUN R -e "install.packages(c('tidyr','readxl','raster','dplyr','shiny','shinydashboard','ggplot2','leaflet','rgdal', 'plotly', 'RColorBrewer', 'scales', 'sqldf', 'magrittr', 'ggmap', 'reshape2', 'extrafont', 'maps', 'htmltools', 'stringr', 'plyr', 'readr', 'lubridate', 'gdata'))"
# copy app to the image 
RUN mkdir /root/evictions
COPY ./EvictionApp /root/evictions/

COPY Rprofile.site /usr/lib/R/etc 

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/evictions')"]
