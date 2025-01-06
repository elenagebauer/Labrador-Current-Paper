% Figure 3: Temperature-Salinity Plots
load('../Data/TSdiag_LAB60_SEGB.mat');
load('../Data/TSdiag_AZMP_SEGB.mat');
load('../Data/TSdiag_LAB60_FC.mat');
load('../Data/TSdiag_AZMP_FC.mat');
load('../Data/TSdiag_LAB60_BB.mat');
load('../Data/TSdiag_AZMP_BB.mat');
load('../Data/TSdiag_LAB60_WB.mat');
load('../Data/TSdiag_AZMP_WB.mat');
load('../Data/TSdiag_LAB60_MB.mat');
load('../Data/TSdiag_AZMP_MB.mat');
load('../Data/TSdiag_LAB60_SI.mat');
load('../Data/TSdiag_AZMP_SI.mat');
load('../Data/TSdiag_LAB60_BI.mat');
load('../Data/TSdiag_AZMP_BI.mat');

figure;
sections = {Sg_BI_azmp, Tg_BI_azmp, sigma_BI_azmp, S_BI_diag, T_BI_diag, z_bi, lat_BI, Smean_BI_azmp, Tmean_BI_azmp;
            Sg_MB_azmp, Tg_MB_azmp, sigma_MB_azmp, S_MB_diag, T_MB_diag, z_mb, lat_MB, Smean_MB_azmp, Tmean_MB_azmp;
            Sg_SI_azmp, Tg_SI_azmp, sigma_SI_azmp, S_SI_diag, T_SI_diag, z_ri*(-1), lat_SI, Smean_SI_azmp, Tmean_SI_azmp;
            Sg_WB_azmp, Tg_WB_azmp, sigma_WB_azmp, S_WB_diag, T_WB_diag, z_wb, lat_WB, Smean_WB_azmp, Tmean_WB_azmp;
            Sg_BB_azmp, Tg_BB_azmp, sigma_BB_azmp, S_BB_diag, T_BB_diag, z_bb, lat_BB, Smean_BB_azmp, Tmean_BB_azmp;
            Sg_FC_azmp, Tg_FC_azmp, sigma_FC_azmp, S_FC_diag, T_FC_diag, z_fc, lat_FC, Smean_FC_azmp, Tmean_FC_azmp;
            Sg_SEGB_azmp, Tg_SEGB_azmp, sigma_SEGB_azmp, S_SEGB_diag, T_SEGB_diag, z_segb, lat_SEGB, Smean_SEGB_azmp, Tmean_SEGB_azmp};

colors = {'copper', 'summer'};
vertical_gap = 0.08;
horizontal_gap = 0.05;
horizontal_margin = [0.05, 0.03];
vertical_margin = [0.02, 0.07];
subplot_width = (1 - horizontal_margin(1)- horizontal_margin(2)-2*horizontal_gap)/3;
subplot_height = (1 - vertical_margin(1)-vertical_margin(2) - 2 * vertical_gap) / 3;

