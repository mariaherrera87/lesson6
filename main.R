## Author : Maria Yi
## Date Jan 11

library(sp)
library(rgdal)
library(rgeos)

places <- file.path("/home/user/Desktop/geoscripting/lesson6/Data/places.shp")
railway <- file.path("/home/user/Desktop/geoscripting/lesson6/Data/railways.shp")

# will load the shapefile to your dataset.
railway_shp = readOGR(railway,layer = "railways") 
places_shp = readOGR(places,layer = "places")

# define CRS object for RD projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

## select industrial layer
rail_ind <- subset(railway_shp,type == "industrial")
# perform the coordinate transformation from WGS84 to RD
ind_trans <- spTransform(rail_ind, prj_string_RD)
places_trans <- spTransform(places_shp,prj_string_RD)

ind_buffer <- gBuffer(ind_trans, byid = TRUE, width = 1000)

# intersect industrial area and places
my_intersect <- gIntersection(ind_buffer,places_trans, byid = TRUE)


# Extract the name of the city
cityname <- places_trans[5973,]$name
mydata <- data.frame(id = 1, Name = cityname)
Citypoints <- SpatialPointsDataFrame(my_intersect, data = mydata, proj4string=prj_string_RD)

plot(ind_buffer, pch= 19, cex=0.3, col = "grey",axes = T)
plot(Citypoints, pch= 19, cex=1, col = "red", add = TRUE)
grid()
text(Citypoints,labels = Citypoints$Name)

## names       :    osm_id,    name, type, population 
## min values  : 235861650, Utrecht, city,     100000 

