GrdName = '../tisom008_canal_grd.nc';
LAT = ncread(GrdName,'lat_rho');%, [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
LON = ncread(GrdName,'lon_rho');%, [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_rho_nan=ncread(GrdName,'mask_rho');%,[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
mask_zice_nan=ncread(GrdName,'mask_zice');%,[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
h = ncread(GrdName,'h');%, [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);
zice=ncread(GrdName,'zice');%, [longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);

mask_rho_nan(mask_rho_nan==0)=NaN;


figure
set(gcf,'position',[40 40 1550 1400])
flat_pcolor(LON,LAT,(h+zice).*mask_rho_nan);
hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
load /mnt/IceOceanVolume/MATLAB/moa_gl.mat
load /mnt/IceOceanVolume/MATLAB/moa_cl.mat
temp1=mdgl(:,1);
temp2=mdgl(:,2);
hold on,
plot(temp1,temp2,'k.')
colorbar
axis([113 123 -68 -65.5])


production=1;
figure(2345234)
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.06], [0.07 0.06], [0.08 0.08]);
set(gcf,'position',[40 40 1550 400])
subplot(1,3,1)
flat_pcolor(LON,LAT,h.*mask_rho_nan);
hold on, %plot(temp1,temp2,'k.','markersize',1)
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
%label(h_totten,'Totten Ice Shelf','location','left','fontweight','bold')
cmocean('deep'),
grid on
set(gca,'layer','top')
xlabels = get(gca, 'XTicklabels'); xlabels_new = strcat(xlabels, '\circE'); set(gca, 'XTicklabels', xlabels_new)
ylabels = get(gca, 'YTicklabels'); for uu=1:length(ylabels),ylabels{uu}(1)=[];end, ylabels_new = strcat(ylabels, '\circS'); set(gca, 'YTicklabels', ylabels_new)
curraxis=axis; axis([104.5 130 -68 -60])
h_inset=inset_unproj('nw','insetsize',0.5,'frame','off'); h_inset_pos=get(h_inset,'pos');
ntitle(' a','location','northwest','fontweight','bold','fontsize',16,'color',[1 1 1])
%ntitle(['Melt rate ',num2str(round(nanmean(my)*10)/10) '\pm',num2str(round(nanstd(my)*10)/10) ' m/yr'],'fontweight','bold','fontsize',16),
axis(curraxis)
set(h_inset,'pos',[h_inset_pos(1) h_inset_pos(2)-.006 h_inset_pos(3) h_inset_pos(4)]);
%
subplot(1,3,2)
load('../rvr/Totten_river_sources_forplotting_sheet.mat');
flat_pcolor(LON,LAT,h.*mask_rho_nan), cmocean('deep')
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
grid on, set(gca,'layer','top')
ntitle([' b  Sheet flow volume flux (m3/s)'],'location','northwest','fontweight','bold','fontsize',16)
axis([112.9 121 -67.6 -66])
hold on,hhh3=bubbleplot(ROMS_river_lonlat_filtered(notzero_indices,1),ROMS_river_lonlat_filtered(notzero_indices,2),[],Data_mat_filtered(:,5));
set(hhh3,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[1 .7 0],...
              'LineWidth',1.5)
hhh4=bubbleplot([117 117 117 117],[-67.35,-67.4,-67.45 -67.5],[],[max(Data_mat_filtered(:,5)) 1e-1 5e-2 1e-2]);
set(hhh4,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[1 .7 0],...
              'LineWidth',1.5)
text([117 117 117 117]+.2,[-67.35,-67.4,-67.45 -67.5],{num2str(max(Data_mat_filtered(:,5))) '1e-1' '1e-2' '1e-3'},'color',[.1 .1 .1])
%
subplot(1,3,3)
load('../rvr/Totten_river_sources_forplotting_channel.mat');
flat_pcolor(LON,LAT,h.*mask_rho_nan), cmocean('deep'),colorbar
hold on,contour(LON,LAT,h,[20:1:21],'k-','linewidth',2) %grounding line
hold on,contour(LON,LAT,zice,[-1:1:0],'k:','linewidth',2) %icefront line
grid on, set(gca,'layer','top')
ntitle(' c  Channel flow volume flux (m3/s)','location','northwest','fontweight','bold','fontsize',16)
axis([112.9 121 -67.6 -66])
hold on,hhh3=bubbleplot(ROMS_river_lonlat_filtered(notzero_indices,1),ROMS_river_lonlat_filtered(notzero_indices,2),[],Data_mat_filtered(:,5));
set(hhh3,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[1 .7 0],...
              'LineWidth',1.5)
hhh4=bubbleplot([117 117 117 117],[-67.35,-67.4,-67.45 -67.5],[],[max(Data_mat_filtered(:,5)) 1e-1 5e-2 1e-2]);
set(hhh4,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[1 .7 0],...
              'LineWidth',1.5)
text([117 117 117 117]+.2,[-67.35,-67.4,-67.45 -67.5],{num2str(max(Data_mat_filtered(:,5))) '1e-1' '1e-2' '1e-3'},'color',[.1 .1 .1])

