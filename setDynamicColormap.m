function cmapType = setDynamicColormap(xq, yq, vq, AdjustclimMin, AdjustclimMax, pivotValue, flag)
    % Create a figure, plot, and then close to not display
    fColor = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Visible', 'off');
    surf(xq, yq, vq, 'FaceColor', 'interp', 'EdgeColor', 'none');
    clim([AdjustclimMin, AdjustclimMax]); % Set the color limits
    
    % Check the flag to determine the colormap
    if flag == 1
        colormap(flipud(slanCM('RdBu'))); % Get the original colormap
        % Apply a pivot adjustment if necessary
        setPivot(gca, pivotValue);
        cmapOrig = colormap(gca);
    elseif flag == 2
        cmapOrig = colormap(parula);
    elseif flag == 3
        cmapOrig = colormap(turbo);
    end
    
    % Interpolate the colormap
    nColors = size(cmapOrig, 1);
    newPoints = linspace(1, nColors, 256);
    cmapType = interp1(1:nColors, cmapOrig, newPoints); % Correct interpolation
    
    colormap(fColor, cmapType); % Apply the rescaled colormap to the figure
    colorbar; % Display a colorbar
    close(fColor); % Close the figure to prevent it from displaying
end

