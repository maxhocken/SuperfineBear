%%
%%Script that will take input image and thresholds it to create a cell
%%mask. Will calculate total area of cells in image and output as areas
%%variable. Calculates centroids and outputs them as centroids variable. 
%
% Input:
%  - Image file passed by Cellareascript.m
%   Functionally the script thresholds using a sobel method from the matlab
%   image analysis toolbox, dilates the obtained threshold, then fills in
%   image holes. Finally it smooths the object before determining centroid
%   and area stats again using the matlab image analysis toolbox. 


%  A variety of values can be adjusted in order to improve thresholding and
%  final mask. The fudgefactor controls how harsh the sensitivity threshold
%  is. The closer to one the value, the greater the image intensity must be
%  to count as an edge. In order to detect some fine feature cellular
%  structures such as lamellopodia, often the fudge factor must be lowered.
%  
%
%  Additionally, the bracket size in step 6.5 can be adjusted in order to
%  catch larger or smaller detected objects. This usually needs to be
%  adjusted sample by sample. You can find image area by the usual methods
%  in FIJI in order to define the lower and upper bound of kept objects. 
% Output:
%  -  area: pixel area of created masks in microns as calculated by
%  provided resolution hardcoded at bottom of script. 
%  -  mask: binary image file of the cell mask.
%  -  centroids: matlab structure containing all centroid values for masked
%  objects in x,y format. 
%  -  stats: matlab structure contining all centroid valeus and area values for masked objects
%  in a table format (n x 2). Outputted to statstable object in Cellareascript 
%
%  --Max Hockenberry 9 7 19
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


function [area,mask,centroids,stats] = cellareasegmentationv3(image)
%Cell segmentation and area analysis program
%Works by thresholding the image. You can adjust the fudgeFactor to make it
%more or less sensitive to changes in contrast. You can also change the
%number of areas it attempts to save down in step 6.5 to change how many
%connected areas it tries to keep.



%Image to process
%image='p24 dic0001.tif';
%Read image
I = imread(image);
%imshow(I)
%title('Original Image');

%Detect Entire Cell
[~,threshold] = edge(I,'sobel');




%%%%%%
fudgeFactor = 0.95;
%%%%%%




BWs = edge(I,'sobel',threshold * fudgeFactor);



%imshow(BWs)
%title('Binary Gradient Mask')

%Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);


BWsdil = imdilate(BWs,[se90 se0]);
imshow(BWsdil)
%title('Dilated Gradient Mask')

%Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');
%imshow(BWdfill)
%title('Binary Image with Filled Holes')

%Step 5: Remove Connected Objects on Border. Elected to keep the images on
%the border. 
BWnobord = BWdfill; %imclearborder(BWdfill,4);
%imshow(BWnobord)
%title('Cleared Border Image')

%Step 6: Smooth the Object
seD = strel('diamond',2);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
% imshow(BWfinal)
% title('Segmented Image');

%Step 6.5: 
%Select which of the detected objects to keep, default between pixel areas
%of 1000 and 100000. 

BWfinal=bwareafilt(BWfinal,[1000,100000]);


%Step 6.6: Identify regions that are not connected and calculate area and
%centroids
%seperately. 
centroids = regionprops(BWfinal, 'centroid');

stats = regionprops('table',BWfinal, 'Area', 'Centroid');



%Step 7: Compare with original
%imshow(labeloverlay(I,BWfinal))
%saveas(gcf,convertCharsToStrings(baseFileName) + '.tif');
% title('Mask Over Original Image')
%saveas(gcf,[image '.png'])


%Step 8: Calculate area which is equal to number of pixels *pixel size
%(.1560). Replace .1560 with whatever your pixel size is. 
area=bwarea(BWfinal)*(.1560^2);
mask=BWfinal;
end