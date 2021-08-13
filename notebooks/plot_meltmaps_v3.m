addpath(genpath('../'))

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

BaseFile='../data/proc/tisom017_sgfw_m_yr0001-0015_monmean.nc';
Norm_NoFlow_File='../data/proc/tisom017_sgfw_Normal_NoFlow_m_yr0016-0020_monmean.nc';
Norm_File='../data/proc/tisom017_sgfw_Normal_m_yr0016-0020_monmean.nc';
Low_File='../data/proc/tisom017_sgfw_Low_m_yr0016-0020_monmean.nc';
High_File='../data/proc/tisom017_sgfw_High_m_yr0016-0020_monmean.nc';
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';


Base = loadMelt(grdFile,BaseFile,longrab,latgrab,timegrab);
NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
Low = loadMelt(grdFile,Low_File,longrab,latgrab,timegrab);
High = loadMelt(grdFile,High_File,longrab,latgrab,timegrab);

C=colororder;
figure
plot(Base.ot,Base.my,'linewidth',2)
hold on
plot(NoFlow.ot,NoFlow.my,'linewidth',2,'color',C(1,:))
plot(Norm.ot,Norm.my,'linewidth',2)
plot(Low.ot,Low.my,'linewidth',2)
plot(High.ot,High.my,'linewidth',2)
ylimAx=ylim;
plot([NoFlow.ot(1) NoFlow.ot(1)],[ylimAx(1) ylimAx(2)],'k','linewidth',2)
legend('Spinup - no flow','no flow','norm','low','high','location','southeast'),legend('boxoff')



figure('pos',[600,1000,2000,400])
subaxis(1,4,1,'ML',0.05,'MR',0.08)
flat_pcolor(Base.lon,Base.lat,nanmean(NoFlow.melt(:,:,1:12),3).*Base.mask_totten_nan);
cmocean('thermal')
ntitle(' a','location','northwest'),ntitle([num2str(nanmean(NoFlow.my(1:12))),' m/yr'],'location','northeast')

subaxis(1,4,2)
flat_pcolor(Low.lon,Low.lat,(nanmean(Low.melt(:,:,1:12),3).*Low.mask_totten_nan./nanmean(NoFlow.melt(:,:,1:12),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' b Low','location','northwest'),ntitle([num2str((nanmean(Low.my(1:12))/nanmean(NoFlow.my(1:12))-1)*100 ),'%'],'location','northeast')


subaxis(1,4,3)
flat_pcolor(Norm.lon,Norm.lat,(nanmean(Norm.melt(:,:,1:12),3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,1:12),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' c Normal','location','northwest'),ntitle([num2str((nanmean(Norm.my(1:12))/nanmean(NoFlow.my(1:12))-1)*100 ),'%'],'location','northeast')


subaxis(1,4,4)
flat_pcolor(High.lon,High.lat,(nanmean(High.melt(:,:,1:12),3).*High.mask_totten_nan./nanmean(NoFlow.melt(:,:,1:12),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' d High','location','northwest'),ntitle([num2str((nanmean(High.my(1:12))/nanmean(NoFlow.my(1:12))-1)*100 ),'%'],'location','northeast')
hCb = colorbar; set(hCb,'pos',[0.928 0.095 0.01 0.8]),ylabel(hCb,'% change')




