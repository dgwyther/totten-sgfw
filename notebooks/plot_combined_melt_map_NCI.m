addpath(genpath('../'))
C=colororder;
addpath(genpath('/home/581/deg581/modismoa'))
addpath(genpath('/home/581/deg581/export_fig'))
addpath(genpath('/home/581/deg581/ntitle'))
addpath(genpath('/home/581/deg581/amt'))
addpath(genpath('/home/581/deg581/subaxis'))
addpath(genpath('/home/581/deg581/flat_pcolor'))
addpath('/g/data/jk72/deg581/')

disp('paths added')

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

BaseFile='../data/proc/tisom017_sgfw_SpinUp_m_yr0001-0020_monmean.nc';
Norm_NoFlow_File='../data/proc/tisom017_sgfw_NoFlow_m_yr0021-0021.nc';
Norm_File='../data/proc/tisom017_sgfw_Norm_m_yr0021-0021.nc';
%Low_File='../data/proc/tisom017_sgfw_Low_m_yr0021-0021.nc';
%High_File='../data/proc/tisom017_sgfw_High_m_yr0021-0021.nc';
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';

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

 % do stats
field = (nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100;

field_pos = field; field_pos(field_pos<0)=NaN;
field_neg = field; field_neg(field_neg>0)=NaN;

meanpos=nanmean(field_pos(:));
meanneg=nanmean(field_neg(:));

%better stats

field = (nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Norm.mask_totten_nan-1)*100;

field_pos = field; field_pos(field_pos<0)=NaN;
field_neg = field; field_neg(field_neg>0)=NaN;

field_pos_mask = field_pos; field_pos_mask(isfinite(field_pos))=1;
field_neg_mask = field_neg; field_neg_mask(isfinite(field_neg))=1;


meanval=nanmean(field(:))
meanpos=nanmean(field_pos(:))
meanneg=nanmean(field_neg(:))

mean_weighted = squeeze(nansum(nansum(field.*Norm.dx.*Norm.dy,2),1) )/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))
meanpos_weighted = squeeze(nansum(nansum(field_pos.*Norm.dx.*Norm.dy,2),1) )/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))
meanneg_weighted = squeeze(nansum(nansum(field_neg.*Norm.dx.*Norm.dy,2),1) )/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))


% apres results
apres_x = 2272.5;
apres_y = -1029.5;
apres_m = 22;

 % load Gourmelen results

GourmelenFile='../data/raw/TottenBasalMeltRates.tif';

[A,R] = readgeoraster(GourmelenFile,'outputtype','double');
melt = imread(GourmelenFile); 
melt(melt<-100)=NaN;
Xlims=R.XWorldLimits;
Ylims=R.YWorldLimits;
Xspacing=R.CellExtentInWorldX; %these are both 1000 m.
Yspacing=R.CellExtentInWorldY;
[XX,YY]=ndgrid(Xlims(1)+Xspacing/2:Xspacing:Xlims(2)-Xspacing/2,Ylims(1)+Yspacing/2:Yspacing:Ylims(2)-Yspacing/2); %make a mesh grid for each grid coordinate

meltMask = melt; meltMask(isfinite(meltMask))=1;

%areaMask=meltMask'; areaMask(XX>2335e3)=NaN; areaMask(XX<2150e3)=NaN; areaMask(YY>-980e3)=NaN; areaMask(YY<-1154.586e3)=NaN;
areaMask=nan(size(meltMask)); areaMask(238:402,218:322)=meltMask(238:402,218:322);
area_km2 = nansum(areaMask(:))

melt_nan = melt; melt_nan(melt<-20)=NaN; melt_nan(melt>200)=NaN;

melt_total = nanmean(nanmean(melt_nan.*areaMask))
ML_nan_total = nansum(nansum(melt_nan.*areaMask*1000*1000*905*1e-12))

errr=.115;%*100%
err_ML = ML_nan_total*errr
err_melt = melt_total*errr

