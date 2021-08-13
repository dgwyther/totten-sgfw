addpath(genpath('../'))

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

Norm_NoFlow_File='../data/proc/tisom017_sgfw_NoFlow_m_yr0021-0021.nc';
Norm_File='../data/proc/tisom017_sgfw_Norm_m_yr0021-0021.nc';
Norm_TO_File='../data/proc/tisom017_sgfw_Norm_TempOnly_m_yr0021-0021.nc';
Norm_SO_File='../data/proc/tisom017_sgfw_Norm_SaltOnly_m_yr0021-0021.nc';
grdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';

NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
Norm_TO = loadMelt(grdFile,Norm_TO_File,longrab,latgrab,timegrab);
Norm_SO = loadMelt(grdFile,Norm_SO_File,longrab,latgrab,timegrab);

C=colororder;

figure('pos',[600,1000,2000,1000])
subaxis(2,3,[1:3],'ML',0.05,'MR',0.08,'MT',0.03,'SV',0.07)
p2=plot(NoFlow.ot,NoFlow.my,'linewidth',1,'color',C(1,:));
hold on
p3=plot(Norm.ot,Norm.my,'linewidth',1,'color',C(2,:));
p4=plot(Norm_TO.ot,Low.my,'linewidth',1,'color',C(3,:));
p5=plot(Norm_SO.ot,High.my,'linewidth',1,'color',C(4,:));
p2.Color(4)=0.25;
p3.Color(4)=0.25;
p4.Color(4)=0.25;
p5.Color(4)=0.25;
Fs=1/(24*60*60) ;fc=1/(14*24*60*60);
p2s=plot(NoFlow.ot,filter1('lp',NoFlow.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(1,:));
p3s=plot(Norm.ot,filter1('lp',Norm.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(2,:));
p4s=plot(Low.ot,filter1('lp',Norm_TO.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(3,:));
p5s=plot(High.ot,filter1('lp',Norm_SO.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(4,:));
legend([p2s,p3s,p4s,p5s],{'no flow','norm','temp only','salt only'},'location','northeast'),legend('boxoff'),grid on,set(gca,'layer','top'),ylabel('melt rate (m/yr)')
ntitle(' a','location','northwest','fontweight','bold')
axis([20 21 7 9.5])
xticks([20:1/12:21])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',''})

subaxis(2,3,4,'ML',0.05,'MR',0.08)
flat_pcolor(Base.lon,Base.lat,nanmean(Norm.melt(:,:,:),3).*Base.mask_totten_nan);
cmocean('thermal')
ntitle(' b','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(Norm.my),1)),' m/yr'],'location','northeast')

subaxis(2,3,5)
flat_pcolor(Norm_TO.lon,Norm_TO.lat,(nanmean(Norm_TO.melt(:,:,:),3).*Norm_TO.mask_totten_nan./nanmean(Norm.melt(:,:,:),3).*Norm.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' c','location','northwest','fontweight','bold'),ntitle('Temp only','location','north'),ntitle([num2str(round((nanmean(Norm_TO.my./Norm.my)-1)*100,1)),'%'],'location','northeast')

subaxis(2,3,6)
flat_pcolor(Norm_SO.lon,Norm_SO.lat,(nanmean(Norm_SO.melt(:,:,:),3).*Norm_SO.mask_totten_nan./nanmean(Norm.melt(:,:,:),3).*Norm.mask_totten_nan-1)*100);
caxis([-10 10]),cmocean('balance','pivot',0)
ntitle(' d','location','northwest','fontweight','bold'),ntitle('Salt only','location','north'),ntitle([num2str(round((nanmean(Norm_SO.my./Norm.my)-1)*100,1)),'%'],'location','northeast'),hCb = colorbar; set(hCb,'pos',[0.928 0.095 0.01 0.4]),ylabel(hCb,'% change')

export_fig MeltComparison_Exp2 -png -transparent -m2.5



