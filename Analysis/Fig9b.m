% Figure 9

load('../Data/velocity_data_reduced2.mat')
load('../Data/index_sections.mat')
load('../Data/V_monthly.mat')
cross_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
years_a={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_m=[1:12];
month_vec = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
sec_names={'AZMP_crossBI_MB';'AZMP_crossMB_SI';'AZMP_crossSI_WB';'AZMP_crossWB_BB';'AZMP_crossBB_FC';'AZMP_crossFC_SEGB'};

for s=1:size(cross_names,1);
     name=char(cross_names(s,:));
     for n=1:12;
         month=char(month_vec(n,:));
         if n==1;
             Vol365=nan(12, size(Vol_month_mean.(name).(month),1),size(Vol_month_mean.(name).(month),2));
             V365=nan(12, size(V_month_mean.(name).(month),1),size(V_month_mean.(name).(month),2));
         end
         Vol365(n,:,:)=Vol_month_mean.(name).(month);
         V365(n,:,:)=V_month_mean.(name).(month);
     end
     Vol_allmonths.(name)=nanmean(Vol365,1);
     V_allmonths.(name)=nanmean(V365,1);
 end
for s=1:size(cross_names,1);
     name=char(cross_names(s,:));
     V_yearly_mean.(name)=struct();
    index=eval(strcat('index_',name));
     for m=2007:2018;
         year_a=char(years_a(m-2006,:));
         if m==2007;
             
             vx=nan(12,length(V_monthly.(name).(year_a).(month)(:,1)),length(V_monthly.(name).(year_a).(month)(1,:))); 
         end
         for n=1:12;
             month=char(month_vec(n,:));
             if n==1;
                 V_mean=nan(12,length(V_monthly.(name).(year_a).(month)(:,1)),length(V_monthly.(name).(year_a).(month)(1,:)));
             end
            V_mean(n,:,:)=V_monthly.(name).(year_a).(month);
         end
         V_mean(V_mean==0)=nan;
         v_gem=nanmean(V_mean,1);
         v_gem=squeeze(v_gem);
         for i=1:length(v_gem(1,:));
             if index.vSign(i)==0;
                v_gem(:,i)=nan;
             end
        end
         V_yearly_mean.(name).(year_a)=v_gem;
         vx(m-2006,:,:)=v_gem;          
     end
     v_end=nanmean(vx,1);
     V_totalmean.(name)=squeeze(v_end);
end        


figure;
vertical_gap = 0.042;
horizontal_gap = 0.012;
horizontal_margin = [0.11, 0.02];
vertical_margin = [0.02, 0.12];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-1*horizontal_gap)/2;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 5 * vertical_gap) / 6;
x_plot=eval(strcat('x1_',name));
z_plot=eval(strcat('z_',name));
for s=3;
    name=char(cross_names(s,:));

    figure;
    x_plot=eval(strcat('x1_',name));
    z_plot=eval(strcat('z_',name));
    z_plot=z_plot;
    for n=1:12;
	row=ceil(n / 2);
	col = mod(n-1, 2) + 1;
	positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (6 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
        ]; 
        
        year_a=char(years_a(n,:));
        if n==1;
            x_plot=x_plot(~all(isnan(V_totalmean.(name))));
        end
        V_plot = V_yearly_mean.(name).(year_a)(:,~all(isnan(V_yearly_mean.(name).(year_a))));
%       
        V_totalmean_plot=V_totalmean.(name)(:,~all(isnan(V_yearly_mean.(name).(year_a))));
        [X_plotten,Y_plotten]=meshgrid(x_plot,z_plot(1:48));
        
        ax1=subplot(6,2,n)
        set(ax1, 'Position',positions);
        [c2,t2]=contourf(X_plotten,Y_plotten,(V_plot(1:48,:)-V_totalmean_plot(1:48,:)),20);
        set(t2,'LineColor','none');
        ax1.YTick = []; 
	if col==1;
        for k = -1000:200:0;
	ax1.YTick = [ax1.YTick, k];
	end
	ax1.YTickLabel = arrayfun(@(x) num2str(-x), ax1.YTick, 'UniformOutput', false);
        end

	k=gca;
        colormap(k,cmocean('balance'));
        cl=[-0.1,0.1];
        set(k, 'CLim', cl, 'CLimMode', 'manual')
    
        if n==11;
		cb1=colorbar();
		cb1.Orientation='horizontal';
		cb1.Units='normalized';
		cb1.Position = [ax1.Position(1)+0.5*ax1.Position(3), ax1.Position(2)-0.065,ax1.Position(3), 0.02];
		cb1.Label.String='Velocity Anomaly [m/s]';
		cb1.FontSize=12;
	end
	if col==1
        ylabel('Depth [m]', 'FontSize', 12);
        end
	xlabel('Distance [km]', 'FontSize', 12);
	x_pos = X_plotten(1);
	y_pos = -960;
	text(x_pos, y_pos,strcat(name,'-',year_a(2:end)), 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
     set(gca,'fontsize', 16);
     end  
     set(gca,'fontsize', 16);
     width=11;
     height=17;
     set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
     saveas(gcf, strcat('/mnt/storage6/elena/LAB60/Plots/LAB60_V_yearly_anomaly',name,'.png'));
 end   
