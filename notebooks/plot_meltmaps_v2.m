addpath(genpath('../'))
%load melt rates

latgrab = [0 50]+1;
longrab = [129 203]+1;
timegrab=[0 Inf]+1;
spy=365*60*60*24;
rho_i=905; %// kg m^-3 see Fricker et al.,2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

BaseFile='../data/proc/tisom017_sgfw_m_yr0001-0015_monmean.nc';
Rvr1File='../data/proc/tisom017_sgfw_Normal_NoFlow_m_yr0016-0020_monmean.nc';
Rvr2File='../data/proc/tisom017_sgfw_Normal_Combined_m_yr0016-0020_monmean.nc';
GrdFile='../data/raw/tisom008_canal_grd.nc';
MaskFile='../data/proc/mask_totten.nc';

disp('loading melt')
meltBase = spy*double(ncread(BaseFile,'m',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));
melt1 = spy*double(ncread(Rvr1File,'m',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));
melt2 = spy*double(ncread(Rvr2File,'m',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));

LAT = ncread(BaseFile,'lat_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
LON = ncread(BaseFile,'lon_rho', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
otBase = ncread(BaseFile,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1])/spy;
ot1 = ncread(Rvr1File,'ocean_time',[timegrab(1)],[timegrab(2)-timegrab(1)+1])/spy;
mask_rho_nan=ncread(GrdFile,'mask_rho',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_zice_nan=ncread(GrdFile,'mask_zice',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
h = ncread(GrdFile,'h', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
pm = ncread(GrdFile,'pm', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dx=1./pm;
pn = ncread(GrdFile,'pn', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
dy=1./pn;
zice=ncread(GrdFile,'zice', [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_totten_nan = ncread(MaskFile,'mask_totten',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_totten_nan(mask_totten_nan==0)=NaN;
mask_zice_nan(mask_zice_nan==0)=NaN;
mask_rho_nan(mask_rho_nan==0)=NaN;

% mean & mask melt
Area_totten = dx.*dy.*mask_totten_nan;
Area_zice = dx.*dy.*mask_zice_nan;

myBase = squeeze(nansum(nansum(bsxfun(@times,meltBase,Area_totten),2),1)) / squeeze(nansum(nansum(Area_totten,2),1));
my1 = squeeze(nansum(nansum(bsxfun(@times,melt1,Area_totten),2),1)) / squeeze(nansum(nansum(Area_totten,2),1));
my2 = squeeze(nansum(nansum(bsxfun(@times,melt2,Area_totten),2),1)) / squeeze(nansum(nansum(Area_totten,2),1));

meltBase_timeav = squeeze(nanmean(meltBase,3));
melt1_timeav = squeeze(nanmean(melt1,3));
melt2_timeav = squeeze(nanmean(melt2,3));

ml1_timeav = squeeze(nansum(nansum(melt1_timeav.*Area_totten.*mask_totten_nan*rho_i.*1e-12,1),2));
ml2_timeav = squeeze(nansum(nansum(melt2_timeav.*Area_totten.*mask_totten_nan*rho_i.*1e-12,1),2));

%plot melt rate comparisons
disp('plotting')
figure
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.06], [0.07 0.06], [0.08 0.08]);
set(gcf,'position',[40 40 1800  900])

subplot(2,2,1)
flat_pcolor(LON,LAT,(melt1_timeav).*mask_zice_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
cmocean('balance','pivot',0),
colorbar
grid on
set(gca,'layer','top')
text(114.5,-67.5,'Grounding line','fontsize',15)
text(116.3,-66.64,'Calving front','fontsize',15)
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
curraxis=axis; axis([104.5 130 -68 -60])
h_inset=inset_unproj('nw','insetsize',0.5,'frame','off'); h_inset_pos=get(h_inset,'pos');
ntitle({' a'},'location','northwest','fontweight','bold','fontsize',16)
ntitle({'Control ',[num2str(nanmean(round(my1*10)/10)),' m/yr | ',num2str(round(ml1_timeav*10)/10),' Gt/yr ']},'location','northeast','fontweight','bold','fontsize',16)
%ntitle(['Melt rate ',num2str(round(nanmean(my)*10)/10) '\pm',num2str(round(nanstd(my)*10)/10) ' m/yr'],'fontweight','bold','fontsize',16),
axis(curraxis)
set(h_inset,'pos',[h_inset_pos(1) h_inset_pos(2)-.006 h_inset_pos(3) h_inset_pos(4)]);
%
subplot(2,2,2)
flat_pcolor(LON,LAT,(melt2_timeav-melt1_timeav).*mask_zice_nan);
colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
caxis([-1 5])
cmocean('balance','pivot',0),
colorbar
grid on
set(gca,'layer','top')
ntitle(' b','location','northwest','fontweight','bold','fontsize',16)
ntitle({'SGFW - Control ',[num2str(round(nanmean(my2-my1)*10)/10),' m/yr | ',num2str(ml2_timeav-ml1_timeav),' Gt/yr ']},'location','northeast','fontweight','bold','fontsize',16)

%
%subplot(2,3,3)
%flat_pcolor(LON,LAT,(melt1_timeav-meltBase_timeav).*mask_zice_nan);
%colorbar,hold on, %plot(temp1,temp2,'k.','markersize',1)
%hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
%hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
%caxis([-1 5])
%cmocean('balance','pivot',0),
%colorbar
%grid on
%set(gca,'layer','top')
%ntitle(' c','location','northwest','fontweight','bold','fontsize',16)



colorlist=get(gca,'ColorOrder');
subplot(2,2,[3:4])
hBase=plot(otBase,myBase,'color',colorlist(1,:)); greyout(hBase),greyout(hBase)
hold on, hBases=plot(otBase,smooth(myBase,36),'linewidth',3,'color',colorlist(1,:));
h1=plot(ot1,my1,'color',colorlist(2,:)); greyout(h1),greyout(h1)
hold on, h1s=plot(ot1,smooth(my1,36),'linewidth',3,'color',colorlist(2,:));
h2=plot(ot1,my2,'color',colorlist(3,:)); greyout(h2),greyout(h2)
hold on, h2s=plot(ot1,smooth(my2,36),'linewidth',3,'color',colorlist(3,:));

uistack(hBases,'top')
uistack(h1s,'top')
uistack(h2s,'top')

xlabel('model years','fontsize',16),ylabel('melt rate (m/yr)','fontsize',16)
ntitle(' c','location','northwest','fontweight','bold','fontsize',16)
axis tight,
ntitle('Area-averaged melt rate','fontweight','bold','fontsize',16),
YLim=ylim;
%plot([30 30],[YLim(1) YLim(2)],'k--','linewidth',3)
legend([hBases h1s h2s],{'Spinup','Control','SGFW discharge'},'location','southeast'), legend boxoff
%xlim([1948 2007]),set(gca,'xtick',[1945:5:2010])
%export_fig melt_comparison -png -transparent -m2.5
