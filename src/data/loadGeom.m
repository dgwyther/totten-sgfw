function output = loadGeom(grdFile,longrab,latgrab);

%load zice and bathymetry
h = ncread(grdFile,'h', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
zice = ncread(grdFile,'zice', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);

output.h = h;
output.zice = zice;
