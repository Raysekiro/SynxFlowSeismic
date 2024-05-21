clc; clear; close all;
%% Output Path  & Time
t = datetime('now');
tName = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
tStart = tic;
FilePath = 'D:\1Reserch\Code\git_repo\SynxFlowSeismic\GISDATA\';
BATHYFile = ' ';
%% Input
DepthInputFile = [FilePath, 'depth'];
DepthOutputFile = [FilePath, tName 'depthpeak'];
DemInputFile = [FilePath, 'dem'];
DemOutputFile = [FilePath, tName 'dempeak'];
[DepthDATA, DepthHeader] = readAsciiGrid(DepthInputFile);
[DemDATA, DemHeader] = readAsciiGrid(DemInputFile);
width = 1;
quiverWidth = 2 * width;
gausscore = 5 * width;
flag1 = 1; %load from DEM
flag2 = 'SCS';
%% Process 
[xq, yq, vq, Dxq, Dyq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slope, DepthDATA_M, ...
    x_area_min, x_area_max, y_area_min, y_area_max, PeakScope, Depth, Z, AdjustX, AdjustY] ...
    = initializeDEMandH(width, quiverWidth, gausscore, BATHYFile , flag1, flag2);

%% Plot
data_ft = 0;
data_mt = 0;
% slope_1 = acosd(1 ./ sqrt(Dxq.^2 + Dyq.^2 + 1));
slope = slope2(xq, yq, vq, 'degrees');
% Evaluation map
f1 = figure('units','normalized','outerposition',[0 0 1 1]);
surf(xq, yq, vq,'FaceColor', 'interp', 'EdgeColor', 'none'); hold on;
% colormap("parula");
colormap(flipud(slanCM('RdBu')));
setPivot(gca, 0);
colorbar;
% contour_levels = min(vq(:)):2:max(vq(:));
% contour3(xq,yq,vq,contour_levels, 'LineColor','k', 'LineWidth',0.3, 'EdgeAlpha',0.8);
daspect([1 1 1]);
view([0 0 1]);
title(['Evaluation Map']);
saveas(f1, [FilePath, tName '_DAFVM3Dsynxflow_Evaluation_Map.fig']);
exportgraphics(f1, [FilePath, tName '_DAFVM3Dsynxflow_Evaluation_Map.png'], 'Resolution', 800);

% Slope map
f2 = figure('units','normalized','outerposition',[0 0 1 1]);
surf(xq, yq, vq,'CData', slope,'FaceColor', 'interp', 'EdgeColor', 'none');
colormap("parula");
colorbar;
daspect([1 1 1]);
view([0 0 1]);
title(['Slope Map']);
saveas(f2, [FilePath, tName '__DAFVM3Dsynxflow_Slope_Map.fig']);
exportgraphics(f2, [FilePath, tName '__DAFVM3Dsynxflow_Slope_Map.png'], 'Resolution', 800);
close(f1);
close(f2);

%% Output
DemHeader.ncols = size(xq, 2); 
DemHeader.nrows = size(xq, 1); 
DemHeader.cellsize = width;
DepthHeader.ncols = size(xq, 2); 
DepthHeader.nrows = size(xq, 1); 
DepthHeader.cellsize = width;
writeAsciiGrid(DepthDATA_M, DepthHeader, DepthOutputFile);
writeAsciiGrid(vq, DemHeader, DemOutputFile);
%% Dairy
tEnd = toc(tStart);  
formattedTime = formatTime(tEnd);
fprintf('Start time: %s\n', t);
fprintf('Elapsed time: %s\n', formattedTime);