Norm_melt = squeeze(nansum(nansum(Norm.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan)))/squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))



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

subaxis(1,3,2)%,'MT',0.03,'MB',0.06)
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
ntitle(' b  ROMS','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)

% scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)

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
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)
ntitle(' a  Satellite + APRES','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(melt_total,0)),'\pm',num2str(round(err_melt,1)),' m/yr '],'location','northeast','fontsize',12)
xlabel('Eastings (km)')
axis(group_axis)
grid on
set(gca,'layer','top')
hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1022    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
caxis(group_caxis)
cmocean('curl','pivot',0)
axis equal
axis(group_axis)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)
text(2240,-1147,{'Eastern','channel'},'fontsize',12)
text(2310,-1070,{'Law','Dome'},'fontsize',12)
text(2295,-1143,{'Calving front'},'fontsize',12)
text(2245,-1004,{'Grounding','line'},'fontsize',12)


% add N arrow
ps1=[2234.541e3,-1021.968e3];
[ll1(1),ll1(2)]=ps2ll(ps1(1),ps1(2));
ll2=ll1; ll2(1) = ll2(1)+.15;
[ps2(1),ps2(2)]=ll2ps(ll2(1),ll2(2));

% so much juryrigging to fix broken matlab....
xL=xlim;
yL=ylim;
ah=gca;
aPos=ah.Position;
ahx = [aPos(1), aPos(1)+aPos(3)];
ahy = [aPos(2), aPos(2)+aPos(4)];

x1p = interp1(xL, ahx, ps1(1)/1000);
x2p = interp1(xL, ahx, ps2(1)/1000);
y1p = interp1(yL, ahy, ps1(2)/1000);
y2p = interp1(yL, ahy, ps2(2)/1000);

arh = annotation('arrow');
arh.Units = 'normalized';
arh.Position = [x1p, y1p, x2p-x1p, y2p-y1p];
arh.LineWidth=2;
arh.HeadStyle='vback1';
arh.HeadLength=8;
arh.HeadWidth=10;
text(ps2(1)/1000,ps2(2)/1000,'N','fontsize',12,'fontweight','bold')


