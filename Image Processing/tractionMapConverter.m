%Import the files, process folder
inputfolder = uigetdir;
outputfolder = uigetdir;

%search input folder
files = dir(fullfile(inputfolder,'*.mat'));

%New problem. We need to scale each image the same across all of the files
%because otherwise the data becomes meaningless. So loop through again and
%pull out minimum and maximum values. 

%Intialize min/max
minimum = 0; 
maximum = 0;

for i = 1:numel(files)
    file = fullfile(inputfolder,files(i).name);
    
    [sourceFolder, baseFileNameNoExstension, ext] = fileparts(file);
    outputBaseName = [baseFileNameNoExstension, '.tif'];
    %disp(outputBaseName)
    I = load(file);
    cur_tMap = I.cur_tMap;
    localmin = min(min(cur_tMap));
    localmax = max(max(cur_tMap));
    if localmin < minimum
        minimum = localmin;
    end
    if localmax > maximum
        maximum = localmax;
    end  
    
end

%Convert double array to grayscale image
for i = 1:numel(files)
    file = fullfile(inputfolder,files(i).name);
    disp(file)
    [sourceFolder, baseFileNameNoExstension, ext] = fileparts(file);
    outputBaseName = [baseFileNameNoExstension, '.tif'];
    disp(outputBaseName)
    I = load(file);
    cur_tMap = I.cur_tMap;
    image = uint16(65535 * mat2gray(cur_tMap,[minimum maximum]));
    %output the image. 
    finalname = fullfile(outputfolder, outputBaseName);
    %display(finalname)
    imwrite(image,finalname);
    
    
end

