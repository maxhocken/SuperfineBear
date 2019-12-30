%Cell Tracking Script
%Implementation of simpletracker in existing pipeline
%%Script that will take input folder of CSV's and calculate cell areas for all
%%.tif files. Creates cellular masks as well as calculates cell centroids.
% Input:
%  - Input folder containing csv files of centroid points as obtained from
%  CellMaskGenerator.m.
%   
% Output:
%  - Outputs the tracks and adjacency tracks as cell arrays which can be
%   used to match up with the coordinates to get the full length tracks.
%   These tracks are plotted as shown below. Further the average velocity
%   on those tracks is outputted as an array for each track. Basic use of
%   these outputs is demonstrated in TrackCells.m.
%  --Max Hockenberry 12 30 19
%   
%   Copyright (C) <2019>  <Max Hockenberry>
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
% 
% 
%%

%Query the tracking folder
trackfolder = uigetdir;

%Go through folder and extract each csv file, open them

% Specify the folder where the files live.
myFolder = trackfolder;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.csv'); 
theFiles = dir(filePattern);

centroidpoints = cell(1,numel(theFiles));

for k = 1 : numel(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  table = readtable(fullFileName);
  xval = table2array(table(:,2));
  yval = table2array(table(:,3));
  
  centvals = [xval,yval];
  
  centroidpoints{1,k} = centvals;
end

%Simpletracker
[tracks, adjacency_tracks, averagevel] = TrackCells(centroidpoints);

