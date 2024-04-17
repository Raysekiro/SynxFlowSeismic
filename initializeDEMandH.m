function [xq, yq, vq, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, slope, DepthDATA_M, ...
    x_area_max, y_area_max, PeakScope, width, quiverWidth, Depth, Z] = initializeDEMandH()
    % Define constants and ranges
    x_area_min = 1;
    x_area_max = 200;
    y_area_min = 1;
    y_area_max = 200;
    width = 0.2;
    quiverWidth = 5 * width;
    Depth = 2;
    PeakScope = min(x_area_max, y_area_max) / 2;
    PeakSize = 200;
    x = linspace(-4, 4, PeakSize);
    y = linspace(-4, 4, PeakSize);
    [X,Y] = meshgrid(x,y);
    % Generate peak data
    PeakData = peaks(X,Y);
    
    % Create grids for interpolation
    [xPeak, yPeak] = meshgrid(linspace((x_area_max - PeakScope) / 2, (x_area_max + PeakScope) / 2, PeakSize), ...
                              linspace((y_area_max - PeakScope) / 2, (y_area_max + PeakScope) / 2, PeakSize));
    X = xPeak(:);
    Y = yPeak(:);
    Z = PeakData(:);
    
    % Create query grids for interpolation and calculation
    [xq, yq] = meshgrid(x_area_min:width:x_area_max, y_area_min:width:y_area_max);
    vq = griddata(X, Y, Z, xq, yq);
    vq(isnan(vq)) = 0;
    
    % Compute gradients for flow direction arrows
    [Dxq, Dyq] = gradient(vq, width);
    
    % Create query grids for quiver plot
    [xq_q, yq_q] = meshgrid(x_area_min:quiverWidth:x_area_max, y_area_min:quiverWidth:y_area_max);
    vq_q = griddata(X, Y, Z, xq_q, yq_q);
    [Dxq_q, Dyq_q] = gradient(vq_q, quiverWidth);
    
    % Calculate slope in degrees
    slope = slope2(xq, yq, vq, 'degrees');
    
    % Create depth data uniformly set to a specific value
    DepthDATA = Depth * ones(size(vq));
    DepthDATA_M = DepthDATA;  % assuming you might modify or mask it later
    
    % Note: Assuming slope2 is a custom function that you have available.
end
