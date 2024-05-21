clc; clear; close all;
%% Output Path  & Time
t = datetime('now');
tName = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
tStart = tic;
OutPath = 'E:\Visualization\SBP_calculation\Synxflow\';
FilePath = 'D:\Docker\Work\Synxflowtest\Peaktest\landslide_case\output\';
BATHYFile = ' ';
diaryFileName = [OutPath 'SessionLogSynxFlow.txt'];
diary(diaryFileName);
%% input parameters
paramsFilePath = [FilePath 'Parameters.txt'];
params = readParamsToStruct(paramsFilePath);
DEMOriginFile = params.DEMName;
DepthOriginFile = params.DepthName;
start_time = params.startTime;% (s)
total_simulation_time = params.totalSimulationTime ;
output_interval = params.outputInterval;
cohesion = params.Cohesion;
mu = params.mu;
rho = params.rho;
rheology_Type = params.rheologyType;
curvature_On = params.curvatureOn;
% output h.asc
SynOutputFileTypeArry = {'h', 'hUx', 'hUy'};
% SynOutputFileTypeArry = {'h'};
%% Flags
width = 1;
quiverWidth = 2 * width;
gausscore = 5 * width;
flag1 = 1; %load from DEM
flag2 = 'SCS';
%% Process 
[xq, yq, vq, Dxq, Dyq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slope, DepthDATA_M, ...
    x_area_min, x_area_max, y_area_min, y_area_max, PeakScope, Depth, Z, AdjustX, AdjustY] ...
    = initializeDEMandH(width, quiverWidth, gausscore, BATHYFile , flag1, flag2);
min_value_contour = min(vq(:));
max_value_contour = max(vq(:));
x_ax_min2 = (x_area_max - PeakScope) / 2 - 10;
x_ax_max2 = (x_area_max + PeakScope) / 2 + 10;
y_ax_min2 = (y_area_max - PeakScope) / 2 - 10;
y_ax_max2 = (y_area_max + PeakScope) / 2 + 10;
data_ft = 0;
data_mt = 0;
AdjustX = 0;
AdjustY = 0;
vq_t = vq + Depth;
contour_interval = (max(vq_t(:)) - min(vq_t(:))) / 29;
contour_levels =  min(vq_t(:)):contour_interval:max(vq_t(:));
SynOutputFileH = extractAsciiGridData(FilePath, 'h_%g.asc', start_time, total_simulation_time, output_interval);
%% main loop
for i_type = 1:length(SynOutputFileTypeArry)
    SynOutputFileType = SynOutputFileTypeArry{i_type};
    SynOutputFile = extractAsciiGridData(FilePath, [SynOutputFileType, '_%g.asc'], start_time, total_simulation_time, output_interval);
    [AdjustclimMin, AdjustclimMax, cmapType, Depth] = setDynamicColormapWithType(SynOutputFileType, SynOutputFile, xq, yq, vq, Depth);
    fname = [OutPath, tName '_DAFVM3Dsynxflow_GIS_' SynOutputFileType];
    VideoName = [fname '.mp4'];
    v = VideoWriter(VideoName, 'MPEG-4');
    open(v);
    n = length(SynOutputFile);
    % precomputedFrames(n) = struct('cdata', [], 'colormap', []); % Preallocate the array with empty structures
    h0 = waitbar(0,'Please wait, Video is ready soon...');
    for i = 1 : n
        waitbar(i/n,h0,['Video(' SynOutputFileType ') Progress: ' num2str((i / n *100),'%.1f') '%']);
        ColorData = SynOutputFile(i).data / Depth;
        vq_t = vq + SynOutputFileH(i).data;
        f1name = [OutPath, tName '_DAFVM3Dsynxflow_GIS_' SynOutputFileType '_t-',num2str((i * output_interval),'%.2f'),'s'];
        title1 = [ SynOutputFileType ' Map | \mu : ', ...
            num2str(mu), ' | cohesion: ', num2str(cohesion), 'kPa | \rho: ', num2str(rho),...
            'kg/m^3 | Rheology Type: ', num2str(rheology_Type), ' | Curvature On'...
            ' | t=',num2str((i * output_interval),'%.2f'),'s'];
        cbname =['Normalized ' SynOutputFileType];
        % NormalizeH -------------------------------------------------------
        frameData = createMapVideoH(v, f1name, title1, cbname, ColorData, cmapType, ...
            xq, yq, vq_t, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt,  ...
            Z, AdjustclimMin, AdjustclimMax,  AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2, flag2);
        % Save the final field
        if i == n
            createMapH(f1name, title1, cbname, ColorData, cmapType,...
                xq, yq, vq_t, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt,  ...
                Z, AdjustclimMin, AdjustclimMax, AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2,flag2)
        end
        % precomputedFrames(i) = frameData;
    end
    close(h0);
    % h = waitbar(0,'Please wait, Video is ready soon...');
    % for i = 1:n
    %     waitbar(i/n,h,sprintf('Progress: %d%%',int32(100*i/n)));
    %     writeVideo(v, precomputedFrames(i)); % Write each frame to the video file
    % end
    close(v);
    % close(h);
    save([fname '.mat'], 'SynOutputFile');
    %% Dairy
    fprintf('Video(%s) is ready! \n', SynOutputFileType);
    variableNames = {'fname','rho','mu','cohesion','rheology_Type','curvature_On','Depth','width','quiverWidth',...
        'start_time','total_simulation_time','output_interval','output_interval','x_area_max','y_area_max','DEMOriginFile','DepthOriginFile'};
    for i = 1:length(variableNames)
        varName = variableNames{i};
        if exist(varName, 'var')
            varValue = eval(varName);
            if isvector(varValue) && length(size(varValue)) == 2
                fprintf('%s = %s\n', varName, mat2str(varValue));
            end
        else
            fprintf('Variable "%s" does not exist or is not a single array.\n', varName);
        end
    end
    fprintf('%s\n', repmat('-', 2, 50));
end
tEnd = toc(tStart);
formattedTime = formatTime(tEnd);
fprintf('Start time: %s\n', t);
fprintf('Elapsed time: %s\n', formattedTime);
diary off;