% addpath(genpath('../'))
rhoi=905;
rhow=1024;

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;

% BaseFile='../data/proc/tisom017_sgfw_SpinUp_m_yr0001-0020_monmean.nc';
Norm_NoFlow_File='tisom017_sgfw_NoFlow_m_yr0021-0021.nc';
Norm_File='tisom017_sgfw_Norm_m_yr0021-0021.nc';
% Low_File='../data/proc/tisom017_sgfw_Low_m_yr0021-0021.nc';
% High_File='../data/proc/tisom017_sgfw_High_m_yr0021-0021.nc';
grdFile='tisom008_canal_grd.nc';
MaskFile='mask_totten.nc';


% Base = loadMelt(grdFile,BaseFile,longrab,latgrab,timegrab);
NoFlow=loadMelt(grdFile,Norm_NoFlow_File,longrab,latgrab,timegrab);
Norm = loadMelt(grdFile,Norm_File,longrab,latgrab,timegrab);
% Low = loadMelt(grdFile,Low_File,longrab,latgrab,timegrab);
% High = loadMelt(grdFile,High_File,longrab,latgrab,timegrab);

NoFlow_coords = loadCoords(grdFile,longrab,latgrab);
NoFlow_geom = loadGeom(grdFile,longrab,latgrab);
NoFlow_coords.x = NoFlow_coords.x/1000;
NoFlow_coords.y = NoFlow_coords.y/1000;



C=colororder;
% 
% figure('pos',[600,1000,1900,1000])
% subaxis(2,4,[1:4],'ML',0.05,'MR',0.099999999903,'SV',0.07)
% p1=plot(Base.ot,Base.my,'linewidth',1); hold on,
% p2=plot(NoFlow.ot,NoFlow.my,'linewidth',1,'color',C(1,:));
% p3=plot(Norm.ot,Norm.my,'linewidth',1,'color',C(2,:));
% p4=plot(Low.ot,Low.my,'linewidth',1,'color',C(3,:));
% p5=plot(High.ot,High.my,'linewidth',1,'color',C(5,:));
% p2.Color(4)=0.25;
% p3.Color(4)=0.25;
% p4.Color(4)=0.25;
% p5.Color(4)=0.25;
% Fs=1/(24*60*60) ;fc=1/(14*24*60*60);
% p2s=plot(NoFlow.ot,filter1('lp',NoFlow.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(1,:));
% p3s=plot(Norm.ot,filter1('lp',Norm.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(2,:));
% % p4s=plot(Low.ot,filter1('lp',Low.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(3,:));
% % p5s=plot(High.ot,filter1('lp',High.my,'fs',Fs,'fc',fc,'order',5),'linewidth',2,'color',C(5,:));
% % legend([p2s,p3s,p4s,p5s],{'no flow','medium','low','high'},'location','northeast'),legend('boxoff'),grid on,set(gca,'layer','top'),ylabel('melt rate (m/yr)')
% ntitle(' a','location','northwest','fontweight','bold')
% axis([20 21 7 9.5])
% xticks([20:1/12:21])
% xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',''})
% 
% subaxis(2,4,5,'ML',0.05,'MR',0.08)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% cmocean('thermal')
% ntitle(' b','location','northwest','fontweight','bold'),ntitle([num2str(round(nanmean(NoFlow.my),1)),' m/yr'],'location','northeast')
% axis equal
% axis([2.2e6 2.35e6 -1.17e6 -9.75e5]/1000)
% grid on
% set(gca,'layer','top')
% hCb1 = colorbar;
% 
% subaxis(2,4,6)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Low.melt(:,:,:),3).*Low.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle(' c','location','northwest','fontweight','bold'),ntitle('Low','location','north'),ntitle([num2str(round((nanmean(Low.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')
% axis equal
% axis([2.2e6 2.35e6 -1.17e6 -9.75e5]/1000)
% grid on
% set(gca,'layer','top')
% 
% subaxis(2,4,7)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt(:,:,:),3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle(' d','location','northwest','fontweight','bold'),ntitle('Medium','location','north'),ntitle([num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')
% axis equal
% axis([2.2e6 2.35e6 -1.17e6 -9.75e5]/1000)
% grid on
% set(gca,'layer','top')
% 
% subaxis(2,4,8)
% flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(High.melt(:,:,:),3).*High.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Base.mask_totten_nan-1)*100);
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
% hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
% caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle(' e','location','northwest','fontweight','bold'),ntitle('High','location','north'),ntitle([num2str(round((nanmean(High.my./NoFlow.my)-1)*100,1)),'%'],'location','northeast')
% hCb = colorbar; 
% set(hCb,'pos',[0.928 0.095 0.01 0.4]),title(hCb,'% change')
% axis equal
% axis([2.2e6 2.35e6 -1.17e6 -9.75e5]/1000)
% grid on
% set(gca,'layer','top')
% 
% set(hCb1,'pos',[0.916 0.095 0.01 0.4]),title(hCb1,'m/yr')
% set(hCb,'pos',[0.96 0.095 0.01 0.4]),title(hCb,'%\Delta')

%export_fig Figure2_Exp1 -png -transparent -m2.5


% ROMSMLGT = meanmeltAv*nansum(nansum(AreaMask))*917*1e-12;



figure
flat_pcolor(NoFlow_coords.x,NoFlow_coords.y,(nanmean(Norm.melt(:,:,:),3).*Norm.mask_totten_nan./nanmean(NoFlow.melt(:,:,:),3).*Norm.mask_totten_nan-1)*100);
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(NoFlow_coords.x,NoFlow_coords.y,NoFlow_geom.zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-10 10]),cmocean('balance','pivot',0)
% ntitle(' d','location','northwest','fontweight','bold'),ntitle('Medium','location','north'),
[num2str(round((nanmean(Norm.my./NoFlow.my)-1)*100,1)),'%']
axis equal
axis([2.2e6 2.35e6 -1.17e6 -9.75e5]/1000)
grid on
set(gca,'layer','top')



disp(['Change in mean ML between Norm and NoFlow: ',num2str((nanmean(Norm.my)-nanmean(NoFlow.my))*nansum(nansum(Norm.dy.*Norm.dy.*Norm.mask_totten_nan))*917*1e-12),'gt/yr'])

Norm.ML_tav = nansum(nansum(squeeze(nanmean(Norm.melt,3).*Norm.mask_totten_nan).*Norm.dx.*Norm.dy*917*1e-12));

NoFlow.ML_tav = nansum(nansum(squeeze(nanmean(NoFlow.melt,3).*Norm.mask_totten_nan).*Norm.dx.*Norm.dy*917*1e-12));

disp(['Change in ML between Norm and NoFlow: ',num2str(Norm.ML_tav - NoFlow.ML_tav),' gt/yr'])



%% old calculations

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

%%

% calc Mass loss for each case

Norm_ML = squeeze(nansum(nansum(Norm.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan*rhow*1e-12,1),2));
NoFlow_ML = squeeze(nansum(nansum(NoFlow.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan*rhow*1e-12,1),2));

Norm_melt = squeeze(nansum(nansum(Norm.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan)))/squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))

NoFlow_melt = squeeze(nansum(nansum(NoFlow.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan)))/squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))

Norm_ML_field = Norm.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan*rhow*1e-12;
NoFlow_ML_field = NoFlow.mtAv.*(Norm.dx.*Norm.dy).*Norm.mask_totten_nan*rhow*1e-12;

Norm_ML_field_pos = (Norm_ML_field-NoFlow_ML_field).*field_pos_mask;
sum(Norm_ML_field_pos(:),'omitnan')

Norm_ML_field_neg = (Norm_ML_field-NoFlow_ML_field).*field_neg_mask;
sum(Norm_ML_field_neg(:),'omitnan')

%should also calc rel increases in GL region

%% compare averages pre/post ratio

field_wrong = (Norm.mtAv.*Norm.mask_totten_nan./NoFlow.mtAv.*Norm.mask_totten_nan-1)*100;
field1 = ( Norm.mtAv.*Norm.mask_totten_nan./(NoFlow.mtAv.*Norm.mask_totten_nan) -1)*100;
field2 = (Norm.mtAv./NoFlow.mtAv -1)*100 .* Norm.mask_totten_nan;
% so the calculation of the field is correct.

squeeze(nansum(nansum(field2.*Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1) )/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))
squeeze(nansum(nansum(field2.*Norm.dx.*Norm.dy.*Norm.mask_totten_nan)) )/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*Norm.mask_totten_nan,2),1))
% still gives different value to Norm_melt/NoFlow_melt


