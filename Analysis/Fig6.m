sec_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
distance_names={'bi';'mb';'si';'wb';'bb';'fc';'segb'};
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
cross_names={'AZMP_crossBI_MB';'AZMP_crossMB_SI';'AZMP_crossSI_WB';'AZMP_crossWB_BB';'AZMP_crossBB_FC';'AZMP_crossFC_SEGB'};
load('../Data/Section_latlon_values.mat');
load('../Data/LAB60_SAL_data.mat');
load('../Data/LAB60_TEMP_data.mat');
dist_data=load('../Data/Section_distances.mat');

for s=1:size(distance_names,1)
    distance_name=char(distance_names(s,:));
    name=char(sec_names(s,:));
    distance.(name)=struct();
    latlon1_c=eval(strcat('latlon1_',distance_name));
    latlon2_c=eval(strcat('latlon2_',distance_name));
    distance.(name)=sw_dist([latlon1_c(1),latlon2_c(1)],[latlon1_c(2),latlon2_c(2)],'km'); 
end
for s=1:size(sec_names,1);
     name=char(sec_names(s,:));
     T_month_mean.(name)=struct();
     S_month_mean.(name)=struct();
     for n=1:12;
         month=char(month_vec(n,:));
         for m=2007:2018;
             year_a=char(years_a(m-2006,:));
             if m==2007;
                 T_mean=zeros(length(T_monthly.(name).(year_a).(month)(:,1)),length(T_monthly.(name).(year_a).(month)(1,:)));
                 S_mean=zeros(length(S_monthly.(name).(year_a).(month)(:,1)),length(S_monthly.(name).(year_a).(month)(1,:)));
             end
             T_mean=T_mean+T_monthly.(name).(year_a).(month);
             S_mean=S_mean+S_monthly.(name).(year_a).(month);
             T_mean(T_mean==0)=nan;
             S_mean(S_mean==0)=nan;
         end
         T_month_mean.(name).(month)=T_mean/12;
         S_month_mean.(name).(month)=S_mean/12;
     end
 end
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        S_anomalies.(name).(year_a)=struct();
        T_anomalies.(name).(year_a)=struct();
        for n=1:12;
            month=char(month_vec(n,:));
            if n==1
                 S_anomalies.(name).(year_a)=nan(12,length(S_monthly.(name).(year_a).(month)(:,1)),length(S_monthly.(name).(year_a).(month)(1,:)));
                 T_anomalies.(name).(year_a)=nan(12,length(T_monthly.(name).(year_a).(month)(:,1)),length(T_monthly.(name).(year_a).(month)(1,:)));
            end
            month=char(month_vec(n,:));
            S_anomalies.(name).(year_a)(n,:,:)=S_monthly.(name).(year_a).(month)-S_month_mean.(name).(month);
            T_anomalies.(name).(year_a)(n,:,:)=T_monthly.(name).(year_a).(month)-T_month_mean.(name).(month);
        end
    end
end
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        S_anomalies_yearly.(name).(year_a)=struct();
        T_anomalies_yearly.(name).(year_a)=struct();
        S_anomalies_yearly.(name).(year_a)=nanmean(S_anomalies.(name).(year_a),1);
        T_anomalies_yearly.(name).(year_a)=nanmean(T_anomalies.(name).(year_a),1);

    end
end



% PLOT_______________________________________________________


years=datetime(2007,01,01):calyears(1):datetime(2018,12,31);
months=datenum(datetime(2007,01,09):calmonths(1):datetime(2018,12,31));


S_anomalies_new=S_anomalies;
T_anomalies_new=T_anomalies;

