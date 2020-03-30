function [] = PeriodicityAnalysisv1(inputfolder)
%PeriodicityAnalysisv1 Analyzes periodicity of TF metrics and outputs avg
%   Takes input folder containing subfolder of TF movies which have gone
%   through TFmetricanalaysis. Outputs excel file containing periods for
%   each image and average periods for each metric. Looking at longest
%   period oscillation we observe in each data set

% Get a list of all files and folders in this folder.
subfolders = GetSubDirsFirstLevelOnly(inputfolder);

%Now run the code for everything in the subfolders. 

%Create cell array to store resulting data to combine later

dataExport = cell(numel(subfolders),15);

%Define Column Headers
cHeaders = {'Movie', 'Strain Energy Density Long', 'Strain Energy Density Short',...
    'Average Traction Long', 'Average Traction Short', ...    
    'Strain Energy Long', 'Strain Energy Short', ...
    'Net Contractile Moment Long', 'Net Contractile Moment Short', ...
    'Cell Area Long', 'Cell Area Short',...
    'Cell Perimeter Long', 'Cell Perimeter Short',...
    'Cell Velocity Long', 'Cell Velocity Short'};
dataExport(1,:) = cHeaders;
for i = 1:numel(subfolders)
   cursubfolder = subfolders{1,i};
   fulldirectory = strcat(inputfolder,'\',cursubfolder);
   disp('Processing')
   disp(fulldirectory)
   
   %Make sure we are processing something that has completed
   %TFmetricanalysis
   if isfile(strcat(fulldirectory,'\compiledData.xlsx'))
       
        %Load data
        datapath = strcat(fulldirectory,'\compiledData.xlsx');
        data = xlsread(datapath);
        %xlsread strips header for us and data is outputted as double. 
        %Fix nans in data sets 

        %for now with 0's, strip rows with zeros
        data(isnan(data)) = 0;
        data = data(all(data,2),:);
        
        %Get frequency spacing fs
        endframe = numel(data(:,1)) - 5;
        frames = data(1:endframe,1)*5*60;
        %fs = 1/(frames(2)-frames(1));
        
        %Do periodicity analysis

        %SED
        SEDdata = data(1:endframe,3);
        [SEDlong, SEDshort] = autoCorrelatev1(frames,SEDdata);

        %TF
        TFdata = data(1:endframe,4);
        [TFlong, TFshort] = autoCorrelatev1(frames,TFdata);
        
        %Area
        Areadata = data(1:endframe,7);
        [Arealong, Areashort] = autoCorrelatev1(frames,Areadata);
        
        %SE
        SEdata = data(1:endframe,2);
        [SElong, SEshort] = autoCorrelatev1(frames,SEdata);
        
        %NCM
        NCMdata = data(1:endframe,5);
        [NCMlong, NCMshort] = autoCorrelatev1(frames,NCMdata);
        
        %Perimeter
        Perimdata = data(1:endframe,8);
        [Perimlong, Perimshort] = autoCorrelatev1(frames,Perimdata);
        
        %Cell velocity
        Veldata = data(1:endframe,6);
        [Vellong, Velshort] = autoCorrelatev1(frames,Veldata);      
        
        %Compile results to export
        export = [i, SEDlong, SEDshort, TFlong, TFshort, SElong, SEshort, ...
            NCMlong, NCMshort, Arealong, Areashort, Perimlong, Perimshort, ...
            Vellong, Velshort];
        dataExport(i+1,:) = num2cell(export);
        
   else
       disp('TFmetricanalysis has not been run on this movie')
   end
   
   
   
end

%Export data as .xlsx
xlswrite(strcat(inputfolder,'\periodicitydata.xlsx'),dataExport);

end

