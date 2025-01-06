
% Figure 1: Bathymetry Plot

load('../Data/lat_lon_BI.mat')
load('../Data/lat_lon_MB.mat')
load('../Data/lat_lon_SI.mat')
load('../Data/lat_lon_WB.mat')
load('../Data/lat_lon_BB.mat')
load('../Data/lat_lon_FC.mat')
load('../Data/lat_lon_SEGB.mat')


file = ('/mnt/storage1/xhu/ANHA12-I/new_bathymetry/ANHA12_mesh_zgr.nc');
info = ncinfo(file);
lon = ncread(file,'nav_lon');
lat = ncread(file,'nav_lat');
hdept = ncread(file,'hdept');
hdepw = ncread(file,'hdepw');
hdepw(hdepw < 0) = NaN;
hdepw(hdepw==0) =NaN;

figure;
m_proj('lambert', 'lat',[36, 67], 'lon', [-80, -29],'edgecolor', 'none');
hold on;
levels=[0,50,100,150,200,250, 300,350, 400,450, 500,750,1000,1500,2000,2500,3000,3500,4000,4500, 5000]
[C,h]=m_contourf(lon,lat,hdepw, levels,'LineStyle', 'none'); shading flat
ylabel('Latitude', 'FontSize',20);
xlabel('Longitude','FontSize',20);
set(gca, 'xtick',[])
set(gca, 'XTickLabel', [])
axis off;
colormap(flipud(gray));
caxis([min(levels),max(levels)])
c=colorbar('Direction', 'reverse', 'Orientation','horizontal');
c.Label.String='Depth [m]';
c.Units = 'normalized';
c.Orientation='horizontal';
c.FontSize=12;
c.Label.FontSize=16;
c.Position = [0.06, 0.08, 0.3, 0.03]
m_grid('fontsize',16,'box','fancy');
m_grid('BackgroundColor', [0.1 0.2 0.05]);
file = ('/mnt/storage5/clark/ANHA4-ECP017-Second/2_mesh_zgr.nc');
xRange=[-62, -40];
yRange=[41.5, 58];
lon_rect = [linspace(xRange(1), xRange(1), 50), ...
            linspace(xRange(1), xRange(2), 50), ...
            linspace(xRange(2), xRange(2), 50), ...
            linspace(xRange(2), xRange(1), 50)];
lat_rect = [linspace(yRange(1), yRange(2), 50), ...
            linspace(yRange(2), yRange(2), 50), ...
            linspace(yRange(2), yRange(1), 50), ...
            linspace(yRange(1), yRange(1), 50)];

m_plot(lon_rect, lat_rect, 'color', 'magenta', 'LineWidth', 3);
hold off;
width=16;
height=10;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, '/mnt/storage6/elena/LAB60/Plots/bathy_reac1.png');



figure;
m_proj('lambert', 'lat', [42, 58.2], 'lon', [-62, -41]);

hold on;
m_contourf(lon, lat, hdepw, levels, 'LineStyle', 'none'); 
colormap(flipud(gray));
caxis([min(levels),max(levels)]);
m_grid('BackgroundColor', [0.1 0.2 0.05]);
m_grid('FontSize', 12)
lon = ncread(file,'nav_lon');
lat = ncread(file,'nav_lat');
hdept = ncread(file,'hdept');
hdepw = ncread(file,'hdepw');

% new sections_____________________________________________________________
load '../Data/LAB60_AZMP_crossWB_BBIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');
load '../Data/LAB60_AZMP_crossSI_WBIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');
load '../Data/LAB60_AZMP_crossMB_SIIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');
load '../Data/LAB60_AZMP_crossFC_SEGBIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');
load '../Data/LAB60_AZMP_crossBI_MBIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.iLogOri, secInfo.jLogOri);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');
load '../Data/LAB60_AZMP_crossBB_FCIndex.mat'
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'r','LineWidth',3, 'Color','[0,1,0]');

% AZMP sections _______________________________________________________
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_BIIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='BI';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_MBIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='MB';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_SIIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='SI';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_WBIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='WB';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_BBIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='BB';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_FCIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='FC';
load('/mnt/storage6/myers/ANALYSIS/SECTION-CREATE/secIndex/LAB60_AZMP_SEGBIndex.mat');
sec_ind=sub2ind([1179 2659], secInfo.II, secInfo.JJ);
m_plot(lon(sec_ind),lat(sec_ind),'magenta','LineWidth',3)
tx='SEGB';

width=16;
height=10;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, '/mnt/storage6/elena/LAB60/Plots/bathy_rec2.png');
