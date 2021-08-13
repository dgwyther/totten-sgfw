addpath(genpath('../'))
% set paths
latgrab = [0 Inf]+1;
longrab = [0 Inf]+1;
Ngrab = [0 Inf]+1;
timegrab=[0 Inf]+1;
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';

% specify paths
Norm_dye_File='../data/proc/tisom017_sgfw_Norm_dye_01_yr0021-0021.nc';

% load data
Norm_coords = loadCoords(grdFile,longrab,latgrab);
Norm_geom = loadGeom(grdFile,longrab,latgrab);
mask_totten = loadTottenMask(MaskFile,longrab,latgrab);
mask_totten_nan = mask_totten; mask_totten_nan(mask_totten==0)=NaN;
Mask = loadOtherMask(grdFile,longrab,latgrab);
mask_rho_nan = Mask.mask_rho; mask_rho_nan(Mask.mask_rho==0)=NaN;

DyeConc_Norm = loadTracer(Norm_dye_File,longrab,latgrab,Ngrab,timegrab,'dye_01');

Norm_coords.x = Norm_coords.x/1000;
Norm_coords.y = Norm_coords.y/1000;


% dye specific settings
% choose depth
DyeConc_S = squeeze(DyeConc_Norm(:,:,31,:));
DyeConc_I = squeeze(nansum(DyeConc_Norm,3));
% enforce positivity
DyeConc_I(DyeConc_I<0)=0;
% scale to percentage
DyeConc_I = DyeConc_I*100;

% plots
C=colororder;

panelLabel='abcdefghijkl';
dpm=[1 31; 32 59; 60 90; 91 120; 121 151; 152 181; 182 212; 213 243; 244 273; 274 304; 305 334; 335 365];
snapDay=[1 10 20 30 60 90 120 150];
figure('pos',[301         880   1200         645])
for ii=1:4
	smplot(2,4,ii,'axis','on','right',0.08,'left',0.01)
	to_plot = nanmean(DyeConc_I(:,:,snapDay(ii)),3);
	hplot=flat_pcolor(Norm_coords.x,Norm_coords.y,log10(to_plot).*mask_rho_nan);
	hold on,contour(Norm_coords.x,Norm_coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
	cmocean('ice'),caxis([-3 2])
	axis equal
        axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
        grid on
	set(gca,'layer','top')
	ntitle([' ',panelLabel(ii)],'location','northwest','fontweight','bold','fontsize',12)
	ntitle([' DOY ',num2str(snapDay(ii)),' '],'location','northeast','color','k','fontsize',12)
	if ii==1, gcap=get(gca,'pos'), ylabel('Northings (km)'),set(gca,'pos',gcap), end
	set(gca,'fontsize',11)
end
for ii=5:8
	smplot(2,4,ii,'axis','on','right',0.08,'left',0.01)
        to_plot = nanmean(DyeConc_I(:,:,snapDay(ii)),3);
	hplot=flat_pcolor(Norm_coords.x,Norm_coords.y,log10(to_plot).*mask_rho_nan);
	hold on,contour(Norm_coords.x,Norm_coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
        cmocean('ice'),caxis([-3 2])
	axis equal
	axis([2200 2600 -1200 -700])
	grid on
        set(gca,'layer','top')
        ntitle([' ',panelLabel(ii)],'location','northwest','fontweight','bold','color','k','fontsize',12)
        ntitle({'',[' DOY ',num2str(snapDay(ii))]},'location','northwest','color','k','fontsize',12)
%	axis([105 120 -67.5 -65])
	xlabel('Eastings (km)')
	if ii==5,gcap=get(gca,'pos'), ylabel('Northings (km)'),set(gca,'pos',gcap), end
	set(gca,'fontsize',11)
end
h_cb = colorbar;
set(h_cb,'pos',[0.9210    0.0222    0.0165    0.9344])
set(h_cb,'Ticks',[-3 -2 -1 0 1 2])
set(h_cb,'TickLabels',[1e-3 1e-2 1e-1 1 10 100])
ylabel(h_cb,'Dye concentration (% relative to initial)','fontsize',13)

export_fig Figure4_DyeConc -png -transparent -m3