for s=1:size(sec_names,1);
    sec_name=char(sec_names(s,:));
    S_av100.(sec_name)=nan(144, size(S_anomalies.(sec_name).(year_a),3));
    T_av100.(sec_name)=nan(144, size(T_anomalies.(sec_name).(year_a),3));
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:12;
            month=char(month_vec(n,:));
            S_arbeit=squeeze(S_anomalies_new.(sec_name).(year_a)(n,:,:));
            S_arbeit(S_monthly.(sec_name).(year_a).(month)>=33.3)=nan;
            T_arbeit=squeeze(T_anomalies_new.(sec_name).(year_a)(n,:,:));
            T_arbeit(S_monthly.(sec_name).(year_a).(month)>=33.3)=nan;
            S_hov33.(sec_name)((m-2007)*12+n,:)=nanmean(S_arbeit,1);
            T_hov33.(sec_name)((m-2007)*12+n,:)=nanmean(T_arbeit,1);
        end
    end
end
Z_hov=[1:12*24];
months=datenum(datetime(2007,01,09):calmonths(1):datetime(2018,12,31));
vertical_gap = 0.01;
horizontal_gap = 0.008 
horizontal_margin = [0.04, 0.08];
vertical_margin = [0.08, 0.08];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-6*horizontal_gap)/7;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 1 * vertical_gap) / 2;

figure;
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    distance_name=char(distance_names(s,:));
    X = eval(strcat('dist_data.X_', name));
    X=X(1,:);
    [X_hov,Y_hov]=meshgrid(X,months);
    row=1;
    col = s
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (2 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    ax1=subplot(2,7,s);
    set(ax1, 'Position', positions);
    [c2,t2]=contourf(ax1,X_hov,Y_hov,S_hov33.(name),20);
    set(t2,'LineColor','none');
    colormap(cmocean('balance'));
    cl=[-0.4, 0.4];

    title(name, 'FontSize', 18);
    ax1.YTick=[];
    for k=0:11;
         ax1.YTick=[ax1.YTick, months(12*k+1)];
    end
     if s==1;
        ax1.YTickLabel={datestr(ax1.YTick,'yyyy')};
     else
        ax1.YTickLabel={};
     end
     ax1.XTickLabel={};
     cl1=[-0.8, 0.8];
     set(ax1, 'CLim', cl1, 'CLimMode', 'manual')
     set(gca,'fontsize', 16);
     x_pos = X(end);
     y_pos = months(1);
end
cb1=colorbar(ax1);
     cb1.Orientation='vertical';
     cb1.Units='normalized';
     cb1.Position=[ax1.Position(1)+ax1.Position(3)+0.01, ax1.Position(2)+0.007, 0.02-0.005, ax1.Position(4)-0.007]
     cb1.Label.String='Salinity Anomaly'
     cb1.FontSize=14;

for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    distance_name=char(distance_names(s,:));
    X = eval(strcat('dist_data.X_', name));
    X=X(1,:);
    Y = eval(strcat('dist_data.Y_', name));
    [X_hov,Y_hov]=meshgrid(X,months);
    row=2;
    col = s
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (2 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];

    ax1=subplot(2,7,s+7);
    set(ax1, 'Position', positions);
    [c2,t2]=contourf(ax1,X_hov,Y_hov,T_hov33.(name),20);
    set(t2,'LineColor','none');
    colormap(cmocean('balance'));
    cl=[-0.4, 0.4];
    xlabel('km', 'FontSize', 12);
    ax1.YTick=[];
    for k=0:11;
         ax1.YTick=[ax1.YTick, months(12*k+1)];
    end
     if s==1;
        ax1.YTickLabel={datestr(ax1.YTick,'yyyy')};
     else
        ax1.YTickLabel={};
     end
     cl1=[-2,2];
     set(ax1, 'CLim', cl1, 'CLimMode', 'manual')
    set(gca,'fontsize', 16);
end
     cb1=colorbar(ax1);
     cb1.Orientation='vertical'; 
     cb1.Units='normalized';
     cb1.Position=[ax1.Position(1)+ax1.Position(3)+0.01, ax1.Position(2), 0.02-0.005, ax1.Position(4)-0.007]
     cb1.Label.String=sprintf('Potential Temperature\nAnomaly [°C]')
     cb1.FontSize=14;
     cl1=[-2,2];
     width=17;
     height=9;
     set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height])
     saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_hovmoeller.png'));


