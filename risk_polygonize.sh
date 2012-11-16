#!/bin/bash

#polygonize riskmap index levels into shapefiles
#Arlene Ducao, 16 November 20112

#invert colors in alpha files
convert urb_LL_alpha.tif -negate urb_LL_inverse.tif
convert urb_HL_alpha.tif -negate urb_HL_inverse.tif
convert veg_LL_alpha.tif -negate veg_LL_inverse.tif
convert veg_HL_alpha.tif -negate veg_HL_inverse.tif

#apply georef data to inverse files
geotifcp -g jak.txt urb_LL_inverse.tif urb_LL_inverse.geo.tif
geotifcp -g jak.txt urb_HL_inverse.tif urb_HL_inverse.geo.tif
geotifcp -g jak.txt veg_LL_inverse.tif veg_LL_inverse.geo.tif
geotifcp -g jak.txt veg_HL_inverse.tif veg_HL_inverse.geo.tif

#output shape files
python /Library/Frameworks/GDAL.framework/Versions/Current/Programs/gdal_polygonize.py veg_LL_inverse.geo.tif -f "ESRI Shapefile" veg_LL_inverse.geo.shp
python /Library/Frameworks/GDAL.framework/Versions/Current/Programs/gdal_polygonize.py veg_HL_inverse.geo.tif -f "ESRI Shapefile" veg_HL_inverse.geo.shp
python /Library/Frameworks/GDAL.framework/Versions/Current/Programs/gdal_polygonize.py urb_HL_inverse.geo.tif -f "ESRI Shapefile" urb_HL_inverse.geo.shp
python /Library/Frameworks/GDAL.framework/Versions/Current/Programs/gdal_polygonize.py urb_LL_inverse.geo.tif -f "ESRI Shapefile" urb_LL_inverse.geo.shp