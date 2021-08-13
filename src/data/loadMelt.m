function output = loadMelt(grdFile,filename,longrab,latgrab,timegrab)
spy=365*60*60*24;
MaskFile='../data/proc/mask_totten.nc';


meltBase = spy*double(ncread(filename,'m',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));
LAT = ncread(filename,'lat_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
LON = ncread(filename,'lon_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
ot1 = ncread(filename,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1])/spy;
mask_rho_nan=ncread(grdFile,'mask_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_zice_nan=ncread(grdFile,'mask_zice',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
h = ncread(grdFile,'h', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
pm = ncread(grdFile,'pm', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dx=1./pm;
pn = ncread(grdFile,'pn', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dy=1./pn;

zice=ncread(grdFile,'zice', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_zice_nan(mask_zice_nan==0)=NaN;
mask_rho_nan(mask_rho_nan==0)=NaN;

%load Totten mask
mask_totten = loadTottenMask(MaskFile,longrab,latgrab);
mask_totten_nan = mask_totten; mask_totten_nan(mask_totten==0)=NaN;

% mean & mask melt
Area_totten = dx.*dy.*mask_totten_nan;
Area_zice = dx.*dy.*mask_zice_nan;

% compute area av mean
my = squeeze(nansum(nansum(bsxfun(@times,meltBase,Area_totten),2),1)) / squeeze(nansum(nansum(Area_totten,2),1));

% other stats
meltBase_timeav = squeeze(nanmean(meltBase,3));
MLBase_timeav = squeeze(nansum(nansum(meltBase_timeav.*Area_totten.*mask_totten_nan*905.*1e-12,1),2));



output.melt=meltBase;
output.lat=LAT;
output.lon=LON;
output.ot=ot1;
output.mask_rho_nan=mask_rho_nan;
output.mask_zice_nan=mask_zice_nan;
output.h=h;
output.zice=zice;
output.dx=dx;
output.dy=dy;
output.mask_totten_nan=mask_totten_nan;
output.my=my;
output.mtAv=meltBase_timeav;
output.mltAv=MLBase_timeav;
