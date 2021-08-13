function output = loaduStar(ufileName,vfileName,grdFile,longrab,latgrab,timegrab)
MaskFile='../data/proc/mask_totten.nc';

geom = loadCoords(grdFile,[1 Inf],[1 Inf]);

sustr = double(ncread(ufileName,'sustr'));
%lon_v = double(ncread(ufileName,'lon_v'));
%lat_v = double(ncread(ufileName,'lat_v'));

svstr = double(ncread(vfileName,'svstr'));
%lon_u = double(ncread(vfileName,'lon_u'));
%lat_u = double(ncread(vfileName,'lat_u'));


% convert v data to rho points

% convert u data to rho points

geom.lon_u_mod=convertVelToRho(geom.lon_u,size(geom.lon),'u',2);
geom.lon_v_mod=convertVelToRho(geom.lon_v,size(geom.lon),'v',2);
geom.lat_u_mod=convertVelToRho(geom.lat_u,size(geom.lat),'u',2);
geom.lat_v_mod=convertVelToRho(geom.lat_v,size(geom.lat),'v',2);

sustr_mod=convertVelToRho(sustr,[size(geom.lon),size(sustr,3)],'u',3);
svstr_mod=convertVelToRho(svstr,[size(geom.lon),size(svstr,3)],'v',3);


% calculate ustar
% u* = sqrt(Cd)*sqrt(u^2+v^2)
% =sqrt( Cd*sqrt(u^2+v^2)*sqrt(u^2+v^2) )
% =sqrt(sqrt( Cd^2*sqrt(u^2+v^2)^2*(u^2+v^2) ))
% =( (Cd*sqrt(u^2+v^2)*u)^2 + (Cd*sqrt(u^2+v^2)*v)^2 )^(1/4)
% =( sustr^2 + svstr^2 )^(1/4)
ustar = (sustr_mod.^2 + svstr_mod.^2).^(1/4);

% subset according to longrab,latgrab
if longrab(2)==Inf
	longrab(2) = size(geom.lon,1);
end
if latgrab(2)==Inf
	latgrab(2) = size(geom.lon,2);
end
if timegrab(2)==Inf
	timegrab(2) = size(sustr,3);
end
ustar = ustar(longrab(1):longrab(2),latgrab(1):latgrab(2),timegrab(1):timegrab(2));

% output
output = ustar;

