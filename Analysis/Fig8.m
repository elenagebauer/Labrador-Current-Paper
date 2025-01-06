% Figure 8
load('../Data/velocity_data.mat')

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


l=0;
figure;
vertical_gap = 0.06;
horizontal_gap = 0.035;
horizontal_margin =[0.09, 0.03];
vertical_margin = [0.02, 0.07];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-1*horizontal_gap)/2;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 3 * vertical_gap) / 4;

for i=1:size(cross_names,1);
    row=ceil(i / 2)
    col = mod(i-1, 2) + 1
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (4 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    name=char(cross_names(i,:));
    V_allmonths.(name)=squeeze(V_allmonths.(name));
    x_plot=eval(strcat('x1_',name));
    z_plot=eval(strcat('z_',name));
    x_plot=x_plot(~all(isnan(V_allmonths.(name))));
    V_plot = V_month_mean.(name).(month)(:,~all(isnan(V_allmonths.(name))));
    V_allmonths_plot=V_allmonths.(name)(:,~all(isnan(V_allmonths.(name))));
    [X_plotten,Y_plotten]=meshgrid(x_plot,(z_plot(1:48)));
    ax1 = subplot(4,2, i);
    set(ax1, 'Position', positions)
    [c2,t2]=contourf(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),20, 'Parent',ax1);
    set(t2,'LineColor','none');
    hold on;

    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[-0.2 -0.2],'LineWidth',1.5, 'EdgeColor', 'black','Parent', ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[-0.1 -0.1],'LineWidth',1.5, 'EdgeColor', 'black', 'Parent',ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[0 0],'LineWidth', 1.5, 'EdgeColor', 'black', 'Parent',ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[0.1 0.1],'LineWidth',1.5, 'EdgeColor', 'black', 'Parent',ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[0.2 0.2],'LineWidth',1.5, 'EdgeColor', 'black', 'Parent',ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[0.3 0.3],'LineWidth',1.5, 'EdgeColor', 'black', 'Parent',ax1);
    [e,f]=contour(X_plotten,Y_plotten,V_allmonths_plot(1:48,:),[0.4 0.4],'LineWidth',1.5, 'EdgeColor', 'black','Parent', ax1);

    x_pos = X_plotten(1);
    y_pos = -1030;
    text(x_pos, y_pos, [ name], 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

    ax1.YTick = [];  
    if col==1;
    for k = -1000:200:0;  
        ax1.YTick = [ax1.YTick, k];
    end
    ax1.YTickLabel = arrayfun(@(x) num2str(-x), ax1.YTick, 'UniformOutput', false);
    end
    hold off
    k=gca;
    set(gca,'fontsize', 18);
    colormap(k,cmocean('tempo'))
    cl=[-0.1 0.3];
    set(k, 'CLim', cl, 'CLimMode', 'manual')

    if i>6   
        cb1 = colorbar(ax1);
        cb1.Units = 'normalized';
        cb1.Position = [ax1.Position(1) + ax1.Position(3) + 0.04, ax1.Position(2), 0.022, ax1.Position(4)];
        cb1.Label.String = 'Velocity [m/s]';
        cb1.FontSize=15;
end
if col==1;
    ylabel('Depth [m]', 'FontSize', 12);
end    
xlabel('Distance [km]', 'FontSize', 12);
set(gca,'fontsize', 16);
end
width=11;
height=13;
set(gcf,'PaperUnits', 'inches','PaperPosition',[0 0 width height]);
saveas(gcf,'/mnt/storage6/elena/LAB60/Plots/LAB60_V_monthlyav0718.png');


