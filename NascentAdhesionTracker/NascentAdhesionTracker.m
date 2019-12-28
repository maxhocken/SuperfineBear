% %This program will take excel files containing XY coordinates of focal
% adhesions and plot the first ones that appear in each frame of a movie.
% The raw XY coordinate data is part of the output of Matthew Berginski's Focal
% Adhesion server. 


% Input:
    %Once you run your desired tiff movie through Matthew Beginski's Focal Adhesion server you
    %will recieve an output folder. Open the folder and use the following
    %path to get to the X and Y centroid csv files
    %(adhesion_props<<lin_time_series). 
    %You will also have to input an additional folder path towards the end
    %of the code where you have stored the image sequence for the Nascent
    %adhesions you wish to plot.
% Output:
    %The output is individual tif images. You can modify the code to choose
    %where the tiff images are saved. Each tif images contains Red dots
    %which are the plotted XY coordinates of the adhesions that form in
    %that frame. 


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
% %   Copyright (C) <2019>  <Harrison Hockenberry>

% Contributors [Harrison Hockenberry, Max Hockenberry, Sam Ramirez]


%Reads data in from a specified file path
%You will have to change the filepath based on where the Centroid_x and Centroid_y excel files are
%located

xpath = 'C:\Users\Harrison\Desktop\Centroid_x.csv';
ypath = 'C:\Users\Harrison\Desktop\Centroid_y.csv';

%The variables below store the data from the excel files accordingly
Xcoordinates = csvread(xpath);
Ycoordinates = csvread(ypath);



Xcoordinates;
Ycoordinates;

SizeRows1 = size(Xcoordinates,1);
SizeColumns1 = size(Xcoordinates, 2);
SizeRows2 = size(Ycoordinates, 1);
SizeColumns2 = size(Ycoordinates, 2);


%This will create a list of the indicies where the Focal adhesions first
%show up in the X direction
Xlist = [];
for i = 1:numel(Xcoordinates(:,1))
    
    row = Xcoordinates(i,:);
    firstXval = max(~isnan(row),[],1);
    
    firstXval = find(firstXval,1,'first');
    Xlist = [Xlist firstXval];   

end


%This will create a list of the indicies where the Focal adhesions first
%show up in the Y direction
Ylist = [];
for i = 1:numel(Ycoordinates(:,1))
    row1 = Ycoordinates(i,:);
    firstyval = max(~isnan(row1),[],1);
    firstyval = find(firstyval,1,'first');
    Ylist = [Ylist firstyval];
end


%Now we will match up each focal adhesion with the first index it appears
%to obtain just the XY coordinates where they first appear. 
FirstFocalX = [];
for i = 1:numel(Xcoordinates(:,1))
    Xcoord = Xcoordinates(i, Xlist(i));
    FirstFocalX = [FirstFocalX Xcoord];
    
end

FirstFocalY = [];
for i = 1:numel(Ycoordinates(:,1))
    Ycoord = Ycoordinates(i, Ylist(i));
    FirstFocalY = [FirstFocalY Ycoord];
end

FirstXYFA = [];
for i = 1:numel(FirstFocalX)
    firstx = FirstFocalX(i);
    firsty = FirstFocalY(i);
    %This will store the coordinates of the first time that the Focal
    %Adhesion appears it is formatted as X coordinate then Y coordinate
    FirstXYFA = [FirstXYFA firstx firsty];
end

%Trying to plot adhesions at each time point.
%Break up list based on time point
maskvals = linspace(1,SizeColumns1,SizeColumns1);
%Make array to hold obtained indexes
sortedpositions = cell(SizeColumns1,1);
for i = 1:numel(maskvals)

    indexedlist = find(Xlist == i);
    sortedpositions{i} = indexedlist;
    
    
end

folderpath='C:\Users\Harrison\Desktop\Area Segmentation and Tracking Scripts\Sample Images';

% Specify the folder where the files live.
myFolder = folderpath;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end


filePattern = fullfile(myFolder, '*.tif'); 
theFiles = dir(filePattern);

for i = 1:SizeColumns1
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    
    imageArray = imread(fullFileName);
    %Plot all Focal Adhesions by time point
    imshow(imageArray)
    axis on
    hold on
    scatter(FirstFocalY(sortedpositions{i,1}),FirstFocalX(sortedpositions{i,1}), 10, 'red', 'filled')
%     plot(FirstFocalX(sortedpositions{1,i}), FirstFocalY(sortedpositions{1,i}))

    saveas(gcf,convertCharsToStrings(baseFileName) +'.tif')
    close all
end


















    