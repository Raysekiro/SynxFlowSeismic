clc; clear; close all;
%% Output Path  & Time
t = datetime('now');
tName = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
tStart = tic;
FilePath = 'D:\1Reserch\Code\git_repo\SynxFlowSeismic\GISDATA\';

%% Input
DepthInputFile = [FilePath, 'depth'];
DepthOutputFile = [FilePath, 'depthpeak'];
DemInputFile = [FilePath, 'dem'];
DemOutputFile = [FilePath, 'dempeak'];
[DepthDATA, DepthHeader] = readAsciiGrid(DepthInputFile);
[DemDATA, DemHeader] = readAsciiGrid(DemInputFile);

%% Process 
x_area_min = 1;
x_area_max = DemHeader.ncols;
y_area_min = 1;
y_area_max = DemHeader.nrows;
width = DemHeader.cellsize;
quiverWidth = 5 * width;
Depth = 2;
% Depth -----------------------------------
row_range = 20:80;
col_range = 15:150;
% DepthDATA(row_range, col_range) = 2;
DepthDATA = Depth * ones(size(DepthDATA));
DepthDATA_M = DepthDATA;
% Dem -----------------------------------
PeakData = peaks(100);  % This generates a 100x100 matrix
% Create grids for interpolation
[xi, yi] = meshgrid(linspace(1, 100, 200), 1:100);
[xq, yq] = meshgrid(x_area_min:width:x_area_max, y_area_min:width:y_area_max);
vq = interp2(PeakData, xi, yi);
[Dxq,Dyq] = gradient(vq, width);
X = xq(:);  
Y = yq(:);  
Z = vq(:);
[xq_q,yq_q] = meshgrid(x_area_min:quiverWidth:x_area_max, y_area_min:quiverWidth:y_area_max); 
vq_q = griddata(X,Y,Z,xq_q,yq_q); 
[Dxq_q,Dyq_q] = gradient(vq_q,quiverWidth);
%% Plot
min_value_contour = min(vq(:));
max_value_contour = max(vq(:));
contour_levels = min_value_contour:5:max_value_contour;
x_ax_min2 = 0; % For adjusted XY
x_ax_max2 = 200;
y_ax_min2 = 0;
y_ax_max2 = 100;
data_ft = 0;
data_mt = 0;
AdjustX = 0;
AdjustY = 0;
f1name = [FilePath, tName '_DAFVM3Dsynxflow_GIS_', num2str(width) ];
title1 = ['H Map | Grid Width: ', num2str(width), 'm'];
% cbname = 'Normalized H';
cbname = 'H';
createMapH(f1name, title1, cbname, DepthDATA_M,...
    xq, yq, vq, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt, Z, AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2);
% save([f1name '.mat'], 'NormalizeH_Field');
%% Output
writeAsciiGrid(DepthDATA_M, DepthHeader, DepthOutputFile);
writeAsciiGrid(vq, DemHeader, DemOutputFile);
%% Dairy
tEnd = toc(tStart);  
formattedTime = formatTime(tEnd);
fprintf('Start time: %s\n', t);
fprintf('Elapsed time: %s\n', formattedTime);