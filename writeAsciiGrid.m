function writeAsciiGrid(data, header, filename)
    % Open the file for writing
    fileId = fopen(filename, 'wt');  % 'wt' stands for write text

    % Write the header information
    fprintf(fileId, 'ncols        %d\n', header.ncols);
    fprintf(fileId, 'nrows        %d\n', header.nrows);
    fprintf(fileId, 'xllcorner    %f\n', header.xllcorner);
    fprintf(fileId, 'yllcorner    %f\n', header.yllcorner);
    fprintf(fileId, 'cellsize     %f\n', header.cellsize);
    fprintf(fileId, 'NODATA_value %f\n', header.NODATA_value);

    % Write the data
    for row = 1:header.nrows
        fprintf(fileId, '%g ', data(row, :));
        fprintf(fileId, '\n');
    end

    % Close the file
    fclose(fileId);
end
