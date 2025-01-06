%Figure 15


load('../Data/LAB60_TRANSPORT_FWT_S333.mat');
load('../Data/M_TDiff_EK_FW333_sec.mat')
cross_names={'AZMP_crossBI_MB';'AZMP_crossMB_SI';'AZMP_crossSI_WB';'AZMP_crossWB_BB';'AZMP_crossBB_FC';'AZMP_crossFC_SEGB'};
sec_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
diff_names={'BI_MB';'MB_SI';'SI_WB';'WB_BB';'BB_FC';'FC_SEGB'};
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_y=[2007:2018];
period_m=[1:12];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
time=datenum(datetime(2007,01,09):calmonths(1):datetime(2018,12,31));
nulllinie2=zeros(length(time),1)
time


for s=1:size(cross_names,1);
    cross_name=char(cross_names(s,:));
    name1=char(sec_names(s,:));
    name2=char(sec_names(s+1,:));
    FWT_loss.(cross_name)=struct();
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:12;
            FWT_loss.(cross_name).(year_a)(n)=(FWT_monthly_S333.(name1).(year_a)(n)-FWT_monthly_S333.(name2).(year_a)(n));
        end
    end
end



figure;
vertical_gap = 0.07;
horizontal_margin = [0.08, 0.03];
vertical_margin = [0.07, 0.07];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2));
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 5 * vertical_gap) / 6;

for s=1:size(cross_names,1);
    cross_name=char(cross_names(s,:));
    diff_name=char(diff_names(s,:));
    name1=char(sec_names(s,:));
    name2=char(sec_names(s+1,:));
    row=s
    positions = [
        horizontal_margin(1),...
        vertical_margin(2) + (6 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    h1=subplot(6,1,s);
    set(h1,'Position', positions);
    plot_M=[];
    plot_FWL=[];
    for m=2007:2018;
        year_a=char(years_a(m-2006));
        plot_M=[plot_M,M_TDiff_EK_FW333_sec.(cross_name).(year_a)/10^3];
        plot_FWL=[plot_FWL,FWT_loss.(cross_name).(year_a)/10^3];
    end
    plot(time, plot_FWL, 'LineWidth', 1.5,'Marker','.', 'MarkerSize',17, 'Color','black')
    hold on;
    plot(time, plot_M, 'LineWidth', 1.5,'Marker','.', 'MarkerSize',17, 'Color','red')
    hold on;

    title(strcat(name1,'-',name2), 'Fontsize',22)
    ylabel('Flux [mSv]', 'FontSize', 16)


    if s==1;
         ldg=legend('FWT loss','EkFW', 'Orientation','horizontal');
         legend('Boxoff')
         ldg.Units='normalized';
         ldg.FontSize=12;
         ldg.Position=[h1.Position(1)+h1.Position(3)-0.33, h1.Position(2)+h1.Position(4)+0.015, 0.4, 0.02];
    end
    plot(time, nulllinie2, 'Color',[.7 .7 .7],'LineWidth',0.8);
    xlim([datenum(2007,01,09) datenum(2018,12,31)]);
    datetick('x', 'yyyy', 'keeplimits');
    set(gca, 'FontSize',18);
end
width=18;
height=18;
xlim([datenum(2007,01,09) datenum(2018,12,31)]);
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
savefile='/mnt/storage6/elena/LAB60/Plots/FWEk_FWTloss_timeseries.png';
saveas(gcf, savefile)

