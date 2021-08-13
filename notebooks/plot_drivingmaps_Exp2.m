addpath(genpath('../'))

latgrab = [0 50]+1;
longrab = [129 203]+1;
Ngrab = [31 31];
timegrab=[0 Inf]+1;
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';

Norm_NoFlow_T_File='../data/proc/tisom017_sgfw_NoFlow_temp_yr0021-0021.nc';
Norm_NoFlow_S_File='../data/proc/tisom017_sgfw_NoFlow_salt_yr0021-0021.nc';
Norm_NoFlow_svstr_File='../data/proc/tisom017_sgfw_NoFlow_svstr_yr0021-0021.nc';
Norm_NoFlow_sustr_File='../data/proc/tisom017_sgfw_NoFlow_sustr_yr0021-0021.nc';
Norm_NoFlow_File='../data/proc/tisom017_sgfw_NoFlow_m_yr0021-0021.nc';

Norm_T_File='../data/proc/tisom017_sgfw_Norm_temp_yr0021-0021.nc';
Norm_S_File='../data/proc/tisom017_sgfw_Norm_salt_yr0021-0021.nc';
Norm_sustr_File='../data/proc/tisom017_sgfw_Norm_sustr_yr0021-0021.nc';
Norm_svstr_File='../data/proc/tisom017_sgfw_Norm_svstr_yr0021-0021.nc';
Norm_File='../data/proc/tisom017_sgfw_Norm_m_yr0021-0021.nc';

Norm_TO_T_File='../data/proc/tisom017_sgfw_Norm_TempOnly_temp_yr0021-0021.nc';
Norm_TO_S_File='../data/proc/tisom017_sgfw_Norm_TempOnly_salt_yr0021-0021.nc';
Norm_TO_sustr_File='../data/proc/tisom017_sgfw_Norm_TempOnly_sustr_yr0021-0021.nc';
Norm_TO_svstr_File='../data/proc/tisom017_sgfw_Norm_TempOnly_svstr_yr0021-0021.nc';
Norm_TO_File='../data/proc/tisom017_sgfw_Norm_TempOnly_m_yr0021-0021.nc';

Norm_SO_T_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_temp_yr0021-0021.nc';
Norm_SO_S_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_salt_yr0021-0021.nc';
Norm_SO_sustr_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_sustr_yr0021-0021.nc';
Norm_SO_svstr_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_svstr_yr0021-0021.nc';
Norm_SO_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_m_yr0021-0021.nc';


NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
Norm_TO = loadMelt(grdFile,Norm_TO_File,longrab,latgrab,timegrab);
Norm_SO = loadMelt(grdFile,Norm_SO_File,longrab,latgrab,timegrab);


NoFlow.td = computeTD(Norm_NoFlow_T_File,Norm_NoFlow_S_File,grdFile,longrab,latgrab,Ngrab,timegrab);
Norm.td =   computeTD(Norm_T_File,Norm_S_File,grdFile,longrab,latgrab,Ngrab,timegrab);
Norm_TO.td = computeTD(Norm_TO_T_File,Norm_TO_S_File,grdFile,longrab,latgrab,Ngrab,timegrab);
Norm_SO.td = computeTD(Norm_SO_T_File,Norm_SO_S_File,grdFile,longrab,latgrab,Ngrab,timegrab);
NoFlow.ustar = loaduStar(Norm_NoFlow_sustr_File,Norm_NoFlow_svstr_File,grdFile,longrab,latgrab,timegrab);
Norm.ustar = loaduStar(Norm_sustr_File,Norm_svstr_File,grdFile,longrab,latgrab,timegrab);
Norm_TO.ustar = loaduStar(Norm_TO_sustr_File,Norm_TO_svstr_File,grdFile,longrab,latgrab,timegrab);
Norm_SO.ustar = loaduStar(Norm_SO_sustr_File,Norm_SO_svstr_File,grdFile,longrab,latgrab,timegrab);

NoFlow_coords = loadCoords(grdFile,longrab,latgrab);
NoFlow_geom = loadGeom(grdFile,longrab,latgrab);

%load Totten mask
mask_totten = loadTottenMask(MaskFile,longrab,latgrab);
mask_totten_nan = mask_totten; mask_totten_nan(mask_totten==0)=NaN;

figure('pos',[400 131 1585 1535])
subaxis(4,3,1,'ML',0.08,'MR',0.03,'MT',0.03,'SV',0.05)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,nanmean(NoFlow.melt,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
cmocean('thermal',24)
caxis([0 25])
ntitle(' a','location','northwest','fontweight','bold')
title('melt')
ylabel('No Flow')
%
subaxis(4,3,4)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm.melt,3)-nanmean(NoFlow.melt,3))./(nanmean(NoFlow.melt,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' d','location','northwest','fontweight','bold')
ylabel('Normal')
%
subaxis(4,3,7)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_TO.melt,3)-nanmean(NoFlow.melt,3))./(nanmean(NoFlow.melt,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' g','location','northwest','fontweight','bold')
ylabel('Norm (Temp only)')
%
subaxis(4,3,10)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_SO.melt,3)-nanmean(NoFlow.melt,3))./(nanmean(NoFlow.melt,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' j','location','northwest','fontweight','bold')
ylabel('Norm (Salt only)')
%
subaxis(4,3,2)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,nanmean(NoFlow.td,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
cmocean('thermal',24)
caxis([0 3])
ntitle(' b','location','northwest','fontweight','bold')
title('thermal driving')
%
subaxis(4,3,5)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' e','location','northwest','fontweight','bold')
%
subaxis(4,3,8)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_TO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' h','location','northwest','fontweight','bold')
%
subaxis(4,3,11)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_SO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' k','location','northwest','fontweight','bold')
h_cb=colorbar('southoutside');
set(h_cb,'pos',[0.3555    0.0420    0.2567    0.0127])
%
subaxis(4,3,3)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,nanmean(NoFlow.ustar,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([0 1])
cmocean('amp',24)
ntitle(' c','location','northwest','fontweight','bold')
title('u*')
%
subaxis(4,3,6)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm.ustar,3)-nanmean(NoFlow.ustar,3))./nanmean(NoFlow.ustar,3)*100.*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' f','location','northwest','fontweight','bold')
%
subaxis(4,3,9)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_TO.ustar,3)-nanmean(NoFlow.ustar,3))./nanmean(NoFlow.ustar,3)*100.*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' i','location','northwest','fontweight','bold')
%
subaxis(4,3,12)
flat_pcolor(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_SO.ustar,3)-nanmean(NoFlow.ustar,3))./nanmean(NoFlow.ustar,3)*100.*mask_totten_nan);
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.lon,NoFlow_coords.lat,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' l','location','northwest','fontweight','bold')


export_fig Exp2_DrivingMaps -png -m2.5 -transparent

%figure
%plotSmallMap(NoFlow_coords.lon,NoFlow_coords.lat,(nanmean(Norm_SO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100,NoFlow_geom.h,[20:1:21],NoFlow_geom.zice,[-1:1:0])
%caxis([-10 10])
%cmocean('balance','pivot',0)
%ntitle(' k','location','northwest','fontweight','bold')
%h_cb=colorbar('southoutside');
%set(h_cb,'pos',[0.3555    0.0420    0.2567    0.0127])



