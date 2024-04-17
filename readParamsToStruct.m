function paramsStruct = readParamsToStruct(paramsFilePath)
    % Check if the parameters file exists
    if ~exist(paramsFilePath, 'file')
        error('Parameters.txt file does not exist at the specified path.');
    end
    
    % Initialize the structure for storing parameters
    paramsStruct = struct();
    
    % Open the file for reading
    fileId = fopen(paramsFilePath, 'rt');
    
    % Read each line from the file
    while ~feof(fileId)
        line = fgetl(fileId);
        if ischar(line)
            % Split the line into variable name and value
            splitLine = strsplit(line, '=');
            varName = strtrim(splitLine{1});
            value = strtrim(splitLine{2});
            
            % Attempt to convert the value to a number, if applicable
            numericValue = str2double(value);
            if ~isnan(numericValue)
                % The value is numeric
                paramsStruct.(varName) = numericValue;
            else
                % Check if the value is a logical 'true' or 'false'
                if strcmpi(value, 'true')
                    paramsStruct.(varName) = true;
                elseif strcmpi(value, 'false')
                    paramsStruct.(varName) = false;
                else
                    % The value is a string, store it directly
                    paramsStruct.(varName) = value;
                end
            end
        end
    end
    
    % Close the file
    fclose(fileId);
end
