%Script that will take input folder and calculate cell areas for all .tif.
%Needs to have input as cell DIC image to work properly. 

folderpath='D:\Bear Lab\Masking test\testtimemask\p6 dic';

% might use this later if turns into function
% if folderpath1~=0
%     folderpath=folderpath1;
% end

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
  % calculate area of cell using area script and centroid cause why not
  [areas{k,2},mask,centroids{k,2},statstable{k,2}]=cellareasegmentationv3(fullFileName);
  
  
  % Add centroids to image from statstable and add id number?
  
  
  
  imageArray = imread(fullFileName);
  
  
  
  
  %composite=imfuse(imageArray,mask);
  %imshow(imageArray);
  %imshow(mask);  % Display image.
  %imshow(composite);
  imshow(mask);
  %Place number at centroid positions
  centtable = statstable{k,2};
  centcoords = centtable.Centroid;
  hold on 
  %define input image based on number of values in table row?
  
  texthld = zeros(height(centtable),1);
  %disp(texthld)
  markimage=double(mask);
  
  for i = 1:numel(texthld)
      %disp(i)
      test = int2str(i);
      %texthld(i,1) = test;
      %disp(texthld(i))
      %display(centcoords(i,1));
      markimage = insertText(markimage,[centcoords(i,1) centcoords(i,2)], test);          
  end

  imshow(markimage)
  saveas(gcf,convertCharsToStrings(baseFileName) +'.png')
  drawnow; % Force display to update immediately.
end


