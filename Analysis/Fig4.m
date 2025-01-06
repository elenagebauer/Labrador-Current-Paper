% Figure 4: Temperature and Salinity averages 07-18

load('../Data/LAB60_TEMP_data.mat');
load('../Data/LAB60_SAL_data.mat');
%path='/mnt/storage6/myers/ANALYSIS/TRANSPORTS-LAB60/secFlux/2_ANHA4-ECP017/matfile/';
sec_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_y=[2007:2018];
period_m=[1:12];
o=[2007,2008];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
dist_data=load('../Data/Section_distances.mat');
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
     for n=1:12;
         month=char(month_vec(n,:));
         if n==1;
             S365=nan(12, size(S_month_mean.(name).(month),1),size(S_month_mean.(name).(month),2));
             T365=nan(12, size(T_month_mean.(name).(month),1),size(T_month_mean.(name).(month),2));
         end
         S365(n,:,:)=S_month_mean.(name).(month);
         T365(n,:,:)=T_month_mean.(name).(month);
     end
     S_allmonths.(name)=nanmean(S365,1);
     T_allmonths.(name)=nanmean(T365,1);
 end

l=0;
vertical_gap = 0.042;
horizontal_gap = 0.012;
horizontal_margin = [0.15, 0.02];
vertical_margin = [0.02, 0.12];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-1*horizontal_gap)/2;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 6 * vertical_gap) / 7;

figure;
for s=1:size(sec_names,1);
    row=s
    col =1;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (7 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    name=char(sec_names(s,:));
    name
    S_allmonths.(name)=squeeze(S_allmonths.(name));
    T_allmonths.(name)=squeeze(T_allmonths.(name));
    X = eval(strcat('dist_data.X_', name));
    Y = eval(strcat('dist_data.Y_', name));
    l=l+1;
    h1=subplot(7,2,l);
    set(h1, 'Position', positions);
    [c2,t2]=contourf(X,Y,T_allmonths.(name)(1:48,:),20);
    set(t2,'LineColor','none');
    hold on;
    zindex34=34.0;
    zindex348=34.8;
    [g, h]=contour(X,Y,S_allmonths.(name)(1:48,:),[33.3 33.3],'LineWidth',1.3, 'EdgeColor', 'black');
    clabel(g, h,'FontSize',10);
    labels='33.3';
    hold on;
    [e,f]=contour(X,Y,S_allmonths.(name)(1:48,:),[34.8 34.8],'LineWidth',1.3, 'EdgeColor', 'black');
    clabel(e,f,'FontSize',10 );
    hold off;
    k=gca;
    colormap(k,cmocean('thermal'));
    cl=[-2,6];
    set(k, 'CLim', cl, 'CLimMode', 'manual');
    if s==7;
    cb1=colorbar();
    cb1.Orientation='horizontal';
    cb1.Units='normalized';
    cb1.Position = [h1.Position(1), h1.Position(2)-0.065, h1.Position(3)-0.01, 0.02];
    cb1.Label.String='Potential Temperature[°C]'
    cb1.FontSize=12;
    end
    h1.YTick = [];
    for k = -1000:200:0; 
    h1.YTick = [h1.YTick, k];
    end
    h1.YTickLabel = arrayfun(@(x) num2str(-x), h1.YTick, 'UniformOutput', false);
    ylabel('Depth [m]', 'FontSize', 12);
    xlabel('Distance [km]', 'FontSize', 12);
    x_pos = X(1);
    y_pos = -960;
    text(x_pos, y_pos, [ name], 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    set(gca,'fontsize', 18)

    l=l+1;
    col = 2;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (7 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    h2=subplot(7,2,l);
    set(h2, 'Position',positions);
    [c2,t2]=contourf(X,Y,S_allmonths.(name)(1:48,:),20);
    set(t2,'LineColor','none');
    hold on;
    f=gca;
    colormap(f,cmocean('haline'));
    cl=[32 35.2];
    set(f, 'CLim', cl, 'CLimMode', 'manual');
    zindex34=34.0;
    zindex348=34.8;
    [g, h]=contour(X,Y,S_allmonths.(name)(1:48,:),[33.3 33.3],'LineWidth',1.3, 'EdgeColor', 'black');
    clabel(g, h,'FontSize',10);
    labels='33.3';
    hold on;
    [e,f]=contour(X,Y,S_allmonths.(name)(1:48,:),[34.8 34.8],'LineWidth',1.3, 'EdgeColor', 'black');
    clabel(e,f,'FontSize',10 );
    hold off;
    if s==7;
    cb1=colorbar();
    cb1.Orientation='horizontal';
    cb1.Units='normalized';
    cb1.Position = [h2.Position(1)+0.0125, h2.Position(2)-0.065,h2.Position(3)-0.0125, 0.02];
    cb1.Label.String='Salinity';
    cb1.FontSize=12;
    end
    h2.YTick = [];
    xlabel('Distance [km]', 'FontSize', 12);
    x_pos = X(1);
    y_pos = -960;
    text(x_pos, y_pos, [ name], 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    set(gca,'fontsize', 18)
end

width=11;
height=19;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_TSav0718.png'));

