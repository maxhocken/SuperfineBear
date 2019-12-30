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
%Query for an input/output
folderpath = uigetdir;
%'D:\Dropbox\SuperfineBear Lab\Area Segmentation and Tracking Scripts\Sample Images';

outputpath = uigetdir;
% Make subdirectories in output folder
mkdir(outputpath, 'Masks')
mkdir(outputpath, 'Tracking') 

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

for k = 1 : numel(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  
  areas{k,1}=fullFileName;
  centroids{k,1}=fullFileName;
  statstable{k,1}=fullFileName;
  
  fprintf(1, 'Now reading %s\n', fullFileName);
  % calculate area of cell using area script and centroid
  [areas{k,2},mask,centroids{k,2},statstable{k,2}]=ImageThresholdingv1(fullFileName);
  
  
  % Add centroids to image from statstable. 
  
  imageArray = imread(fullFileName);
  
  %imshow(imageArray)
  %Get boundary from mask for comparison. 
  maskbound = bwboundaries(mask);
  %maskbound = maskbound{1,1};
  
  %Some options to compare original to mask. 
  %composite=imfuse(imageArray,maskbound,'falsecolor');
  %composite=imfuse(imageArray,mask,'blend');
  %imshow(imageArray);
  %imshow(mask);  % Display image.
  %imshow(composite);
  %drawnow;
  %imshow(mask);
  
  %Setup tablet of stats
  centtable = statstable{k,2};
  centcoords = centtable.Centroid;
  hold on 
   
  texthld = zeros(height(centtable),1);
  %disp(texthld)
  markimage=double(mask);
  
  %Place number at centroid positions
  for i = 1:numel(texthld)
      %disp(i)
      test = int2str(i);
      %texthld(i,1) = test;
      %disp(texthld(i))
      %display(centcoords(i,1));
      markimage = insertText(markimage,[centcoords(i,1) centcoords(i,2)], test);          
  end
  
  %Plot the boundary around the image for comparison.
  figure
  imshow(fullFileName)
  hold on
  %loop through boundaries and plot
  for i = 1:numel(maskbound)
      curbound = maskbound{i,1};
      plot(curbound(:,2),curbound(:,1));
  end
  
%  saveas(gcf,convertCharsToStrings(baseFileName) + 'comp' +'.png')
%  close
  
%  Save the output marked image in Masks folder
   pngout = convertCharsToStrings(baseFileName) + '.png';

   saveas(gcf,pngout)
   drawnow; % Force display to update immediately.
   close
   %move png to outputfolder
   pngout = convertStringsToChars(pngout);
   maskoutpath = convertStringsToChars(convertCharsToStrings(outputpath) + '\Masks');
   movefile(pngout, maskoutpath)
  
   %Write centtable to csv file with name as the frame. Will include areas
   %and the coordinates. 
   csvout = strcat(baseFileName, '.csv');
   writetable(centtable,csvout)
   trackoutpath = convertStringsToChars(convertCharsToStrings(outputpath) + '\Tracking');
   movefile(csvout, trackoutpath)
   
end