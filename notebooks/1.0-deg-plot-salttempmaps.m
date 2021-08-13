%load melt rates

latgrab = [0 50]+1;
longrab = [129 200]+1;
timegrab=[0 Inf]+1;
spy=365*60*60*24;
depthgrab = [1 Inf];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

TBaseFile='tisom015_sgfw_NewIniNoRvr_NoTrans_temp_016-020_monmean_clima.nc';
TRvr1File='tisom015_sgfw_NewIniNoRvr_NoTrans_temp_016-020_monmean_clima.nc';
TRvr2File='tisom015_sgfw_NewIniNoRvr_CombinedShtChn_temp_016-020_monmean_clima.nc';
SBaseFile='tisom015_sgfw_NewIniNoRvr_NoTrans_salt_016-020_monmean_clima.nc';
SRvr1File='tisom015_sgfw_NewIniNoRvr_NoTrans_salt_016-020_monmean_clima.nc';
SRvr2File='tisom015_sgfw_NewIniNoRvr_CombinedShtChn_salt_016-020_monmean_clima.nc';
GrdFile='../tisom008_canal_grd.nc';
MaskFile='mask_totten.nc';
disp('loading data')
tempBase =squeeze(double(ncread(TBaseFile,'temp',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));
temp1 =squeeze(double(ncread(TRvr1File,'temp',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));
temp2 =squeeze(double(ncread(TRvr2File,'temp',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));
saltBase =squeeze(double(ncread(SBaseFile,'salt',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));
salt1=squeeze(double(ncread(SRvr1File,'salt',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));
salt2 =squeeze(double(ncread(SRvr2File,'salt',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));

LAT = ncread(GrdFile,'lat_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
LON = ncread(GrdFile,'lon_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
otBase = ncread(TBaseFile,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1]);
ot1 = ncread(TRvr1File,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1]);
ot2 = ncread(TRvr2File,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1]);
mask_rho_nan=ncread(GrdFile,'mask_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_zice_nan=ncread(GrdFile,'mask_zice',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
h = ncread(GrdFile,'h', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
pm = ncread(GrdFile,'pm', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dx=1./pm;
pn = ncread(GrdFile,'pn', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dy=1./pn;
zice=ncread(GrdFile,'zice', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_totten_nan = ncread(MaskFile,'mask_totten',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_totten_nan(mask_totten_nan==0)=NaN;
mask_zice_nan(mask_zice_nan==0)=NaN;
mask_rho_nan(mask_rho_nan==0)=NaN;

% mean & mask melt
Area_totten = dx.*dy.*mask_totten_nan;
Area_zice = dx.*dy.*mask_zice_nan;

% choose depth
tempBase_timeavS = squeeze(nanmean(tempBase(:,:,31,:),4));
temp1_timeavS = squeeze(nanmean(temp1(:,:,31,:),4));
temp2_timeavS = squeeze(nanmean(temp2(:,:,31,:),4));
saltBase_timeavS = squeeze(nanmean(saltBase(:,:,31,:),4));
salt1_timeavS = squeeze(nanmean(salt1(:,:,31,:),4));
salt2_timeavS = squeeze(nanmean(salt2(:,:,31,:),4));

%plot melt rate comparisons

figure
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.06], [0.07 0.06], [0.08 0.08]);
set(gcf,'position',[40 40 1800 1200])

subplot(2,2,1)
flat_pcolor(LON,LAT,temp1_timeavS.*mask_rho_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
cmocean('thermal'),caxis([-2.5 -1.25])
colorbar
grid on
set(gca,'layer','top')
text(114.5,-67.5,'Grounding line','fontsize',15)
text(116.3,-66.64,'Calving front','fontsize',15)
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
ntitle(' a','location','northwest','fontweight','bold','fontsize',16)
%ntitle(['Melt rate ',num2str(round(nanmean(my)*10)/10) '\pm',num2str(round(nanstd(my)*10)/10) ' m/yr'],'fontweight','bold','fontsize',16),
%
%subplot(2,3,2)
%flat_pcolor(LON,LAT,temp2_timeavS.*mask_rho_nan);
%colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
%hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
%hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
%cmocean('thermal'),caxis([-2.5 -1.25])
%colorbar
%grid on
%set(gca,'layer','top')
%ntitle(' b','location','northwest','fontweight','bold','fontsize',16)
%
subplot(2,2,2)
flat_pcolor(LON,LAT,(temp2_timeavS-temp1_timeavS).*mask_rho_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-.2 .2]),cmocean('balance','pivot',0)
colorbar
grid on
set(gca,'layer','top')
ntitle(' b','location','northwest','fontweight','bold','fontsize',16)
%
subplot(2,2,3)
flat_pcolor(LON,LAT,salt1_timeavS.*mask_rho_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
cmocean('haline'),caxis([33.5 34.5])
colorbar
grid on
set(gca,'layer','top')
text(114.5,-67.5,'Grounding line','fontsize',15)
text(116.3,-66.64,'Calving front','fontsize',15)
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
ntitle(' c','location','northwest','fontweight','bold','fontsize',16)
%ntitle(['Melt rate ',num2str(round(nanmean(my)*10)/10) '\pm',num2str(round(nanstd(my)*10)/10) ' m/yr'],'fontweight','bold','fontsize',16),
%
%subplot(2,3,5)
%flat_pcolor(LON,LAT,salt2_timeavS.*mask_rho_nan);
%colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
%hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
%hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
%cmocean('haline'),caxis([33.5 34.5])
%colorbar
%grid on
%set(gca,'layer','top')
%ntitle(' e','location','northwest','fontweight','bold','fontsize',16)
%
subplot(2,2,4)
flat_pcolor(LON,LAT,(salt2_timeavS-salt1_timeavS).*mask_rho_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-.15 .1]),cmocean('balance','pivot',0),
colorbar
grid on
set(gca,'layer','top')
ntitle(' d','location','northwest','fontweight','bold','fontsize',16)
export_fig tempsalt_comparison -pnf -transparent -m2.5

