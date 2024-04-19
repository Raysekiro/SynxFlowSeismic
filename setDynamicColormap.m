function cmapType = setDynamicColormap(xq, yq, vq, data, AdjustclimMin, AdjustclimMax, pivotValue)
    % Create a figure, plot, and then close to not display
    fColor = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Visible', 'off');
    surf(xq, yq, vq, 'CData', data, 'FaceColor', 'interp', 'EdgeColor', 'none');
    clim([AdjustclimMin, AdjustclimMax]); % Set the color limits
    cmapType = cmocean('balance', 'pivot', pivotValue); % Apply cmocean colormap
    colormap(fColor, cmapType); % Apply the colormap to the figure
    colorbar;
    close(fColor); % Close the figure to prevent it from displaying
end
