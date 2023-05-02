C=colororder;
addpath(genpath('modismoa'))
addpath(genpath('export_fig'))
addpath(genpath('ntitle'))
addpath(genpath('amt'))
addpath(genpath('subaxis'))
disp('paths added')

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

BaseFile='tisom017_sgfw_SpinUp_m_yr0001-0020_monmean.nc';
Norm_NoFlow_File='tisom017_sgfw_NoFlow_m_yr0021-0021.nc';
Norm_File='tisom017_sgfw_Norm_m_yr0021-0021.nc';
%Low_File='../data/proc/tisom017_sgfw_Low_m_yr0021-0021.nc';
%High_File='../data/proc/tisom017_sgfw_High_m_yr0021-0021.nc';
grdFile='tisom008_canal_grd.nc';
MaskFile='mask_totten.nc';

 % Load model results
Base = loadMelt(grdFile,BaseFile,longrab,latgrab,timegrab);
NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
%Low = loadMelt(grdFile,Low_File,longrab,latgrab,timegrab);
%High = loadMelt(grdFile,High_File,longrab,latgrab,timegrab);

NoFlow_coords = loadCoords(grdFile,longrab,latgrab);
NoFlow_geom = loadGeom(grdFile,longrab,latgrab);
NoFlow_coords.x = NoFlow_coords.x/1000;
NoFlow_coords.y = NoFlow_coords.y/1000;



% apres results
apres_x = 2272.5;
apres_y = -1029.5;
apres_m = 22;

 % load Gourmelen results

GourmelenFile1='TottenBasalMeltRates.tif';

[A,R] = readgeoraster(GourmelenFile1,'outputtype','double');
melt = imread(GourmelenFile1);
melt(melt<-100)=NaN;
Xlims=R.XWorldLimits;
Ylims=R.YWorldLimits;
Xspacing=R.CellExtentInWorldX; %these are both 1000 m.
Yspacing=R.CellExtentInWorldY;
[XX,YY]=ndgrid(Xlims(1)+Xspacing/2:Xspacing:Xlims(2)-Xspacing/2,Ylims(1)+Yspacing/2:Yspacing:Ylims(2)-Yspacing/2); %make a mesh grid for each grid coordinate

meltMask = melt; meltMask(isfinite(meltMask))=1;



GourmelenFile2='basal_melt_map_racmo_firn_air_added_Totten.tif';

[A,R] = readgeoraster(GourmelenFile2,'outputtype','double');
melt2 = imread(GourmelenFile2);
melt2(melt2<-100)=NaN;
Xlims2=R.XWorldLimits;
Ylims2=R.YWorldLimits;
Xspacing2=R.CellExtentInWorldX; %these are both 1000 m.
Yspacing2=R.CellExtentInWorldY;
[XX2,YY2]=ndgrid(Xlims2(1)+Xspacing2/2:Xspacing2:Xlims2(2)-Xspacing2/2,Ylims2(1)+Yspacing2/2:Yspacing2:Ylims2(2)-Yspacing2/2); %make a mesh grid for each grid coordinate

meltMask2 = melt2; meltMask2(isfinite(meltMask2))=1;


% Get basemap
figure(991)
[h,latsm,lonsm,imm]=modismoa('totten glacier',1000,'resolution',750);
close(991)
[xm,ym]=ll2ps(latsm,lonsm);

pause(4)

figure(469)
set(gcf,'pos',[27          59        1533         729])
group_axis=[2.22e6 2.33e6 -1.17e6 -9.85e5]/1000;
group_caxis=[-10 80];
imm_caxis=[13000 17000];


subaxis(1,3,1)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
ylabel('Northings (km)')
grid on, set(gca,'layer','top')
ax2 = axes;
flat_pcolor(XX/1000,YY/1000,flipud(melt)') %plot, but chop the weird extra row/cols
linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none';
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)
%ntitle(' a  Satellite + APRES','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(melt_total,0)),'\pm',num2str(round(err_melt,1)),' m/yr '],'location','northeast','fontsize',12)
xlabel('Eastings (km)')
axis(group_axis)
grid on
set(gca,'layer','top')
hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1022    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
caxis(group_caxis)
cmocean('curl','pivot',0)
axis equal
axis(group_axis)
%hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)
text(2240,-1147,{'Eastern','channel'},'fontsize',12)
text(2310,-1070,{'Law','Dome'},'fontsize',12)
text(2295,-1143,{'Calving front'},'fontsize',12)
text(2245,-1004,{'Grounding','line'},'fontsize',12)


subaxis(1,3,2)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
ylabel('Northings (km)')
grid on, set(gca,'layer','top')
ax2 = axes;
flat_pcolor(XX2/1000,YY2/1000,flipud(melt2)') %plot, but chop the weird extra row/cols
linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)
%ntitle(' a  Satellite + APRES','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(melt_total,0)),'\pm',num2str(round(err_melt,1)),' m/yr '],'location','northeast','fontsize',12)
xlabel('Eastings (km)')
axis(group_axis)
grid on
set(gca,'layer','top')
hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1022    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
caxis(group_caxis)
cmocean('curl','pivot',0)
axis equal
axis(group_axis)
%hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)
text(2240,-1147,{'Eastern','channel'},'fontsize',12)
text(2310,-1070,{'Law','Dome'},'fontsize',12)
text(2295,-1143,{'Calving front'},'fontsize',12)
text(2245,-1004,{'Grounding','line'},'fontsize',12)


subaxis(1,3,3)%,'MT',0.03,'MB',0.06)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.melt(:,:,:),3).*Base.mask_totten_nan);
linkaxes([ax1,ax2])
ax2.XGrid         = 'on';
ax2.YGrid         = 'on';
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)
hold on
contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
grid on
%ylabel('Northings (km)')
xlabel('Eastings (km)')
%ntitle(' b  ROMS','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
%hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)


