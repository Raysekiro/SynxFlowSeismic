function [xq, yq, vq, Dxq, Dyq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slope, DepthDATA_M, ...
    x_area_min, x_area_max, y_area_min, y_area_max, PeakScope, Depth, Z, AdjustX, AdjustY] = initializeDEMandH(width, quiverWidth, gausscore, BATHYFile , flag1, flag2)
    % Define constants and ranges
   
    if flag1 == 1 %Load peak data
        x_area_min = 0;
        x_area_max = 500;
        y_area_min = 0;
        y_area_max = 500;
        Depth = 2;
        PeakScope = min(x_area_max, y_area_max) / 2; 
        PeakSize = 200; % Resolution
        PeakSizeScalar = 0.5;
        x = linspace(-4, 4, PeakSize);
        y = linspace(-4, 4, PeakSize);
        [X,Y] = meshgrid(x,y);
        % Generate peak data
        PeakData = PeakSizeScalar * peaks(X,Y);

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
        [X, Y, Z, Z_Region, x_area_min, x_area_max, y_area_min, y_area_max, AdjustX, AdjustY] ...
            = loadAndProcessTerrainData(gausscore, BATHYFile, flag2);
        PeakScope = 0; % Return empty
        DepthDATA_M = []; % Return empty
        Depth = 0; % Return empty
        % Sliding area
        x_area_min = 1000;
        x_area_max = 3500;
        y_area_min = 180;
        y_area_max = 1800;
    end
    % Create query grids for interpolation and calculation
    [xq, yq] = meshgrid(x_area_min:width:x_area_max, y_area_min:width:y_area_max);
    vq = griddata(X, Y, Z, xq, yq);
    % vq(isnan(vq)) = 0;
    
    % Compute gradients for flow direction arrows
    [Dxq, Dyq] = gradient(vq, width);
    
    % Create query grids for quiver plot
    [xq_q, yq_q] = meshgrid(x_area_min:quiverWidth:x_area_max, y_area_min:quiverWidth:y_area_max);
    vq_q = griddata(X, Y, Z, xq_q, yq_q);
    [Dxq_q, Dyq_q] = gradient(vq_q, quiverWidth);
    
    % Calculate slope in degrees
    slope = slope2(xq, yq, vq, 'degrees');
    % Note: Assuming slope2 is a custom function that you have available.

     % Create depth data uniformly set to a specific value
    DepthDATA = Depth * ones(size(vq));
    DepthDATA_M = DepthDATA;  % assuming you might modify or mask it later
end
