setwd("C:/Users/PC/Desktop/R")#sets the working directory


#importing the sample points 
elevationdata<-read.csv(file = "sample_points.csv")
head(elevationdata)
str(elevationdata)

#calling the libraries with packages to be used
library(ggplot2)
library(ggspatial)
library(sp)
library(rgdal)
library(sf)

#importing the kenya counties Geojson
counties2<-st_read("kenya_counties.GeoJSON")
str(counties2)
head(counties2)


#plotting the two features
ggplot()+
  geom_sf(data = counties2, color ="black", aes(fill="Counties"))+
  geom_point(data=elevationdata,aes(x,y, colour="Points"))+
  scale_fill_manual(values=c("Counties"="lightyellow"))+
  scale_color_manual(values=c("Points"="darkblue"))+
  labs(fill="")+
  labs(colour="")+
  
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering,
                         pad_x = unit(-0.1, "in"), pad_y = unit(-0.1, "in"),
                         height = unit(1.1, "cm"),
                         width = unit(1.5, "cm"))+
  theme_set(theme(legend.key=element_blank()))+ 
  xlab("Longitude") + ylab("Latitude")+
  ggtitle("KENYA COUNTIES ELEVATIONS")
#creating color function
Color_pal=colorNumeric(palette ="magma",domain=elevationdata$elev)
library(leaflet)#library to be used

 basemap<-leaflet()%>%
   
   #creting basemap groups
     addTiles(group = "OSM (default)") %>%
addProviderTiles(providers$Esri.WorldImagery, group = "Esri.WorldImagery") %>%
    addProviderTiles(providers$CartoDB.Positron, group = "CartoDB.Positron") 
   basemap %>%
     
     #adding kenya counties GeoJson as ploygons
    addPolygons(data=counties2,popup =counties2$NAME_1,weight = 0.5,
                                fillOpacity = 0.2,color = "gray" )%>%
     
     #adding elevation data using circles as the markers
   addCircleMarkers(data = elevationdata,color =Color_pal(elevationdata$elev),
                                          radius = elevationdata$elev/25000,
                                          popup = paste("<p>","ELEVATION",
                                                                                         
                                         round(elevationdata$elev,2)
                                         ,
                                              "<p>"),group = "elevation",
                    clusterOptions = markerClusterOptions())%>%
     addLegend(pal=Color_pal,position = "bottomright",title = "ELEVATION",
               values=elevationdata$elev)%>%
       addLayersControl(
      baseGroups = c("OSM (default)", "Esri.WorldImagery", "CartoDB.Positron"),
           overlayGroups = c("elevation"),
           options = layersControlOptions(collapsed = FALSE)
        )

