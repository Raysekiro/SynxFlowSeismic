clc; clear; close all;
%% Output Path  & Time
t = datetime('now');
tName = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
tStart = tic;
FilePath = 'D:\1Reserch\Code\git_repo\SynxFlowSeismic\GISDATA\';

%% Input
DepthInputFile = [FilePath, 'depth'];
DepthOutputFile = [FilePath, tName 'depthpeak'];
DemInputFile = [FilePath, 'dem'];
DemOutputFile = [FilePath, tName 'dempeak'];
[DepthDATA, DepthHeader] = readAsciiGrid(DepthInputFile);
[DemDATA, DemHeader] = readAsciiGrid(DemInputFile);

%% Process 
[xq, yq, vq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slope, DepthDATA_M, ...
    x_area_max, y_area_max, PeakScope, width, quiverWidth, Depth, Z] = initializeDEMandH();

%% Plot
min_value_contour = min(vq(:));
max_value_contour = max(vq(:));
contour_levels = min_value_contour:0.5:max_value_contour;
x_ax_min2 = (x_area_max - PeakScope) / 2 - 10; 
x_ax_max2 = (x_area_max + PeakScope) / 2 + 10;
y_ax_min2 = (y_area_max - PeakScope) / 2 - 10;
y_ax_max2 = (y_area_max + PeakScope) / 2 + 10;
data_ft = 0;
data_mt = 0;
AdjustX = 0;
AdjustY = 3;
f1name = [FilePath, tName '_DAFVM3Dsynxflow_GIS_H'];
title1 = ['H Map | Grid Width: ', num2str(width), 'm'];
% cbname = 'Normalized H';
cbname = 'H';
createMapH(f1name, title1, cbname, DepthDATA_M,...
    xq, yq, vq, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt, Z, AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2);
createMapSuW(f1name, title1, cbname, slope,...
    xq, yq, vq, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt, Z, AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2);
% save([f1name '.mat'], 'NormalizeH_Field');
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