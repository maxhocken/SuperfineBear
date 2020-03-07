%CellMaskGeneratorFastv1.m
%%Script that will take input folder and calculate cell areas for all
%%.tif files. Creates cellular masks as well as calculates cell centroids.
% Input:
%  - Input folder containing single images in the tif format.
%   
% Output:
%  - Outputs into directory with scripts the masks of cells as well as
%  variables centroids with the cell centroids in x,y format, and the area
%  of those cells similarly. Masks as well as centroid csvs are outputed
%  into subdirectories of the queried output folder as Masks and Tracking
%  respectively. 
%  --Max Hockenberry 3 5 20
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
%Query for an input/output
folderpath = uigetdir;
%'D:\Dropbox\SuperfineBear Lab\Area Segmentation and Tracking Scripts\Sample Images';

outputpath = uigetdir;
% Make subdirectories in output folder
mkdir(outputpath, 'Masks')
mkdir(outputpath, 'Tracking') 
mkdir(outputpath, 'Boundaries')

% Specify the folder where the files live.
myFolder = folderpath;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.tif'); 
theFiles = dir(filePattern);

%make array to hold name and area
areas = cell(numel(theFiles),2);
centroids = cell(numel(theFiles),2);
statstable = cell(numel(theFiles),2);

maskoutpath = convertStringsToChars(convertCharsToStrings(outputpath) + '\Masks');
%make container to hold masks

iMasks = cell(numel(theFiles),1);
for k = 1 : numel(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  
  areas{k,1}=fullFileName;
  centroids{k,1}=fullFileName;
  statstable{k,1}=fullFileName;
  
  fprintf(1, 'Now reading %s\n', fullFileName);
  % calculate area of cell using area script and centroid
  [areas{k,2},mask,centroids{k,2},statstable{k,2}]=ImageThresholdingv2(fullFileName);
   
%  Save the output marked image in Masks folder as png
   pngout = convertCharsToStrings(maskoutpath) + '\' + baseFileName(1:end-4) + '.png';

   imwrite(mask,char(pngout))
   iMasks{k} = mask;
   
end

save(convertCharsToStrings(outputpath) + '\iMasks.mat', 'iMasks');
