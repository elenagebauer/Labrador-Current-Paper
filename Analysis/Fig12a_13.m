% Figure 12a and 13

sec_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_m=[1:12];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
load('../Data/LAB60_TRANSPORT_FWT_S333.mat');
load('../Data/LAB60_TRANSPORT_VT_S333.mat');
cross_names={'BI_MB';'MB_SI';'SI_WB';'WB_BB';'BB_FC';'FC_SEGB'};
cross_names_plot={'BI-MB';'MB-SI';'SI-WB';'WB-BB';'BB-FC';'FC-SEGB'};

% Calculkation of Transport loss and transport gain
for s=1:size(cross_names,1);
    cross_name=char(cross_names(s,:));
    name1=char(sec_names(s,:));
    name2=char(sec_names(s+1,:));
    FWT_loss.(cross_name)=struct();
    VT_loss.(cross_name)=struct();
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:12;
            FWT_loss.(cross_name).(year_a)(n)=(FWT_monthly_S333.(name1).(year_a)(n)-FWT_monthly_S333.(name2).(year_a)(n));
            VT_loss.(cross_name).(year_a)(n)=(VT_monthly_S333.(name1).(year_a)(n)-VT_monthly_S333.(name2).(year_a)(n));
        end
    end
end
figure;
months = 1:12;
Colors={'[0.8500 0.3250 0.0980]';'[0.9290 0.6940 0.1250]';'[0.4940 0.1840 0.5560]';'[0.4660 0.6740 0.1880]';'[0.3010 0.7450 0.9330]';'[0.6350 0.0780 0.1840]'}
ax = axes;
plot(period_m, zeros(length(period_m),1), 'Color',[.7 .7 .7],'LineWidth',1, 'HandleVisibility', 'off');
hold on;
for s=1:size(cross_names,1);
    cross_name=char(cross_names(s,:));
    VT_loss_av=zeros(12,1);
    FWT_loss_av=zeros(12,1);
    for n=1:12;
        FWT_losses=zeros(12,1);
        VT_losses=zeros(12,1);
        for m=2007:2018;
            year_a=char(years_a(m-2006,:));
            FWT_losses(m-2006)=FWT_loss.(cross_name).(year_a)(n);
            VT_losses(m-2006)=VT_loss.(cross_name).(year_a)(n);
        end
        VT_loss_av(n)=nanmean(VT_losses);
        FWT_loss_av(n)=nanmean(FWT_losses);
    end
    plot(period_m,FWT_loss_av/(10^3),'Color',char(Colors(s,:)),'LineWidth',2.5,'Marker','.', 'MarkerSize',18);
    hold on;
end
hold off;
lgd=legend('BI-MB','MB-SI','SI-WB','WB-BB','BB-FC','FC-SEGB',  'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff', 'FontSize',16);
ylabel('FWT Loss [mSv]', 'FontSize', 12)
xlim([1,12]);
ax.XTick=[];
ax.XTickLabel=[];
ax.XTick=months;
ax.XTickLabel=cellstr(datestr(datenum(2000, months, 1), 'mmm'));
set(gca,'fontsize', 16);
width=10;
height=6;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_TDiff_S333_seasonalcy','.png'));


save('/mnt/storage6/elena/LAB60/FWT_loss.mat','FWT_loss');





time = datetime(2007,1,9):calmonths(1):datetime(2018,12,31);
for s=1:size(cross_names,1);
    name=char(cross_names(s,:));
    VT_loss_plots=[];
    FWT_loss_plots=[];
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:12;
            VT_loss_plots=[VT_loss_plots;VT_loss.(name).(year_a)(n)];
            FWT_loss_plots=[FWT_loss_plots;FWT_loss.(name).(year_a)(n)];
        end
    end
    VT_loss_plot.(name)= VT_loss_plots;
    FWT_loss_plot.(name)= FWT_loss_plots;

end

nulllinie2=zeros(length(time),1);
l=0;
figure;
vertical_gap = 0.042;
horizontal_gap = 0.08;
horizontal_margin = [0.083, 0.02];
vertical_margin = [0.02, 0.06];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-1*horizontal_gap)/2;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 5 * vertical_gap) / 6;

for s=1:size(cross_names,1);
    l=l+1;
    row=s
    col=1;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (6 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];

    name_plot=char(cross_names_plot(s,:));
    name=char(cross_names(s,:));
    name
    mean2=nanmean(VT_loss_plot.(name)/(10^3))*ones(1,length(time));
    mean4=nanmean(FWT_loss_plot.(name)/(10^3))*ones(1,length(time));
    
    
   
    h1=subplot(6,2,l);
    set(h1, 'Position', positions);
    positions
    plot(time,VT_loss_plot.(name)/(10^3), 'LineWidth',2.5,'Marker','.', 'MarkerSize',18, 'Color','k');
    hold on;
    plot(time, mean2, 'LineWidth',2,'LineStyle','--', 'Color', 'r');
    hold on;
    plot(time, nulllinie2, 'Color',[.7 .7 .7],'LineWidth',1.5);
    hold off;
    if l==3;
	disp(VT_loss_plot.(name)/(10^3));
    end
    ylabel('VT Loss [mSv]', 'FontSize', 12);

    if l==1;
        y_pos = 500;
        ylim([-400 500]);
    elseif l==3;
        y_pos=400;
        ylim([-800 400]);
    elseif l==5;
        y_pos=600;
        ylim([-1000 600]);
    elseif l==7;
        y_pos=600;
        ylim([-600 600]);
    elseif l==9;
        y_pos=2000;
        ylim([-500 2000]);
    elseif l==11;
        y_pos=2500;
        ylim([0 2500]);
     end
    k=gca;
    x_pos= mean(time);
    x_numeric = datenum(x_pos);
    text(x_numeric, y_pos, [ name_plot], 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');   
    s
    l=l+1
    col = 2;
    row=s; 
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (6 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];

    h2=subplot(6,2,l);
    set(h2, 'Position',positions);
    disp(name);
    plot(time,FWT_loss_plot.(name)/(10^3), 'LineWidth',2.5,'Marker','.', 'MarkerSize',18, 'Color', 'k');
    hold on;
    plot(time, mean4, 'LineWidth',2,'LineStyle','--', 'Color', 'r');
    hold on;
    plot(time, nulllinie2, 'Color',[.7 .7 .7],'LineWidth',1.5);
    hold off;
    if l==2;
        y_pos = 30;
        ylim([-30 30]);
    elseif l==4;
        y_pos=30;
        ylim([-50 30]);
    elseif l==6;
        y_pos=50;
        ylim([-50 50]);
    elseif l==8;
        y_pos=40;
        ylim([-30 40]);
    elseif l==10;
        y_pos=100;
        ylim([-40 100]);
    elseif l==12;
        y_pos=140;
        ylim([0 140]);
    end
    k=gca;
    x_pos= mean(time);
    x_numeric = datenum(x_pos);
    text(x_numeric, y_pos, [ name_plot], 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

    set(gca,'fontsize', 18);

    ylabel('FWT Loss [mSv]', 'FontSize', 12);
    set(gca,'fontsize', 26);
end
width=23;
height=28;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf,'/mnt/storage6/elena/LAB60/Plots/LAB60_TransportDiff_0718.png');
