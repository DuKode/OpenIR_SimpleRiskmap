#!/bin/bash

#generate the color plates:

convert -size 8776x7612 xc:"#ff9d9d" red1.png
convert -size 8776x7612 xc:"#ff4e4e" red2.png
convert -size 8776x7612 xc:"#d80000" red3.png
convert -size 8776x7612 xc:"#890000" red4.png

#Unify the coordinate system between the landsat imagery and elevation

gdalwarp -t_srs '+proj=UTM +zone=48 +datum=WGS84' elv.tif elv1.tif


#Resize the georeferenced elevation to match the region of interest

gdalwarp -te 620459.250 -748139.250 870575.250 -531197.250 -ts 8776 7612 elv1.tif elv.tif


#1- isolate the veg, and urb

convert urb.tif -matte \( +clone -fuzz 15% -transparent "#b04e9a" \) -compose DstOut -composite urb_iso.tif


convert veg.tif -matte \( +clone -fuzz 15% -transparent "#874864" \) -compose DstOut -composite veg_iso.tif

#2- Obtain an elevation map that matches veg, and urb 

convert urb_iso.tif -alpha extract urb_alpha.tif
convert veg_iso.tif -alpha extract veg_alpha.tif

convert elv.tif veg_alpha.tif -alpha off -compose CopyOpacity -composite veg_elv.tif
convert elv.tif urb_alpha.tif -alpha off -compose CopyOpacity -composite urb_elv.tif

#3- Divide the two maps 
composite veg_iso.tif -compose Divide veg_elv.tif Divide_veg.tif
composite urb_iso.tif -compose Divide urb_elv.tif Divide_urb.tif


#4- isolate HL veg and HL urb

convert Divide_veg.tif -matte \( +clone -fuzz 25% -transparent "#ff71ab" \) -compose DstOut -composite veg_HL.tif

##the color below might need to be changed ###
convert Divide_urb.tif -matte \( +clone -fuzz 25% -transparent "#ff71ab" \) -compose DstOut -composite urb_HL.tif


#5- use the HL veg Mask to generate LL veg Mask (the same for urb)
convert veg_HL.tif -alpha extract veg_HL_alpha.tif
convert veg_HL_alpha.tif -negate veg_HL_alpha_n.tif
composite veg_HL_alpha_n.tif -compose Multiply veg_alpha.tif veg_LL_alpha.tif

convert urb_HL.tif -alpha extract urb_HL_alpha.tif
convert urb_HL_alpha.tif -negate urb_HL_alpha_n.tif
composite urb_HL_alpha_n.tif -compose Multiply urb_alpha.tif urb_LL_alpha.tif


#7- color each level with a color corresponding to risk level

convert red1.png veg_HL_alpha.tif -alpha off -compose CopyOpacity -composite veg_HL_red1.tif

convert red2.png veg_LL_alpha.tif -alpha off -compose CopyOpacity -composite veg_LL_red2.tif


convert red3.png urb_HL_alpha.tif -alpha off -compose CopyOpacity -composite urb_HL_red3.tif

convert red4.png urb_LL_alpha.tif -alpha off -compose CopyOpacity -composite urb_LL_red4.tif

#8- add the layers together to create the color coded risk map
composite veg_HL_red1.tif -compose Plus veg_LL_red2.tif veg_LLPlusHL.tif
composite urb_HL_red3.tif -compose Plus urb_LL_red4.tif urb_LLPlusHL.tif

composite urb_LLPlusHL.tif -compose Minus veg_LLPlusHL.tif risk-_veg_urb.tif



