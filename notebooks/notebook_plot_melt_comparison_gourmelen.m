addpath(genpath('../'))

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

BaseFile='../data/proc/tisom017_sgfw_SpinUp_m_yr0001-0020_monmean.nc';
Norm_NoFlow_File='../data/proc/tisom017_sgfw_NoFlow_m_yr0021-0021.nc';
Norm_File='../data/proc/tisom017_sgfw_Norm_m_yr0021-0021.nc';
Low_File='../data/proc/tisom017_sgfw_Low_m_yr0021-0021.nc';
High_File='../data/proc/tisom017_sgfw_High_m_yr0021-0021.nc';
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';


Base = loadMelt(grdFile,BaseFile,longrab,latgrab,timegrab);
NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
Low = loadMelt(grdFile,Low_File,longrab,latgrab,timegrab);
High = loadMelt(grdFile,High_File,longrab,latgrab,timegrab);

NoFlow_coords = loadCoords(grdFile,longrab,latgrab);
NoFlow_geom = loadGeom(grdFile,longrab,latgrab);
NoFlow_coords.x = NoFlow_coords.x/1000;
NoFlow_coords.y = NoFlow_coords.y/1000;



C=colororder;

figure('pos',[600,100,1000,600])

flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
%cmocean('thermal')
ntitle(' ROMS','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr'],'location','northeast')
%axis equal
axis([2.25e6 2.32e6 -1.165e6 -10e5]/1000)
grid on
set(gca,'layer','top')
hCb1 = colorbar;
caxis([-40 40])

GourmelenFile='../data/raw/TottenBasalMeltRates.tif'

[A,R] = readgeoraster(GourmelenFile,'outputtype','double');
melt = imread(GourmelenFile); 
melt(melt<-100)=NaN;
Xlims=R.XWorldLimits;
Ylims=R.YWorldLimits;
Xspacing=R.CellExtentInWorldX; %these are both 1000 m.
Yspacing=R.CellExtentInWorldY;

[XX,YY]=ndgrid(Xlims(1)+Xspacing/2:Xspacing:Xlims(2)-Xspacing/2,Ylims(1)+Yspacing/2:Yspacing:Ylims(2)-Yspacing/2); %make a mesh grid for each grid coordinate
%figure,flat_pcolor(XX,YY,flipud(melt)'),colorbar,caxis([-5 50]) %plot, but chop the weird extra row/cols

figure('pos',[600,100,1000,600])
subaxis(1,2,1)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
%cmocean('thermal')
ntitle(' ROMS','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr '],'location','northeast')
%axis equal
axis([2.23e6 2.32e6 -1.165e6 -9.9e5]/1000)
grid on
set(gca,'layer','top')
caxis([-10 80])
cmocean('curl','pivot',0)
subaxis(1,2,2)
flat_pcolor(XX/1000,YY/1000,flipud(melt)'),colorbar,caxis([-5 50]) %plot, but chop the weird extra row/cols
ntitle(' Satellite','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(melt(:)),0)),' m/yr '],'location','northeast')
axis([2.23e6 2.32e6 -1.165e6 -9.9e5]/1000)
grid on
set(gca,'layer','top')
hCb2= colorbar; set(hCb2,'pos',[0.918250000000001 0.1 0.016 0.8]); ylabel(hCb2,'melt (m/yr)')
caxis([-10 80])
cmocean('curl','pivot',0)
export_fig ModelSatelliteMeltComparison -png -m3