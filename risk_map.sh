#!/bin/bash

#1- isolate the veg, and urb

convert urb.png -matte \( +clone -fuzz 15% -transparent "#b04e9a" \) -compose DstOut -composite urb_iso.png


convert veg.png -matte \( +clone -fuzz 15% -transparent "#874864" \) -compose DstOut -composite veg_iso.png

#2- Obtain an elevation map that matches veg, and urb 

convert urb_iso.png -alpha extract urb_alpha.png
convert veg_iso.png -alpha extract veg_alpha.png

convert elv.png veg_alpha.png -alpha off -compose CopyOpacity -composite veg_elv.png
convert elv.png urb_alpha.png -alpha off -compose CopyOpacity -composite urb_elv.png

#3- Divide the two maps 
composite veg_iso.png -compose Divide veg_elv.png Divide_veg.png
composite urb_iso.png -compose Divide urb_elv.png Divide_urb.png


#4- isolate HL veg and HL urb

convert Divide_veg.png -matte \( +clone -fuzz 25% -transparent "#ff71ab" \) -compose DstOut -composite veg_HL.png

##the color below might need to be changed ###
convert Divide_urb.png -matte \( +clone -fuzz 25% -transparent "#ff71ab" \) -compose DstOut -composite urb_HL.png


#5- use the HL veg Mask to generate LL veg Mask (the same of urb)
convert veg_HL.png -alpha extract veg_HL_alpha.png
convert veg_HL_alpha.png -negate veg_HL_alpha_n.png
composite veg_HL_alpha_n.png -compose Multiply veg_alpha.png veg_LL_alpha.png

convert urb_HL.png -alpha extract urb_HL_alpha.png
convert urb_HL_alpha.png -negate urb_HL_alpha_n.png
composite urb_HL_alpha_n.png -compose Multiply urb_alpha.png urb_LL_alpha.png


#7- color each level with a color corresponding to risk level

convert blue.png veg_HL_alpha.png -alpha off -compose CopyOpacity -composite veg_HL_blue.png

convert red.png veg_LL_alpha.png -alpha off -compose CopyOpacity -composite veg_LL_red.png


convert green.png urb_HL_alpha.png -alpha off -compose CopyOpacity -composite urb_HL_green.png

convert yellow.png urb_LL_alpha.png -alpha off -compose CopyOpacity -composite urb_LL_yellow.png

#8- add the layers together to create the color coded risk map
composite veg_HL_blue.png -compose Plus veg_LL_red.png veg_LLPlusHL.png
composite urb_HL_green.png -compose Plus urb_LL_yellow.png urb_LLPlusHL.png

composite urb_LLPlusHL.png -compose Minus veg_LLPlusHL.png risk_veg_urb.png



