clc; clear; close all;
%% Output Path  & Time
t = datetime('now');
tName = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
tStart = tic;
OutPath = 'D:\1Reserch\Code\git_repo\SynxFlowSeismic\visualization';
FilePath = 'D:\Docker\Work\Synxflowtest\Peaktest\landslide_case\output';

%% Dairy
tEnd = toc(tStart);  
formattedTime = formatTime(tEnd);
fprintf('Start time: %s\n', t);
fprintf('Elapsed time: %s\n', formattedTime);