for i = 1:7;
    row=ceil(i / 3)
    col = mod(i-1, 3) + 1;
    positions = [
        horizontal_margin(1) + (col - 1) * (subplot_width + horizontal_gap),...
        vertical_margin(2) + (3 - row) * (subplot_height + vertical_gap),...
        subplot_width,...
        subplot_height
    ];
    ax1 = subplot(3, 3, i);
    set(ax1, 'Position', positions)
    section = sections(i, :);
    minT=nanmin(nanmin(section{5}));
    maxT=nanmax(nanmax(section{5}));
    minS=nanmin(nanmin(section{4}));
    maxS=nanmax(nanmax(section{4}));
    tL=linspace(minT-20, maxT+20);
    sL=linspace(minS-20, maxS+20);
    [Tg,Sg]=meshgrid(tL,sL);
    sigma=gsw_sigma0(Sg,Tg);   
    c=20:1:35
    [cs, h] = contour(Sg, Tg, sigma,c, 'Color', [17 17 17]/255, 'LineWidth', 0.75, 'Displayname', 'Isopycnals', 'Parent', ax1);
    hold on;
    clabel(cs,h,  'FontSize', 14, 'LabelSpacing',200);
    k = gca;

    X_LAB60 = section{4};
    Y_LAB60 = section{5};
    Z_LAB60 = section{6};
    for j=1:size(X_LAB60,2);
    cw(j)=scatter(X_LAB60(1:46,j), Y_LAB60(1:46,j), 15, Z_LAB60(1:46), 'filled', 'Marker', 'o', 'MarkerFaceAlpha', 0.75, 'MarkerEdgeAlpha', 0.75, 'DisplayName', 'LAB60', 'Parent', ax1);
    hold on;
    end
    x=scatter(NaN, NaN, 35, [0 .5 0], 'filled', 'Marker', 'o', 'MarkerFaceAlpha', 0.75, 'MarkerEdgeAlpha', 0.75, 'DisplayName', 'AZMP','Parent',ax1);

    set(gca, 'YTick');
    set(gca, 'YTick');
    set(gca,'fontsize', 22);

    X_AZMP = section{8};
    Y_AZMP = section{9};
    Z_AZMP = depth;
    ax2 = axes('Position', ax1.Position, 'Color', 'none');
    linkaxes([ax1, ax2]);
    for m=1:length(section{7});
    qw(m)=scatter(X_AZMP(m,1:199), Y_AZMP(m,1:199), 15,double(depth(1:199)), 'filled', 'Marker', 'o', 'MarkerFaceAlpha', 0.75, 'MarkerEdgeAlpha', 0.75, 'DisplayName', 'AZMP', 'Parent', ax2);
    hold on;
    end
    ax2.Visible = 'off';
    ax2.XTick = []; ax2.YTick = [];
   colormap(ax1, colors{1});
    colormap(ax2, colors{2});


    ax1.XLabel.String = 'Salinity';
    ax1.XLabel.FontSize = 20;
    ax1.YLabel.String = 'Pot. Temperature [°C]';
    ax1.YLabel.FontSize = 20;
    set(gca,'fontsize', 20);
    hold off;
    lgd=legend([cw(1),x]);
    lgd.Units = 'normalized'; 
    lgd.Position = [ax1.Position(1)+subplot_width-0.0455, ax1.Position(2)+0.0037, 0.01, 0.05]
    
    set(lgd, 'FontSize',12);
    if i==1;
    xlim(ax1,[28.5, 35.5]);
    ylim(ax1,[-2,7]);
    xlim(ax2,[28.5, 35.5]);
    ylim(ax2,[-2,7]);
    text(28.5, -1.2, 'BI', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==2;
    xlim(ax1,[29, 35.5]);
    ylim(ax1,[-2,7]);
    xlim(ax2,[29, 35.5]);
    ylim(ax2,[-2,7]);
    text(29, -1.2, 'MB', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==3;
    xlim(ax1,[29, 35]);
    ylim(ax1,[-2,7]);
    xlim(ax2,[29, 35]);
    ylim(ax2,[-2,7]);
    text(29, -1.16, 'SI', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==4;
    xlim(ax1,[30, 35.5]);
    ylim(ax1,[-2,12]);
    xlim(ax2,[30, 35.5]);
    ylim(ax2,[-2,12]);
    text(30, -0.73,'WB', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==5;
    xlim(ax1,[31.5, 35]);
    ylim(ax1,[-2,7]);
    xlim(ax2,[31.5, 35]);
    ylim(ax2,[-2,7]);
    text(31.5, -1.23, 'BB', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==6;
    xlim(ax1,[31.5, 35.5]);
    ylim(ax1,[-2,12]);
    xlim(ax2,[31.5, 35.5]);
    ylim(ax2,[-2,12]);
    text(31.5, -0.67, 'FC', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    elseif i==7;
    xlim(ax1,[31.5, 36.5]);
    ylim(ax1,[-2,16.5]);
    xlim(ax2,[31.5, 36.5]);
    ylim(ax2,[-2,16.5]);
    text(31.5, -0.37, 'SEGB', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
end
set(gca,'fontsize', 20);
    if i>6
        colormap(ax1, colors{1});
        cb1 = colorbar(ax1);
        cb1.Units = 'normalized';
        cb1.Position = [ax2.Position(1) + ax2.Position(3) + 0.038, ax2.Position(2), 0.015, ax2.Position(4)];
        cb1.Label.String = 'Depth [m]';
        cb1.FontSize=16;
	cb2=colorbar(ax2, 'Position', [ax2.Position(1) + ax2.Position(3) + 0.018, ax2.Position(2), 0.015, ax2.Position(4)]);
	cb2.Ticks=[];
end
end
width = 20;
height = 13;
set(gca,'fontsize', 20);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 width height]);
saveas(gcf, '/mnt/storage6/elena/LAB60/Plots/TS_diag.png');
