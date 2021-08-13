function output = loadOtherMask(grdFile,longrab,latgrab)

output.mask_rho = ncread(grdFile,'mask_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.mask_zice = ncread(grdFile,'mask_zice',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);




