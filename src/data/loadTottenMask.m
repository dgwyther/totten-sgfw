function output = loadTottenMask(MaskFile,longrab,latgrab)

output = ncread(MaskFile,'mask_totten',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);



