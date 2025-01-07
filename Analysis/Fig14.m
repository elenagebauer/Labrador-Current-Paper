%Figure 14

load('../Data/Section_latlon_values.mat');
load('../Data/taux_plot_LS.mat');
load('../Data/tauy_plot_LS.mat');
load('../Data/theta_sec.mat');
load('../Data/M_sec.mat')
load('../Data/lat_lon_sec.mat')
sec_names={'AZMP_crossBI_MB';'AZMP_crossMB_SI';'AZMP_crossSI_WB';'AZMP_crossWB_BB';'AZMP_crossBB_FC';'AZMP_crossFC_SEGB'};
cross_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'}
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_y=[2007:2018];
period_m=[1:12];
o=[2007,2008];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

for s=1:size(sec_names,1)
    name=char(sec_names(s,:));
    distance.(name)=struct();
    latlon1=[lat_sec.(name)(1), lon_sec.(name)(1)];
    latlon2=[lat_sec.(name)(length(lon_sec.(name))), lon_sec.(name)(length(lon_sec.(name)))];
    radius=6371;
    lat1=latlon1(:,1)*pi/180;
    lat2=latlon2(:,1)*pi/180;
    lon1=latlon1(:,2)*pi/180;
    lon2=latlon2(:,2)*pi/180;
    deltaLat=lat2-lat1;
    deltaLon=lon2-lon1;
    a=sin((deltaLat)/2).^2 + (cos(lat1).*cos(lat2)) .* sin(deltaLon/2).^2;
    c=2*atan2(sqrt(a),sqrt(1-a));
    distance.(name)=radius*c;
end

M_avyear=struct();
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    M_avyear.(name)=nan(size(M_sec.(name).(year_a),1), size(M_sec.(name).(year_a),2));
    for n=1:12;
        for m=2007:2018;
            year_a=char(years_a(m-2006,:));
            if m==2007;
                means=nan(12,size(M_sec.(name).(year_a),2));
            end
            means(m-2006,:)=M_sec.(name).(year_a)(n,:);
        end
       M_avyear.(name)(n,:)=nanmean(means,1) ;
    end
end

vertical_gap = 0.08;
horizontal_gap = 0.09;
horizontal_margin = [0.08, 0.05];
vertical_margin = [0.05, 0.08];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-3*horizontal_gap)/4;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 2 * vertical_gap) / 3;

figure;
for m=1:12;
    row=ceil(m / 4);
    col = mod(m-1, 4) + 1;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (3 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    month=char(month_vec(m,:));
    ax1=subplot(3,4,m);
    set(ax1, 'Position', positions);
    lon_plot=lon(1:70:end, 1:70:end);
    lat_plot=lat(1:70:end, 1:70:end);

    m_proj('lambert','long',[-60 -41],'lat',[42 60]);
    hold on;
   m_coast('patch', [0.5 0.5 0.5]);
   h1=m_quiver(lon_plot,lat_plot,taux_plot.(month),tauy_plot.(month),1.25,'b', 'LineWidth',1.25, 'MaxHeadSize',4);
   hold on;
   for s=1:size(sec_names,1);
        name=char(sec_names(s,:))
        lon_sec_plot.(name)=lon_sec.(name)(1:40:end);
        lat_sec_plot.(name)=lat_sec.(name)(1:40:end);
        m_plot(lon_sec.(name), lat_sec.(name), 'Color','k','LineWidth',1.25);
        Msin_plot.(name)=(M_avyear.(name)(m,:).*cosd(theta_sec.(name)));
        Mcos_plot.(name)=(M_avyear.(name)(m,:).*sind(theta_sec.(name)));
        Msin_plot.(name)=movmean(Msin_plot.(name),40)
        Mcos_plot.(name)=movmean(Mcos_plot.(name),40)
        Msin_plot2.(name)=Msin_plot.(name)(1:end,1:40:end);
        Mcos_plot2.(name)=Mcos_plot.(name)(1:end,1:40:end);
        hold on;
        pq=m_quiver(lon_sec_plot.(name),lat_sec_plot.(name),Msin_plot2.(name), Mcos_plot2.(name),'r', 'LineWidth',1.5, 'MaxHeadSize',3);
        set(pq, 'AutoScale','on', 'AutoScaleFactor', 1.5);
        uistack(pq, 'top');
        hold on;

    end

    lon_ticks=-60:4:-40
    lon_labels=lon_ticks(1:2:end)
    m_grid('xtick',lon_labels,'FontSize',14)
    title(month,'FontSize',18);
    ylabel('Latitude','FontSize',16);
    xlabel('Longitude','FontSize',16);
    set(gca, 'FontSize',18);
end
width=18;
height=16;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf,strcat( '/mnt/storage6/elena/LAB60/Plots/LAB60_Ekman_quiver_rotated.png'));