subaxis(1,3,3)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
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
contour(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
grid on
set(gca,'layer','top')
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' c  ROMS with/without SGFW','location','northwest','fontweight','bold', 'fontsize',14)
%ntitle({[' '],['total change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'% '],['mean inc.: ',num2str(round(meanpos,1)),'% '],['mean dec.: ',num2str(round(meanneg,1)),'% ']},'location','northeast','fontsize',12)
ntitle({[' '],['total change: ',num2str(round(mean_weighted)),'% '],['mean inc.: ',num2str(round(meanpos_weighted,1)),'% '],['mean dec.: ',num2str(round(meanneg_weighted,1)),'% ']},'location','northeast','fontsize',12)
h_cb = colorbar;
title(h_cb,'% diff to no flow')
xlabel('Eastings (km)')
axis equal
axis(group_axis)
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
set(h_cb,'pos',[0.9520    0.1043    0.0201    0.7968])

if 0
	disp('saving figure')
export_fig Figure_combined_meltrates -png -transparent -m5
end



%%



% Get basemap
figure(992)
[h,latsm,lonsm,imm]=modismoa('totten glacier',1000,'resolution',750);
close(992)
[xm,ym]=ll2ps(latsm,lonsm);

pause(4)

figure(466)
set(gcf,'pos',[27          59        1833         629])
group_axis=[2.22e6 2.33e6 -1.17e6 -9.85e5]/1000;
group_caxis=[-10 80];
imm_caxis=[13000 17000];

subaxis(1,4,2)%,'MT',0.03,'MB',0.06)
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
ntitle(' b  ROMS (with SGFW)','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)

% scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)

subaxis(1,4,1)
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
ax2.Color='none'
colormap(ax1,'gray')
set(ax2,'position',get(ax1,'pos'))
caxis(ax1,imm_caxis)
ntitle(' a  Satellite + APRES','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(melt_total,0)),'\pm',num2str(round(err_melt,1)),' m/yr '],'location','northeast','fontsize',12)
xlabel('Eastings (km)')
axis(group_axis)
grid on
set(gca,'layer','top')
%hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1022    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
caxis(group_caxis)
cmocean('curl','pivot',0)
axis equal
axis(group_axis)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)
text(2240,-1147,{'Eastern','channel'},'fontsize',12)
text(2310,-1070,{'Law','Dome'},'fontsize',12)
text(2295,-1143,{'Calving front'},'fontsize',12)
text(2245,-1004,{'Grounding','line'},'fontsize',12)


% add N arrow
ps1=[2234.541e3,-1021.968e3];
[ll1(1),ll1(2)]=ps2ll(ps1(1),ps1(2));
ll2=ll1; ll2(1) = ll2(1)+.15;
[ps2(1),ps2(2)]=ll2ps(ll2(1),ll2(2));

% so much juryrigging to fix broken matlab....
xL=xlim;
yL=ylim;
ah=gca;
aPos=ah.Position;
ahx = [aPos(1), aPos(1)+aPos(3)];
ahy = [aPos(2), aPos(2)+aPos(4)];

x1p = interp1(xL, ahx, ps1(1)/1000);
x2p = interp1(xL, ahx, ps2(1)/1000);
y1p = interp1(yL, ahy, ps1(2)/1000);
y2p = interp1(yL, ahy, ps2(2)/1000);

arh = annotation('arrow');
arh.Units = 'normalized';
arh.Position = [x1p, y1p, x2p-x1p, y2p-y1p];
arh.LineWidth=2;
arh.HeadStyle='vback1';
arh.HeadLength=8;
arh.HeadWidth=10;
text(ps2(1)/1000,ps2(2)/1000,'N','fontsize',12,'fontweight','bold')

subaxis(1,4,3)%,'MT',0.03,'MB',0.06)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
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
ntitle(' c  ROMS (No SGFW)','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)


subaxis(1,4,4)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
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
contour(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
grid on
set(gca,'layer','top')
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' d  ROMS with/without SGFW','location','northwest','fontweight','bold', 'fontsize',14)
%ntitle({[' '],['total change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'% '],['mean inc.: ',num2str(round(meanpos,1)),'% '],['mean dec.: ',num2str(round(meanneg,1)),'% ']},'location','northeast','fontsize',12)
ntitle({[' '],['total change: ',num2str(round(mean_weighted)),'% '],['mean inc.: ',num2str(round(meanpos_weighted,1)),'% '],['mean dec.: ',num2str(round(meanneg_weighted,1)),'% ']},'location','northeast','fontsize',12)
h_cb = colorbar;
title(h_cb,'% diff to no flow')
xlabel('Eastings (km)')
axis equal
axis(group_axis)
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
set(h_cb,'pos',[0.9520    0.1043    0.0201    0.7968])

if 0
	disp('saving figure')
export_fig Figure_combined_meltrates_fourpanel -png -transparent -m5
end


%%


% Get basemap
figure(991)
[h,latsm,lonsm,imm]=modismoa('totten glacier',1000,'resolution',750);
close(991)
[xm,ym]=ll2ps(latsm,lonsm);

pause(4)

figure(411)
set(gcf,'pos',[27          59        1533         729])
group_axis=[2.22e6 2.33e6 -1.17e6 -9.85e5]/1000;
group_caxis=[-10 80];
imm_caxis=[13000 17000];

subaxis(1,3,1)%,'MT',0.03,'MB',0.06)
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
ntitle(' a  ROMS (With SGFW)','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)

text(2240,-1147,{'Eastern','channel'},'fontsize',12)
text(2310,-1070,{'Law','Dome'},'fontsize',12)
text(2295,-1143,{'Calving front'},'fontsize',12)
text(2233,-1004,{'Grounding','line'},'fontsize',12)


% add N arrow
ps1=[2234.541e3,-1021.968e3];
[ll1(1),ll1(2)]=ps2ll(ps1(1),ps1(2));
ll2=ll1; ll2(1) = ll2(1)+.15;
[ps2(1),ps2(2)]=ll2ps(ll2(1),ll2(2));

% so much juryrigging to fix broken matlab....
xL=xlim;
yL=ylim;
ah=gca;
aPos=ah.Position;
ahx = [aPos(1), aPos(1)+aPos(3)];
ahy = [aPos(2), aPos(2)+aPos(4)];

x1p = interp1(xL, ahx, ps1(1)/1000);
x2p = interp1(xL, ahx, ps2(1)/1000);
y1p = interp1(yL, ahy, ps1(2)/1000);
y2p = interp1(yL, ahy, ps2(2)/1000);

arh = annotation('arrow');
arh.Units = 'normalized';
arh.Position = [x1p, y1p, x2p-x1p, y2p-y1p];
arh.LineWidth=2;
arh.HeadStyle='vback1';
arh.HeadLength=8;
arh.HeadWidth=10;
text(ps2(1)/1000,ps2(2)/1000,'N','fontsize',12,'fontweight','bold')


subaxis(1,3,2)%,'MT',0.03,'MB',0.06)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
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
ntitle(' b  ROMS (No SGFW)','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(Norm_melt,1)),' m/yr '],'location','northeast','fontsize',12)
axis equal
axis(group_axis)
grid on
set(gca,'layer','top')
caxis(group_caxis)
cmocean('curl','pivot',0)
set(gca,'layer','top')
hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1022    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
caxis(group_caxis)
cmocean('curl','pivot',0)
hold on,scatter(apres_x,apres_y,120,apres_m,'filled','o','markeredgecolor','k','linewidth',1)



subaxis(1,3,3)
ax1=gca;
flat_pcolor(xm/1000,ym/1000,imm), axis equal
xlabel('Eastings (km)')
grid on, set(gca,'layer','top')
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
ax2 = axes;
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
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
contour(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
grid on
set(gca,'layer','top')
caxis([-25 25]),cmocean('balance','pivot',0)
ntitle(' c  % melt diff with/without SGFW','location','northwest','fontweight','bold', 'fontsize',14)
%ntitle({[' '],['total change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'% '],['mean inc.: ',num2str(round(meanpos,1)),'% '],['mean dec.: ',num2str(round(meanneg,1)),'% ']},'location','northeast','fontsize',12)
ntitle({[' '],['total change: ',num2str(round(mean_weighted)),'% '],['mean inc.: ',num2str(round(meanpos_weighted,1)),'% '],['mean dec.: ',num2str(round(meanneg_weighted,1)),'% ']},'location','northeast','fontsize',12)
h_cb = colorbar;
title(h_cb,'% diff to no flow')
xlabel('Eastings (km)')
axis equal
axis(group_axis)
set(gca,'pos',[0.7047    0.100    0.2333    0.8000])
set(h_cb,'pos',[0.9520    0.1043    0.0201    0.7968])


if 0
	disp('saving figure')
export_fig Figure_combined_meltrates_bettercaxis -png -transparent -m5
end



%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%Create two axes
% ax1 = axes;
% [x,y,z] = peaks;
% surf(ax1,x,y,z)
% view(2)
% ax2 = axes;
% scatter(ax2,randn(1,120),randn(1,120),50,randn(1,120),'filled')
% %%Link them together
% linkaxes([ax1,ax2])
% %%Hide the top axes
% ax2.Visible = 'off';
% ax2.XTick = [];
% ax2.YTick = [];
% %%Give each one its own colormap
% colormap(ax1,'hot')
% colormap(ax2,'cool')
% %%Then add colorbars and get everything lined up
% set([ax1,ax2],'Position',[.17 .11 .685 .815]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(465)
% set(gcf,'pos',[600,100,1000,600])
% group_axis=[2.23e6 2.32e6 -1.165e6 -9.9e5]/1000;
% group_caxis=[-10 80];

% subaxis(2,2,1)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% ylabel('Northings PS-71 (km)')
% ntitle(' ROMS','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr '],'location','northeast')
% axis equal
% axis(group_axis)
% grid on
% set(gca,'layer','top')
% caxis(group_caxis)
% cmocean('curl','pivot',0)


% subaxis(2,2,2)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.melt(:,:,:),3).*Base.mask_totten_nan);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% ntitle(' ROMS','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr '],'location','northeast')
% axis equal
% axis(group_axis)
% grid on
% set(gca,'layer','top')
% caxis(group_caxis)
% cmocean('curl','pivot',0)

% subaxis(2,2,3)
% flat_pcolor(XX/1000,YY/1000,flipud(melt)') %plot, but chop the weird extra row/cols
% ntitle(' Satellite','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(melt(:)),0)),' m/yr '],'location','northeast')
% ylabel('Northings PS-71 (km)')
% xlabel('Eastings PS-71 (km)')
% axis(group_axis)
% grid on
% set(gca,'layer','top')
% hCb2= colorbar; set(hCb2,'pos',[0.918250000000001 0.1 0.016 0.8]); ylabel(hCb2,'melt (m/yr)')
% caxis(group_caxis)
% cmocean('curl','pivot',0)
% axis equal
% axis(group_axis)



% subaxis(2,2,4)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
% hold on
% contour(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
% contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
% grid on
% set(gca,'layer','top')
% caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle({['mean overall change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'%'],['mean inc.: ',num2str(round(meanpos,1)),'%'],['mean dec.: ',num2str(round(meanneg,1)),'%']},'location','northeast')
% %h_cb = colorbar;
% %ylabel(h_cb,'% change compared to control (no flow)')
% xlabel('Eastings PS-71 (km)')
% axis equal
% axis(group_axis)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(469)
% set(gcf,'pos',[657         164        1000         489])
% group_axis=[2.22e6 2.33e6 -1.17e6 -9.85e5]/1000;
% group_caxis=[-10 80];


% subaxis(1,3,1,'MT',0.03,'MB',0.06)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.melt(:,:,:),3).*Base.mask_totten_nan);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% ylabel('Northings PS-71 (km)')
% xlabel('Eastings PS-71 (km)')
% ntitle(' ROMS','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr '],'location','northeast')
% axis equal
% axis(group_axis)
% grid on
% set(gca,'layer','top')
% caxis(group_caxis)
% cmocean('curl','pivot',0)

% subaxis(1,3,2)
% flat_pcolor(XX/1000,YY/1000,flipud(melt)') %plot, but chop the weird extra row/cols
% ntitle(' Satellite','location','northwest','fontweight','bold', 'fontsize',14),ntitle([num2str(round(nanmean(melt(:)),0)),' m/yr '],'location','northeast')
% xlabel('Eastings PS-71 (km)')
% axis(group_axis)
% grid on
% set(gca,'layer','top')
% hCb2= colorbar; set(hCb2,'pos',[0.6320    0.1186    0.0190    0.7975]); title(hCb2,'melt (m/yr)')
% caxis(group_caxis)
% cmocean('curl','pivot',0)
% axis equal
% axis(group_axis)

% subaxis(1,3,3)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
% hold on
% contour(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
% contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
% grid on
% set(gca,'layer','top')
% caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle(' ROMS with/without SGFW','location','northwest','fontweight','bold', 'fontsize',14)
% ntitle({[' '],['total change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'% '],['mean inc.: ',num2str(round(meanpos,1)),'% '],['mean dec.: ',num2str(round(meanneg,1)),'% ']},'location','northeast')
% h_cb = colorbar;
% title(h_cb,'% diff to no flow')
% xlabel('Eastings PS-71 (km)')
% axis equal
% axis(group_axis)
% set(gca,'pos',[0.7047    0.0600    0.2333    0.9100])
% set(h_cb,'pos',[0.9560    0.1166    0.0201    0.7927])
