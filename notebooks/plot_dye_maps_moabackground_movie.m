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



% Get basemap
figure(991)
[h,latsm,lonsm,imm]=modismoa('totten glacier',1000,'resolution',750);
close(991)
[xm,ym]=ll2ps(latsm,lonsm);


% plots
C=colororder;
imm_caxis=[13000 17000];
panelLabel='abcdefghijkl';
dpm=[1 31; 32 59; 60 90; 91 120; 121 151; 152 181; 182 212; 213 243; 244 273; 274 304; 305 334; 335 365];
snapDay=[1 10 20 30 60 90 120 150];



v = VideoWriter('dye_concentration.avi');
open(v);

figure('pos',[301         880   1200         645])

for ii=1:365
	to_plot = nanmean(DyeConc_I(:,:,ii),3);
	subaxis(1,3,1,'SV',0.03,'SH',0.03)
	ax1=gca;
	flat_pcolor(xm/1000,ym/1000,imm), axis equal
	ylabel('Northings (km)')
	xlabel('Eastings (km)')
	ax2 = axes;

	hplot=flat_pcolor(Norm_coords.x,Norm_coords.y,log10(to_plot).*mask_rho_nan);

	linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)

	hold on,contour(Norm_coords.x,Norm_coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
	cmocean('ice'),caxis([-3 2])
	axis equal
        axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
        grid on
	set(gca,'layer','top')
	ntitle([' a'],'location','northwest','fontweight','bold','fontsize',14)
	if ii==1, gcap=get(gca,'pos'); ylabel('Northings (km)'),set(gca,'pos',gcap), end
	set(gca,'fontsize',11)
	set(gca,'nextplot','replacechildren'); 



	subaxis(1,3,[2:3],'SV',0.03,'SH',0.03)
        to_plot = nanmean(DyeConc_I(:,:,ii),3);

	ax1=gca;
	flat_pcolor(xm/1000,ym/1000,imm), axis equal
	ylabel('Northings (km)')
	xlabel('Eastings (km)')
	ax2 = axes;

	hplot=flat_pcolor(Norm_coords.x,Norm_coords.y,log10(to_plot).*mask_rho_nan);

	linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)

	hold on,contour(Norm_coords.x,Norm_coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
        cmocean('ice'),caxis([-3 2])
	axis equal
	ylim([-1200 -700]),xlim([2200 2700])
	grid on
        set(gca,'layer','top')
        ntitle([' b'],'location','northwest','fontweight','bold','color','k','fontsize',14)
%	axis([105 120 -67.5 -65])
	xlabel('Eastings (km)')
	if ii==5,gcap=get(gca,'pos'); ylabel('Northings (km)'),set(gca,'pos',gcap), end
	set(gca,'fontsize',11)



sgtitle(['DOY: ',num2str(ii)])

h_cb = colorbar;
set(h_cb,'pos',[0.9210    0.0222    0.0165    0.9344])
set(h_cb,'Ticks',[-3 -2 -1 0 1 2])
set(h_cb,'TickLabels',[1e-3 1e-2 1e-1 1 10 100])
ylabel(h_cb,'Dye concentration (% relative to initial)','fontsize',13)
set(gcf,'pos',[100         440        1074         505])

drawnow
frame = getframe(gcf);
   writeVideo(v,frame);
   
cla; clf

end

close(v);




%%%%%%%%



v = VideoWriter('dye_concentration_zoom.avi');
open(v);

figure('pos',[100   440   400   330])

for ii=1:365

        to_plot = nanmean(DyeConc_I(:,:,ii),3);

	ax1=gca;
	flat_pcolor(xm/1000,ym/1000,imm), axis equal
	ylabel('Northings (km)')
	xlabel('Eastings (km)')
	ax2 = axes;

	hplot=flat_pcolor(Norm_coords.x,Norm_coords.y,log10(to_plot).*mask_rho_nan);

	linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)

	hold on,contour(Norm_coords.x,Norm_coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
        cmocean('ice'),caxis([-3 2])
	axis equal
	ylim([-1200 -700]),xlim([2200 2700])
	grid on
        set(gca,'layer','top')
%	axis([105 120 -67.5 -65])
	xlabel('Eastings (km)')
	if ii==5,gcap=get(gca,'pos'); ylabel('Northings (km)'),set(gca,'pos',gcap), end
	set(gca,'fontsize',11)



sgtitle(['DOY: ',num2str(ii)])

h_cb = colorbar;
set(h_cb,'pos',[0.9210    0.0222    0.0165    0.9344])
set(h_cb,'Ticks',[-3 -2 -1 0 1 2])
set(h_cb,'TickLabels',[1e-3 1e-2 1e-1 1 10 100])
ylabel(h_cb,'Dye concentration (% relative to initial)','fontsize',13)

drawnow
frame = getframe(gcf);
   writeVideo(v,frame);
   
cla; clf

end

close(v);




%export_fig Figure4_DyeConc_bg -png -transparent -m3
