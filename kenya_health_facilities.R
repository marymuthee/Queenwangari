setwd("C:/Users/PC/Desktop/R")#working directory

#calling out the library
library(rgdal)
library(sf)
library(GISTools)
library(ggspatial)
library(ggplot2)
library(leaflet)

#importing kenya counties in geojson format
Counties<-st_read("kenya_counties.GeoJSON")
str(Counties)

#importing the health facilities in Kenya
Healthfacilities<-read.csv("kenya_health_facilities (1).csv")
print(is.data.frame(Healthfacilities))

#creating colour fuction
colorpal=colorFactor(topo.colors(5),Healthfacilities$Type)

#adding basemap layer
basemap<-leaflet()%>%
  
  #creating basemap groups
  addTiles(group = "OSM(default)")%>%
  addProviderTiles(providers$Esri.WorldImagery,group = "Esri.WorldImagery")%>%
  addProviderTiles(providers$CartoDB.Positron,group = "CartoDB.Positron")
basemap%>%
  
#adding overlay data groups
  addPolygons(data = Counties,
              popup=Counties$NAME_1,
              weight =0.5,
              fillOpacity = 0.2,color = "gray",)%>%
  addCircleMarkers(data = Healthfacilities,
                   color = colorpal(Healthfacilities$Type),
                   radius = 0.1,
                   group = "health facilities",
                   clusterOptions = markerClusterOptions(),
                   popup = paste("<h3>Health facility</h3>",
                          "<b>Name:</b>",Healthfacilities$Name,"<br>",
                          "<b>County:</b>",Healthfacilities$County,"<br>",
                          "<b>Type:</b>",Healthfacilities$Type,"<br>",
                          "<b>Ownership:</b>",Healthfacilities$Ownership))%>%
  addLegend(pal=colorpal,position="bottomright",title=" HEALTH FACILITY TYPE",
            values = Healthfacilities$Type)%>%
  addLayersControl(
       baseGroups =c("OSM (default)", "Esri.WorldImagery", "CartoDB.Positron"),
       overlayGroups = c("health facilities"),
       options = layersControlOptions(collapsed = FALSE))
  
  

  
  
