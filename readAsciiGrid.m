function [data, header] = readAsciiGrid(filename)
    % Open the file
    fileId = fopen(filename, 'rt');  % 'rt' for reading text
    
    % Initialize a struct to store header information
    header = struct();
    
    % Read the header information
    header.ncols       = fscanf(fileId, 'ncols %d', 1);
    fgetl(fileId);  % Move to the start of the next line
    header.nrows       = fscanf(fileId, 'nrows %d', 1);
    fgetl(fileId);  
    header.xllcorner   = fscanf(fileId, 'xllcorner %f', 1);
    fgetl(fileId);  
    header.yllcorner   = fscanf(fileId, 'yllcorner %f', 1);
    fgetl(fileId);  
    header.cellsize    = fscanf(fileId, 'cellsize %f', 1);
    fgetl(fileId);  
    header.NODATA_value= fscanf(fileId, 'NODATA_value %f', 1);
    fgetl(fileId);  
    
    % Read the raster data
    data = fscanf(fileId, '%f', [header.ncols, header.nrows]);
    
    % Close the file
    fclose(fileId);
    
    % Transpose the data matrix to match the layout in the file
    data = data';
end
