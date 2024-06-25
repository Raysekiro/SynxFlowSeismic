function [xq, yq, vq, Dxq, Dyq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slopeLowF, DepthDATA_M, ...
    x_area_min, x_area_max, y_area_min, y_area_max, PeakScope, Depth, Z, ErosionDepth, AdjustX, AdjustY, AdjustZ] ...
    = initializeDEMandH(width, quiverWidth, gausscore, BATHYFile, ScarShapedata, OrigindataResolution, flag1, flag2)
    % Define constants and ranges
   
    if flag1 %Load peak data
        x_area_min = 0;
        x_area_max = 500;
        y_area_min = 0;
        y_area_max = 500;
        Depth = 8;
        PeakScope = min(x_area_max, y_area_max) *4 / 5; 
        PeakSize = 300; % Resolution
        PeakSizeScalar = 3;
        x = linspace(-4, 4, PeakSize);
        y = linspace(-4, 4, PeakSize);
        [X_0,Y_0] = meshgrid(x,y);
        % Generate peak data
        PeakData = PeakSizeScalar * peaks(X_0,Y_0);
        % Create grids for interpolation
        [xPeak, yPeak] = meshgrid(linspace((x_area_max - PeakScope) / 2, (x_area_max + PeakScope) / 2, PeakSize), ...
            linspace((y_area_max - PeakScope) / 2, (y_area_max + PeakScope) / 2, PeakSize));
        X = xPeak(:);
        Y = yPeak(:);
        Z = PeakData(:);
        AdjustX = []; % Return empty
        AdjustY = []; % Return empty
    else
        % Load DEM data
        [X, Y, Z, ErosionDepth, Z_Region, x_area_min, x_area_max, y_area_min, y_area_max, AdjustX, AdjustY, AdjustZ] ...
            = loadAndProcessTerrainData(gausscore,  BATHYFile, ScarShapedata, OrigindataResolution, flag2);
        PeakScope = 0; % Return empty
        DepthDATA_M = []; % Return empty
        Depth = 0; % Return empty
        
        % Define a structure array for sliding areas
        sliding_areas = struct(...
            'Tri', struct('x_min', x_area_min, 'x_max', x_area_max, 'y_min', y_area_min, 'y_max', y_area_max), ...
            'Zinnen', struct('x_min', 1000, 'x_max', 3500, 'y_min', 180, 'y_max', 1800), ...
            'BD31_1_1d', struct('x_min', 2800, 'x_max', 4000, 'y_min', 3000, 'y_max', 4200), ...
            'BD31_1_1d_detailed', struct('x_min', 3100, 'x_max', 3600, 'y_min', 3250, 'y_max', 3750), ...
            'SCSPRMC14', struct('x_min', 400, 'x_max', 2200, 'y_min', 2000, 'y_max', 4000), ...
            'SWIberiaNGAScar461', struct('x_min', 1700, 'x_max', 55700, 'y_min', 2500, 'y_max', 52500), ...
            'SWIberiaPeak1', struct('x_min', 400, 'x_max', 46800, 'y_min', 1500, 'y_max', 36500) ...
            );
        area_selected = sliding_areas.SWIberiaPeak1;
        
        x_area_min = area_selected.x_min;
        x_area_max = area_selected.x_max;
        y_area_min = area_selected.y_min;
        y_area_max = area_selected.y_max;

        

    end
    
    % Create query grids for interpolation and calculation
    [xq, yq] = meshgrid(x_area_min:width:x_area_max, y_area_min:width:y_area_max);
    vq = griddata(X, Y, Z, xq, yq);
    if flag1 
        ErosionDepth = zeros(size(vq));
        vq(isnan(vq)) = 0;
    else
        ErosionDepth = griddata(X, Y, ErosionDepth, xq, yq);   
    end

    % Generate depth data
    % DepthDATA_M = Depth - ((Depth * (1 - 1)) * (vq - min(vq(:))) / (max(vq(:)) - min(vq(:))));      
    % Compute gradients for flow direction arrows
    [Dxq, Dyq] = gradient(vq, width);
    
    % Create query grids for quiver plot
    [xq_q, yq_q] = meshgrid(x_area_min:quiverWidth:x_area_max, y_area_min:quiverWidth:y_area_max);
    vq_q = griddata(X, Y, Z, xq_q, yq_q);
    [Dxq_q, Dyq_q] = gradient(vq_q, quiverWidth);
    
    vq_smooth = imgaussfilt(vq, 50);

    slopeLowF = slope2(xq, yq, vq_smooth, 'degrees');
    DepthDATA = Depth * ones(size(vq));
    DepthDATA_M = DepthDATA;  % assuming you might modify or mask it later
end
