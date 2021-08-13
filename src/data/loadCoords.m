function output = loadCoords(grdName,longrab,latgrab);

output.lon = ncread(grdName,'lon_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.lat = ncread(grdName,'lat_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.lon_u = ncread(grdName,'lon_u',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.lat_u = ncread(grdName,'lat_u',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.lon_v = ncread(grdName,'lon_v',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.lat_v = ncread(grdName,'lat_v',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.x = ncread(grdName,'x_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
output.y = ncread(grdName,'y_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);


