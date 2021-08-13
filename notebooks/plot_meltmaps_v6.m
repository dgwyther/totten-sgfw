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

C=colororder;

figure('pos',[600,1000,2000,1000])
subaxis(2,4,[1:4],'ML',0.05,'MR',0.08,'MT',0.03,'SV',0.07)
p1=plot(Base.ot,Base.my,'linewidth',1); hold on,
p2=plot(NoFlow.ot,NoFlow.my,'linewidth',1,'color',C(1,:));
p3=plot(Norm.ot,Norm.my,'linewidth',1,'color',C(2,:));
p4=plot(Low.ot,Low.my,'linewidth',1,'color',C(3,:));
p5=plot(High.ot,High.my,'linewidth',1,'color',C(5,:));
p2.Color(4)=0.25;
p3.Color(4)=0.25;
p4.Color(4)=0.25;
p5.Color(4)=0.25;
Fs=1/(24*60*60) ;fc=1/(14*24*60*60);
p2s=plot(NoFlow.ot,filter1('lp',NoFlow.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(1,:));
p3s=plot(Norm.ot,filter1('lp',Norm.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(2,:));
p4s=plot(Low.ot,filter1('lp',Low.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(3,:));
p5s=plot(High.ot,filter1('lp',High.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(5,:));
legend([p2s,p3s,p4s,p5s],{'no flow','norm','low','high'},'location','northeast'),legend('boxoff'),grid on,set(gca,'layer','top'),ylabel('melt rate (m/yr)')
ntitle(' a','location','northwest','fontweight','bold')
axis([20 21 7 9.5])
xticks([20:1/12:21])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',''})

subaxis(2,4,5,'ML',0.05,'MR',0.08)
flat_pcolor(Base.lon,Base.lat,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
cmocean('thermal')
ntitle(' b','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr'],'location','northeast')

subaxis(2,4,6)
flat_pcolor(Low.lon,Low.lat,(nanmean(Low.melt(:,:,:),3).*Low.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' c','location','northwest','fontweight','bold'),ntitle('Low','location','north'),ntitle([num2str(round((nanmean(Low.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')

subaxis(2,4,7)
flat_pcolor(Norm.lon,Norm.lat,(nanmean(Norm.melt(:,:,:),3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' d','location','northwest','fontweight','bold'),ntitle('Medium','location','north'),ntitle([num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')

subaxis(2,4,8)
flat_pcolor(High.lon,High.lat,(nanmean(High.melt(:,:,:),3).*High.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' e','location','northwest','fontweight','bold'),ntitle('High','location','north'),ntitle([num2str(round((nanmean(High.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')
hCb = colorbar; set(hCb,'pos',[0.928 0.095 0.01 0.4]),ylabel(hCb,'% change')
export_fig Figure2_Exp1 -png -transparent -m2.5



