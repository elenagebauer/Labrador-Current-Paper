% Figure 7: Isohaline Plot

S_data=load('../Data/LAB60_SAL_data.mat');
section_names={'BI';'MB';'SI';'WB';'BB';'FC';'SEGB'};
years={'y2007';'y2008';'y2009';'y2010';'y2011';'y2012';'y2013';'y2014';'y2015';'y2016';'y2017';'y2018'};
period_y=[2007:2018];
period_m=[1:12];
months=['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

% calculation
S_years_mean=struct();
for s=1:size(section_names,1);
name=char(section_names(s,:));
name;
S_sec=S_data.S_monthly.(name);
for y=1:12;
year=char(years(y,:));
year;
S_years=S_sec.(year);
if y==1;
S_years_mean.(name)=zeros(12,length(S_years.(char(months(1,:)))(:,1)), length(S_years.(char(months(1,:)))(1,:)));
end
S_each_year_mean=zeros(12,length(S_years.(char(months(1,:)))(:,1)), length(S_years.(char(months(1,:)))(1,:)));
for m=1:12;
month=char(months(m,:));
month;
S_each_year_mean(m,:,:)=S_years.(month);
end
S_years_mean.(name)(y,:,:)=mean(S_each_year_mean,1,'omitnan');
end
end


dist_data=load('../Data/Section_distances.mat');
colors={'r';'r';'r';'magenta';'magenta';'magenta';'blue';'blue';'blue';'k';'k';'k'} ;
vertical_gap = 0.08; 
horizontal_gap = 0.05;
horizontal_margin = [0.05, 0.03];
vertical_margin = [0.02, 0.07]; 
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-2*horizontal_gap)/3;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 2 * vertical_gap) / 3;

figure;
for  s=1:9;
row=ceil(s / 3)
col = mod(s-1, 3) + 1;
positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (3 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
if s<8;
name=char(section_names(s,:));
h = subplot(3,3,s);
set(h, 'Position', positions)
line_styles ={'-', '--', '-.'};
legend_handles=[];
legend_entries={};
X = eval(strcat('dist_data.X_', name));
Y = eval(strcat('dist_data.Y_', name));
for y = 1:12
    color = colors{y};
    year = 2006 + y;
    legend_entries{y} = num2str(year);
    if y ==1;
        [c2, t2] = contourf(X, Y, squeeze(S_years_mean.(name)(1, 1:48, :)));
        set(t2, 'LineColor', 'none');
        k = gca;
        colormap(k, [0.9 0.9 0.9]);
        hold on;
    end
    line_style = line_styles{mod(y-1, length(line_styles)) + 1};
    [g, h] = contour(X, Y, squeeze(S_years_mean.(name)(y, 1:48, :)), [33.3 33.3], 'LineWidth', 2, 'EdgeColor', color,'LineStyle', line_style, 'ShowText', 'off');
    if ~isempty(h);
	legend_handles(end+1)=h;
	legend_entries{end+1}=num2str(year);
end 
hold on;
end
ylim([-300, 0])
xlabel('Distance [km]', 'FontSize', 13);
ylabel('Depth [m]', 'FontSize', 13);
yticks=-300:100:0;
set(gca, 'YTick',yticks);
set(gca,'YTickLabel', (abs(yticks)));
set(gca,'fontsize', 16) 
x_pos = X(1); 
y_pos = -272;   
text(x_pos, y_pos, [ name], 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
if s==1;
if ~isempty(legend_handles)
      lgd1 = legend(legend_handles(1:6), legend_entries(1:6), 'FontSize',10);
            lgd1.Units = 'normalized'; 
            lgd1.Position = [0.35, 0.17, 0.15, 0.15];
	    set(lgd1, 'Box', 'off'); 
end
end
if s==7;
if ~isempty(legend_handles)
lgd2 = legend(legend_handles(7:12), legend_entries(7:12), 'FontSize',10);
            lgd2.Units = 'normalized';
            lgd2.Position = [0.428, 0.17, 0.15, 0.15];
            set(lgd2, 'Box', 'off'); 
end
pos1 = [0.34, 0.17, 0.15, 0.15];
pos2 = [0.418, 0.17, 0.15, 0.15];
ax = gca;
ax_pos = get(ax, 'Position');
x = min(pos1(1), pos2(1));
y = min(pos1(2), pos2(2));
breite = max(pos1(1) + pos1(3), pos2(1) + pos2(3)) - x;
hoehe = max(pos1(2)+pos1(4) , pos2(2)+pos2(4)) - y;
hold on;
annotation('rectangle',[x+0.033,y,breite-0.05, hoehe],'EdgeColor', 'k','LineWidth',0.3, 'FaceColor','none')
end
else
h = subplot(3, 3, s);
set(h, 'Position', positions);
axis off; 
end
end
figure_width = 22; 
figure_height = 12;
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 figure_width figure_height]);
set(gca, 'ActivePositionProperty', 'OuterPosition')
saveas(gcf, '/mnt/storage6/elena/LAB60/Plots/LAB60_isohaline_Op1.png');
