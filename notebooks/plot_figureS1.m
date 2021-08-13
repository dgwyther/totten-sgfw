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

Coords = loadCoords(grdFile,longrab,latgrab);
Coords.x = Coords.x/1000;
Coords.y = Coords.y/1000;

Base = loadMelt(grdFile,BaseFile,longrab,latgrab,timegrab);
NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
Low = loadMelt(grdFile,Low_File,longrab,latgrab,timegrab);
High = loadMelt(grdFile,High_File,longrab,latgrab,timegrab);
Norm_geom = loadGeom(grdFile,longrab,latgrab);

% do stats
field = (nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100;

field_pos = field; field_pos(field_pos<0)=NaN;
field_neg = field; field_neg(field_neg>0)=NaN;

%nanmean(field_pos
meanpos=nanmean(field_pos(:));
meanneg=nanmean(field_neg(:));

% plot
C=colororder;
figure
flat_pcolor(Coords.x,Coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
hold on
contour(Coords.x,Coords.y,(nanmean(Norm.melt,3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100,[0 0],'k-');
contour(Coords.x,Coords.y,Norm_geom.zice,[-1:1:0],'linewidth',1,'color',C(2,:)) %icefront line
grid on
set(gca,'layer','top')
caxis([-10 10]),cmocean('balance','pivot',0)
%ntitle('Medium flow. % \Delta melt','location','north')
ntitle({['mean overall change: ',num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'%'],['mean inc.: ',num2str(round(meanpos,1)),'%'],['mean dec.: ',num2str(round(meanneg,1)),'%']},'location','northeast')
h_cb = colorbar;
ylabel(h_cb,'% change compared to control (no flow)')
xlabel('Eastings PS-71 (km)')
ylabel('Northings PS-71 (km)')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
%export_fig Medium_MeltChanges -png -transparent -m2.5

figure('pos',[1068        1200        1338         428])
h11=histogram(field_pos,100,'BinLimits',[0 50])
hold on
h22=histogram(field_neg,100,'BinLimits',[-50 0])
NormMethod='count'
h11.Normalization = NormMethod;
h11.BinWidth = .5;
h22.Normalization = NormMethod;
h22.BinWidth = .5;
xlim([-30 30])
xlabel('% difference in melt per cell')
ylabel('# of cells')
grid on
set(gca,'layer','top')



