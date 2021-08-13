%load melt rates

latgrab = [0 50]+1;
longrab = [129 200]+1;
timegrab=[0 Inf]+1;
spy=365*60*60*24;
depthgrab = [1 Inf];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

DyeFile='tisom015_sgfw_NewIniNoRvr_CombinedShtChn_dye_01_016-020_monmean.nc';
GrdFile='../tisom008_canal_grd.nc';
MaskFile='mask_totten.nc';
disp('loading data')
DyeConc =squeeze(double(ncread(DyeFile,'dye_01',[longrab(1) latgrab(1) depthgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 depthgrab(2)-depthgrab(1)+1 timegrab(2)-timegrab(1)+1])));

LAT = ncread(GrdFile,'lat_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
LON = ncread(GrdFile,'lon_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
otDye = ncread(DyeFile,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1]);
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
DyeConc_S = squeeze(DyeConc(:,:,31,:));
DyeConc_I = squeeze(nansum(DyeConc,3));

% enforce positivity
DyeConc_I(DyeConc_I<0)=0;

% scale to percentage
DyeConc_I = DyeConc_I*100;

figure
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.06], [0.07 0.06], [0.08 0.08]);
set(gcf,'position',[40 40 1000 1000])
for ttt=1:24
hplot=flat_pcolor(LON,LAT,log10(squeeze(DyeConc_I(:,:,ttt)).*mask_rho_nan));
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
%hold on,contour(LON,LAT,h,[20:1:21],'g-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'m:','linewidth',2) %icefront line
cmocean('ice'),caxis([-3 2])
h_cb=colorbar; ylabel(h_cb,'concentration (log_{10})')
grid on
set(gca,'layer','top')
%text(114.5,-67.5,'Grounding line','fontsize',15)
%text(116.3,-66.64,'Calving front','fontsize',15)
htit=ntitle(['model year ',num2str(round(ttt/12*10)/10),' '],'location','southeast','fontsize',15,'fontweight','bold')
set(gcf,'position',[40 40 1000 1000])
if ttt==1
%text(113.5,66.4,['model year ',num2str(ttt/12)],'fontsize',15)
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
gif('myfile.gif','DelayTime',0.2,'frame',gcf)
else
   gif
end
delete(htit)
end





figure
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.06], [0.07 0.06], [0.08 0.08]);
set(gcf,'position',[40 40 1000 1000])
for ttt=1:24
%hplot=flat_pcolor(LON,LAT,log10(squeeze(DyeConc_I(:,:,ttt)).*mask_rho_nan));
nanz = isnan(squeeze(DyeConc_I(:,:,ttt)).*mask_rho_nan);% Determine which grid cells are NaN:
dye = inpaint_nans(squeeze(DyeConc_I(:,:,ttt)).*mask_rho_nan,4);% Inpaint all the NaN grid cells:
dyer = imresize(dye,10);% Resize the grids by a factor of 10x10:
nansr = imresize(nanz,10);
LONr = imresize(LON,10);
LATr = imresize(LAT,10);
dyer(nansr) = nan;% Set the original area back to NaN:
dyer(dyer<0)=0;
h_plot=flat_pcolor(LONr,LATr,log10(dyer));
shading interp
ntitle('dye concentration (log_{10})','fontsize',15,'fontweight','bold')
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
%hold on,contour(LON,LAT,h,[20:1:21],'g-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'m:','linewidth',2) %icefront line
cmocean('ice'),caxis([-3 2])
h_cb=colorbar; ylabel(h_cb,'log_{10} concentration')
grid on
set(gca,'layer','top')
%text(114.5,-67.5,'Grounding line','fontsize',15)
%text(116.3,-66.64,'Calving front','fontsize',15)
htit=ntitle(['model year ',num2str(round(ttt/12*10)/10),' '],'location','southeast','fontsize',15,'fontweight','bold')
set(gcf,'position',[40 40 1000 1000])
if ttt==1
%text(113.5,66.4,['model year ',num2str(ttt/12)],'fontsize',15)
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
gif('dye_01_concI.gif','DelayTime',0.2,'frame',gcf)
else
   gif
end
delete(htit)
end





