function [AdjustclimMin, AdjustclimMax, cmapType, Depth] = setDynamicColormapWithType(SynOutputFileType, SynOutputFile, xq, yq, vq, Depth)
    % Initialize Depth based on SynOutputFileType
    if any(SynOutputFileType ~= 'h')
        Depth = 1 / 100; % Normalized hUx hUy
        pivotValue = 0; % Pivot set to 0 for non-'h' types
    else
        % Depth = Depth; % Depth for 'h' type
        pivotValue = 1; % Pivot set to 1 for 'h' types
    end

    % Calculate AdjustclimMin and AdjustclimMax
    AdjustclimMin = min(SynOutputFile(length(SynOutputFile)).data(:)) / Depth;
    AdjustclimMax = max(SynOutputFile(length(SynOutputFile)).data(:)) / Depth;
    
    cmapType = setDynamicColormap(xq, yq, vq, SynOutputFile(1).data, AdjustclimMin, AdjustclimMax, pivotValue);
end
