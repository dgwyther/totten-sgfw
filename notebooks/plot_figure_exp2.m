addpath(genpath('../'))
% set paths
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

% load melts and compute TD
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

NoFlow_coords.x = NoFlow_coords.x/1000;
NoFlow_coords.y = NoFlow_coords.y/1000;

%load Totten mask
mask_totten = loadTottenMask(MaskFile,longrab,latgrab);
mask_totten_nan = mask_totten; mask_totten_nan(mask_totten==0)=NaN;

% begin plotting

C=colororder;

figure('pos',[300, 55, 540, 850])
subaxis(4,3,[1:3],'ML',0.12,'MR',0.05,'MT',0.03,'SV',0.025, 'SH',0.025)
p2=plot(NoFlow.ot,NoFlow.my,'linewidth',1,'color',C(1,:));
hold on
p3=plot(Norm.ot,Norm.my,'linewidth',1,'color',C(2,:));
p4=plot(Norm_TO.ot,Norm_TO.my,'linewidth',1,'color',C(3,:));
p5=plot(Norm_SO.ot,Norm_SO.my,'linewidth',1,'color',C(4,:));
p2.Color(4)=0.25;
p3.Color(4)=0.25;
p4.Color(4)=0.25;
p5.Color(4)=0.25;
Fs=1/(24*60*60) ;fc=1/(14*24*60*60);
p2s=plot(NoFlow.ot,filter1('lp',NoFlow.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(1,:));
p3s=plot(Norm.ot,filter1('lp',Norm.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(2,:));
p4s=plot(Norm_TO.ot,filter1('lp',Norm_TO.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(3,:));
p5s=plot(Norm_SO.ot,filter1('lp',Norm_SO.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(4,:));
legend([p2s,p3s,p4s,p5s],{'no flow','with SGFW','temp only','salt only'},'location','northeast'),legend('boxoff'),grid on,set(gca,'layer','top'),ylabel('melt rate (m/yr)')
ntitle(' a','location','northwest','fontweight','bold','fontsize',12)
axis([20 21 7 9.5])
xticks([20:1/12:21])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',''})
set(gca,'fontsize',11)
set(gca,'pos',[0.1200    0.7882    0.8300    0.1818])
%
subaxis(4,3,4)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.melt,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
%caxis([-10 10])
cmocean('solar')
ntitle(' b','location','northwest','fontweight','bold','fontsize',12)
title('Melt','fontsize',12,'fontweight','bold')
ylabel('with SGFW','fontsize',12,'fontweight','bold')
h_cb1=colorbar('southoutside');
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
grid on
set(gca,'layer','top')
set(gca,'xticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,7)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_TO.melt,3)-nanmean(NoFlow.melt,3))./(nanmean(NoFlow.melt,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' e','location','northwest','fontweight','bold','fontsize',12)
ylabel('Temp-only (% diff to Ctrl.)','fontsize',12,'fontweight','bold')
ntitle([num2str(round((nanmean(Norm_TO.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'xticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,10)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_SO.melt,3)-nanmean(NoFlow.melt,3))./(nanmean(NoFlow.melt,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' h','location','northwest','fontweight','bold','fontsize',12)
ylabel('Salt only (% diff. to Ctrl.)','fontsize',12,'fontweight','bold')
ntitle([num2str(round((nanmean(Norm_SO.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast'),
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'fontsize',11)
%
subaxis(4,3,5)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.td,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([0 2.5])
cmocean('thermal')
ntitle(' c','location','northwest','fontweight','bold','fontsize',12)
title('Thermal driving','fontweight','bold','fontsize',12)
%ylabel('Thermal driving','fontsize',8,'fontweight','bold')
h_cb2=colorbar('southoutside');
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,8)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_TO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' f','location','northwest','fontweight','bold','fontsize',12)
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,11)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_SO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' i','location','northwest','fontweight','bold','fontsize',12)
h_cb4=colorbar('southoutside');
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'yticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,6)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(Norm.ustar,3).*mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([0 0.35])
cmocean('deep')
ntitle(' d','location','northwest','fontweight','bold','fontsize',12)
title('Friction velocity','fontweight','bold','fontsize',12)
%ylabel('Friction velocity','fontsize',8,'fontweight','bold')
h_cb3=colorbar('southoutside');
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,9)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_TO.ustar,3)-nanmean(NoFlow.ustar,3))./nanmean(NoFlow.ustar,3)*100.*mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' g','location','northwest','fontweight','bold','fontsize',12)
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'fontsize',11)
%
subaxis(4,3,12)
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_SO.ustar,3)-nanmean(NoFlow.ustar,3))./nanmean(NoFlow.ustar,3)*100.*mask_totten_nan);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10])
cmocean('balance','pivot',0)
ntitle(' j','location','northwest','fontweight','bold','fontsize',12)
grid on
set(gca,'layer','top')
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.8537e5]/1000)
set(gca,'yticklabels',[])
set(gca,'fontsize',11)

set(h_cb2,'pos',[0.28    0.03    0.2    0.0127])
set(h_cb1,'pos',[0.03    0.03    0.2    0.0127])
set(h_cb3,'pos',[0.53    0.03    0.2    0.0127])
set(h_cb4,'pos',[0.78    0.03    0.2    0.0127])
title(h_cb1,'melt rate (m/yr)','fontsize',12)
title(h_cb2,'T* (\circ C)','fontsize',12)
title(h_cb3,'u* (m/s)','fontsize',12)
title(h_cb4,'%\Delta to ctrl. (no flow)','fontsize',12)

set(gcf,'pos',[300    55   584   850])

export_fig Figure3_Exp2 -png -m3 -transparent

%figure
%plotSmallMap(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm_SO.td,3)-nanmean(NoFlow.td,3))./(nanmean(NoFlow.td,3)).*mask_totten_nan*100,NoFlow_geom.h,[20:1:21],NoFlow_geom.zice,[-1:1:0])
%caxis([-10 10])
%cmocean('balance','pivot',0)
%ntitle(' k','location','northwest','fontweight','bold')
%h_cb=colorbar('southoutside');
%set(h_cb,'pos',[0.3555    0.0420    0.2567    0.0127])



