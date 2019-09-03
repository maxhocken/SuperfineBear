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
fudgeFactor = 0.60;
%%%%%%




BWs = edge(I,'sobel',threshold * fudgeFactor);



%imshow(BWs)
%title('Binary Gradient Mask')

%Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);


BWsdil = imdilate(BWs,[se90 se0]);
%imshow(BWsdil)
%title('Dilated Gradient Mask')

%Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');
%imshow(BWdfill)
%title('Binary Image with Filled Holes')

%Step 5: Remove Connected Objects on Border. No bad
BWnobord = BWdfill; %imclearborder(BWdfill,4);
%imshow(BWnobord)
%title('Cleared Border Image')

%Step 6: Smooth the Object
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
% imshow(BWfinal)
% title('Segmented Image');

%Step 6.5: Only keep the largest x continous areas of mask (is likely cell)
%Save the overlay image as seperate file in seperate folder. Also explain
%fudge factor and number of kept regions. Right now it is keeping top 15. 




BWfinal=bwareafilt(BWfinal,[1000,100000]);


%Step 6.6: Identify regions that are not connected and calculate area
%seperately. 
centroids = regionprops(BWfinal, 'centroid');

stats = regionprops('table',BWfinal, 'Area', 'Centroid');



%Step 7: Compare with original
imshow(labeloverlay(I,BWfinal))
%saveas(gcf,convertCharsToStrings(baseFileName) + '.tif');
% title('Mask Over Original Image')
%saveas(gcf,[image '.png'])
%Step 8: Calculate area which is equal to number of pixels *pixel size
%(.1560)
area=bwarea(BWfinal)*(.1560^2);
mask=BWfinal;
end