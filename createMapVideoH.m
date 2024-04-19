function framedata = createMapVideoH(v, fname, titlename, cbname, ColorData, cmapType, ...
    xq, yq, vq, contour_levels, xq_q, yq_q, vq_q, Dxq_q, Dyq_q, data_ft, data_mt,  ...
    Z, AdjustX, AdjustY, x_ax_min2, x_ax_max2, y_ax_min2, y_ax_max2)
    % Create figure
    f1 = figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
    % Plot surface
    surf(xq, yq, vq, 'CData', ColorData, 'FaceColor', 'interp', 'EdgeColor', 'none');
    clim([AdjustX, AdjustY]);
    cmap = cmapType;  
    % cmap = cmocean('balance','pivot',1); % ColorMap cmocean
    colormap(cmap); 
    cb = colorbar;
    ylabel(cb, cbname);
    hold on;
    
    % Add contours
    contour3(xq,yq,vq,contour_levels, 'LineColor','k', 'LineWidth',0.3, 'EdgeAlpha',0.3);
    
    % Add quiver plot
    quiver3(xq_q,yq_q,vq_q,-Dxq_q,-Dyq_q,zeros(size(xq_q)), 'AutoScale', 'on', 'AutoScaleFactor', 0.8, 'LineWidth', 1);
    
    % Plot geological features
    % plotGeologicalFeatures(data_ft, data_mt, Z, AdjustX, AdjustY);
    
    % Set color limits
    
    % clim([min(ColorData(:)) - (1e-6), max(ColorData(:))]);
    
    % Adjust aspect ratio, limits, and view
    daspect([1 1 1]); 
    xlim([x_ax_min2, x_ax_max2]);
    ylim([y_ax_min2, y_ax_max2]);
    grid off;
    axis on;
    camlight('headlight');  
    material dull;
    shading flat; 
    view([0 0 1]);
    
    % Add title
    title(titlename);
    
    % % Save figure, data, and export graphics
    % saveas(f1, [fname '.fig']);
    % exportgraphics(f1, [fname '.png'], 'Resolution', 800);
   
    drawnow;
    framedata = getframe(f1);
    % writeVideo(v, frame);
    close(f1);
end