%% 
disp('final values')

% av melt rate and mass loss.
disp('The area average melt rate when including SGFW for TIS is ...')
Norm_melt
disp('which equates to area av ML (Gt/yr) of ...')
Norm_ML

disp('The area average % increase in melting is ...')
mean_weighted

disp('which equates to an increase in ML (Gt/yr) of ...')
Norm_ML-NoFlow_ML

%max melt rates (40m/yr)
disp('The maximum melt rate is  (m/yr) ...')
max(max(Norm.mtAv.*Norm.mask_totten_nan))

% mr compared to APRES.
disp('The simulated melt rate in the cell closest to the APRES site is ...')
xx=2272.5;
yy=-1029;
together=abs(NoFlow_coords.x-xx) + abs(NoFlow_coords.y-yy);
[min_val,ix]=min(together(:));
[row,col]=ind2sub(size(together),ix);
Norm.mtAv(row,col)

% av %inc in melt rates for all pos areas
disp('The area averaged %increase in melting, for all cells displaying an increase is ...')
meanpos_weighted
disp('Which is equivalent to an increased total mass loss in those cells (Gt/yr) of ...')
sum(Norm_ML_field_pos(:),'omitnan')

% av %inc in melt rates for all neg areas / ml
disp('The area averaged %decrease in melting, for all areas displaying a decrease in melting  is ... ')
meanneg_weighted
disp('which is equivalent to a change in mass loss contribution in those cells (Gt/yr) of ...')
sum(Norm_ML_field_neg(:),'omitnan')

% %inc in ML in GL zone, 
GLmask = double((NoFlow_coords.y>-1030)); GLmask(GLmask==0)=NaN; GLmask = GLmask.*Norm.mask_totten_nan;

disp('For the deepest reaches of the ice shelf, in the vicinity of the GL, where northings>-1030 is ...')
disp('melting increases on average by (%) ...')
squeeze(nansum(nansum(field2.*Norm.dx.*Norm.dy.*GLmask)))/ squeeze(nansum(nansum(Norm.dx.*Norm.dy.*GLmask,2),1))
disp('over an area of (km^2) of ...')
squeeze(nansum(nansum(Norm.dx.*Norm.dy.*GLmask,2),1))/(1000*1000)
disp('which results in a total increase in mass loss (Gt/yr) of ...')
sum(sum((Norm_ML_field-NoFlow_ML_field).*GLmask,'omitnan'),'omitnan')


