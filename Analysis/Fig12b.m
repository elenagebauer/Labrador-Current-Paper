% Figure 12b

load('../Data/wind.mat');
load('../Data/LAB60_SAL_data.mat')
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



Mx_sec=struct();
My_sec=struct();
M_sec=struct();
M_probe_sec=struct();
omega=7.2921*10^(-5);
 for s=1:size(sec_names,1);
     name=char(sec_names(s,:));
     Mx_sec.(name)=struct();
     My_sec.(name)=struct();
     M_probe_sec.(name)=struct();
 end
for m=2007:2018;
    year_a=char(years_a(m-2006,:))
    for s=1:size(sec_names,1);
        name=char(sec_names(s,:));
        for i=1:size(lat_sec.(name),2);
             f=2*omega*sind(lat_sec.(name)(i));
             Mx_sec.(name).(year_a)(:,i)=(1/f)*tauy_P_mean_sec.(name).(year_a)(:,i)*1/1026.75;
             My_sec.(name).(year_a)(:,i)=(-1/f)*taux_P_mean_sec.(name).(year_a)(:,i)*1/1026.75;
        end
         M_sec.(name).(year_a)=Mx_sec.(name).(year_a)+My_sec.(name).(year_a);
    end
end



for s=1:size(cross_names,1);
    cross_name=char(cross_names(s,:));
    S_Ekmean.(cross_name)=struct();
    for m=2007:2018;
        year_a=char(years_a(m-2006,:));
        for n=1:length(month_vec);
            month=char(month_vec(n,:));
            S33=S_monthly.(cross_name).(year_a).(month);
            if n==1;
                S_Ekmean.(cross_name).(year_a)=nan(12,1);
            end
            S33(S_monthly.(cross_name).(year_a).(month)<21.0)=nan;
            S33(S_monthly.(cross_name).(year_a).(month)>=33.3)=nan;
            S_Ekmean.(cross_name).(year_a)(n)=nanmean(S33(:));
        end
    end
end



 S_ref=34.8;
 for s=1:size(sec_names,1);
    cross_name=char(sec_names(s,:));
     name1=char(cross_names(s,:));
     name2=char(cross_names(s+1,:));
     M_TDiff_EK333_sec.(cross_name)=struct();
     M_TDiff_EK_FW333_sec_spatav.(cross_name)=struct();
     M_TDiff_EK_FW333_sec.(cross_name)=struct();
     for m=2007:2018;
         year_a=char(years_a(m-2006,:));
         for n=1:12;
             S1=S_Ekmean.(name1).(year_a)(n);
             S2=S_Ekmean.(name2).(year_a)(n);
             S=nanmean([S1,S2]);
             sa=(S_ref-S)/S_ref;
             M_TDiff_EK333_sec.(cross_name).(year_a)(n)=nanmean(M_sec.(cross_name).(year_a)(n,:))*distance.(cross_name)*1000;
             M_TDiff_EK_FW333_sec.(cross_name).(year_a)(n)=nanmean(M_sec.(cross_name).(year_a)(n,:))*sa*distance.(cross_name)*1000;
         end
     end
 end
save('../Data/M_TDiff_EK_FW333_sec.mat', 'M_TDiff_EK_FW333_sec')
save('../Data/M_sec.mat', 'M_sec')
figure;
ax=axes;
months=1:12;
plot(period_m,zeros(length(period_m),1), 'Color',[.7 .7 .7],'LineWidth',1, 'HandleVisibility', 'off');
hold on;
for s=1:size(sec_names,1)
    cross_name=char(cross_names(s,:));
    name1=char(sec_names(s,:));
    diff_name=char(diff_names(s,:));
    month_means_EK=zeros(12,1);
    month_means_FW=zeros(12,1);
    for n=1:12
        month_sum_EK=zeros(12,1);
        month_sum_FW=zeros(12,1);
        for m=2007:2018;
            year_a=char(years_a(m-2006,:));
            month_sum_EK(m-2006)= M_TDiff_EK_FW333_sec.(name1).(year_a)(n);
        end
        month_means_EK(n)=nanmean(month_sum_EK);
    end


    plot(period_m,month_means_EK/(10^3), 'LineWidth',2.5,'Marker','.', 'MarkerSize',18);
    hold on;
  
  
end
hold off;
ylabel('Ekman FWT [mSv]', 'FontSize', 12)
xlim([1,12]);
ldg=legend('BI-MB','MB-SI','SI-WB','WB-BB','BB-FC','FC-SEGB',  'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff', 'FontSize',16);
xlim([1,12]);
ax.XTick=[];
ax.XTickLabel=[];
ax.XTick=months;
ax.XTickLabel=cellstr(datestr(datenum(2000, months, 1), 'mmm'));
set(gca,'fontsize', 16);
width=10;
height=6;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height])
saveas(gcf,'/mnt/storage6/elena/LAB60/Plots/Ekman_seasonalcycle.png');

