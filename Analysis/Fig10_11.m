% Figure 10 and 11

sec_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_m=[1:12];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

load('../Data/LAB60_TRANSPORT_FWT_S333.mat');
load('../Data/LAB60_TRANSPORT_VT_S333.mat');

figure;
months = 1:12;
ax = axes;
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    VT_av=zeros(12,1);
    FWT_av=zeros(12,1);
    for n=1:12;
        FWT=zeros(12,1);
        VT=zeros(12,1);
        for m=2007:2018;
            year_a=char(years_a(m-2006,:));
            FWT(m-2006)=FWT_monthly_S333.(name).(year_a)(n);
            VT(m-2006)=VT_monthly_S333.(name).(year_a)(n);
        end
        VT_av(n)=nanmean(VT);
        FWT_av(n)=nanmean(FWT);
    end
    plot(period_m,FWT_av/(10^3),'LineWidth',2.5,'Marker','.', 'MarkerSize',18);
    hold on;
end
hold off;
lgd=legend('BI','MB','SI','WB','BB','FC','SEGB',  'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff', 'FontSize',16);
ylabel('FWT [mSv]', 'FontSize', 12)
xlim([1,12]);
ax.XTick=[];
ax.XTickLabel=[];
ax.XTick=months;
ax.XTickLabel=cellstr(datestr(datenum(2000, months, 1), 'mmm'));
set(gca,'fontsize', 16);
width=14;
height=6;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_T_S333_seasonalcy','.png'));






time = datetime(2007,1,9):calmonths(1):datetime(2018,12,31);
for s=1:size(sec_names,1);
    name=char(sec_names(s,:));
    VT_33_plot=[];
    FWT_33_plot=[];
    VT_340_plot=[];
    FWT_340_plot=[];
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:12;
            VT_33_plot=[VT_33_plot;VT_monthly_S333.(name).(year_a)(n)];
            FWT_33_plot=[FWT_33_plot;FWT_monthly_S333.(name).(year_a)(n)];
        end
    end
    VT_333_plot.(name)= VT_33_plot;
    FWT_333_plot.(name)= FWT_33_plot;
end
l=0;

vertical_gap = 0.042;
horizontal_gap = 0.08;
horizontal_margin = [0.06, 0.02];
vertical_margin = [0.02, 0.06];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-1*horizontal_gap)/2;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 6 * vertical_gap) / 7;

figure;
for s=1:size(sec_names,1);
    row=s;
    col=1;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (7 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    name=char(sec_names(s,:));
    mean2=nanmean(VT_333_plot.(name)/(10^6))*ones(1,length(time));
    mean4=nanmean(FWT_333_plot.(name)/(10^3))*ones(1,length(time));
     
    l=l+1;
    h1=subplot(7,2,l);
    set(h1, 'Position', positions);
    plot(time,VT_333_plot.(name)/(10^6), 'LineWidth',2.5,'Marker','.', 'MarkerSize',18, 'Color','k');
    hold on;
    plot(time, mean2, 'LineWidth',2,'LineStyle','--', 'Color', 'r');
   hold off;
   box off;
    k=gca;
    ylabel('VT [Sv]', 'FontSize', 12);
    if l==1;
	y_pos = 2.67;
	ylim([0 3]);
    elseif l==3;
	y_pos=2.67;
	ylim([0.5 3]);
    elseif l==5;
        y_pos=2.68;
	ylim([0.5 3]);
    elseif l==7;
        y_pos=3.22;
	ylim([0.5 3.5]);
    elseif l==9;
        y_pos=2.75;
	ylim([0.5 3]);
    elseif l==11;
        y_pos=3.1;
	ylim([0 3.5]);
    elseif l==13;
        y_pos=1.7;
	ylim([-0.5 2]);
    end
  
    x_pos= mean(time);
    x_numeric = datenum(x_pos);
    text(x_numeric, y_pos, [ name], 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    set(gca,'fontsize', 26);    
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
    disp(positions);
    plot(time,FWT_333_plot.(name)/(10^3), 'LineWidth',2.5,'Marker','.', 'MarkerSize',18, 'Color', 'k');
    hold on;
    plot(time, mean4, 'LineWidth',2,'LineStyle','--', 'Color', 'r'),
    
    box off;
    if l==2;
        y_pos = 200;
        ylim([20 230]);
    elseif l==4;
        y_pos=200;
        ylim([20 230]);
    elseif l==6;
        y_pos=240;
        ylim([0 280]);
    elseif l==8;
        y_pos=220;
        ylim([40 250]);
    elseif l==10;
        y_pos=220;
        ylim([40 250]);
    elseif l==12;
        y_pos=200;
        ylim([20 230]);
    elseif l==14;
        y_pos=125;
        ylim([-40 150]);
    end
    x_pos= mean(time);
    x_numeric = datenum(x_pos);
    text(x_numeric, y_pos, [ name], 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    ylabel('FWT [mSv]', 'FontSize', 12);
    set(gca,'fontsize', 26);
end
width=23;
height=29;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_Transport_0718.png'));
