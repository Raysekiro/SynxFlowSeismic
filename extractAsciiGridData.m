function fileStructArray = extractAsciiGridData(folderPath, SynOutputFileType, start_time, total_simulation_time, output_interval)
    % Initialize the structure array
    fileStructArray = struct('filename', {}, 'header', {}, 'data', {});

    % Calculate the number of files to expect based on the simulation parameters
    % numFiles = (total_simulation_time - start_time) / output_interval + 1;
    
    % Initialize the index for structure array
    structIndex = 1;

    % Loop over each time step to construct the filename and read the file
    currentTime = start_time;
    while currentTime <= start_time + total_simulation_time
        filename = fullfile(folderPath, sprintf(SynOutputFileType, currentTime));
        if exist(filename, 'file')
            [data, header] = readAsciiGrid(filename);
            fileStructArray(structIndex).filename = sprintf(SynOutputFileType, currentTime);
            fileStructArray(structIndex).header = header;
            fileStructArray(structIndex).data = data;
            structIndex = structIndex + 1;
        end
        currentTime = currentTime + output_interval;
    end
end


