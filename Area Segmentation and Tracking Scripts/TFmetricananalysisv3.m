%TFmetricanalysis Script to run basic metric correlation analysis on
%obtained TF data after masking. 
%   Input: Folder containing processed TF data, masked images, and both NCM
%   and Strain energy data in csv.
%   Output: Exports compiled data in excel file format. 
%  --Max Hockenberry 3 5 20
%   
%   Copyright (C) <2020>  <Max Hockenberry>
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
inputfolder = uigetdir;

%computeNetContractileMomentfunc(inputfolder);
%computeStrainEnergyDensityfunc(inputfolder);

% Get a list of all files and folders in this folder.
subfolders = GetSubDirsFirstLevelOnly(inputfolder);
% Remove any subfolder that does not contain iMasks
for i = 1:numel(subfolders)
  curFolder = strcat(inputfolder,'\',subfolders{1,i});
  
  %Check if iMasks exists
  if isfile(strcat(curFolder,'\iMasks.mat'))
      
  else
      
  end
    
end

%Now run the code for everything in the subfolders. 

%Create cell array to store resulting data to combine later

dataExport = cell(1,numel(subfolders));
dataExport2 = cell(1,numel(subfolders));
for i = 1:numel(subfolders)
   cursubfolder = subfolders{1,i};
   fulldirectory = strcat(inputfolder,'\',cursubfolder);
   disp('Processing')
   disp(fulldirectory)
   
   %check if TFM was run on this particular movie. if so proceed.
   
   if isfile(strcat(fulldirectory,'\TFMPackage\forceField\forceField.mat'))
       
       
       %Check if iMasks exists
       if isfile(strcat(curFolder,'\iMasks.mat'))
%            computeNetContractileMomentfunc(fulldirectory);
%            computeStrainEnergyDensityfunc(fulldirectory);
%            computeAverageTractionForcefunc(fulldirectory); 
%            computeCellAreasfunc(fulldirectory);

           
           %check to see if these have already been processed. If not
           %process!
           if isfile(strcat(fulldirectory,'\netContractileMoments.mat'))

           else
               computeNetContractileMomentfunc(fulldirectory);
           end

           if isfile(strcat(fulldirectory,'\StrainEnergyDensities.mat'))

           else
               computeStrainEnergyDensityfunc(fulldirectory);
           end
           
           if isfile(strcat(fulldirectory,'\AverageTraction.mat'))
               
           else
               computeAverageTractionForcefunc(fulldirectory); 
           end
           
           if isfile(strcat(fulldirectory,'cellArea.mat'))
               
           else
               computeCellAreasfunc(fulldirectory);
           end
           
           %Load back the strain energydensities,cellAreas and the average tractions
           %and export averages as csv, as well as periodic data
           load(strcat(fulldirectory,'\AverageTraction.mat'))
           load(strcat(fulldirectory,'\StrainEnergyDensities.mat'))
           load(strcat(fulldirectory,'\cellArea.mat'))
           frames = transpose(1:numel(AverageTraction));
           data2 = horzcat(frames,strainEnergiesDensities,AverageTraction,cellArea);
           dataExport2{1,i} = data2;

           %go ahead and export this as a csv as well

           csvwrite(strcat(fulldirectory,'\compiledSEDandTractiondata.csv'),data2);
           


           %Once both the NetContractileMoment and Strain energy density have run,
           %compile the results into a table to export as a csv for excel
           %load each of the data sets and set to dataExport
           load(strcat(fulldirectory,'\netContractileMoments.mat'))
           load(strcat(fulldirectory,'\StrainEnergies.mat'))
           frames = transpose(1:numel(cMoments));
           data = horzcat(frames,strainEnergies,cell2mat(cMoments));
           dataExport{1,i} = data;

           %go ahead and export this as a csv as well

           csvwrite(strcat(fulldirectory,'\compiledData.csv'),data);
           %Horzcat will fail when the matrices do not have the same vertical
           %length as will happen with our data. 
           %dataExport = horzcat(dataExport,data);
       else
           disp('Movie has not been masked...ignoring')
           
       end
   else
       disp('TFM has not been run on this movie')
       disp('ignoring...')
   end
end
export = [];
export2 = [];
%save data export as csv 
for k = 1:numel(dataExport)
   curData = dataExport{1,k};
   curData2 = dataExport{1,k};
   %We need to remove nan values from the data set and replace them with
   %something reasonable. 
   
%    
%    s=size(curData(:,1));z=size(export(:,1));% (find size of both)
%    
%    d=[b;zeros(z(1)-s(1),1)]; % concatenate the smaller with zeros
%    c=[a,d]; % catenate the two vectors
   
   export = padconcatenation(export,dataExport{1,k},2);
   export2 = padconcatenation(export2,dataExport2{1,k},2);
end

csvwrite(strcat(inputfolder,'\data.csv'),export);
csvwrite(strcat(inputfolder,'\data2.csv'),export2);

%Compute averages for each column and export as csv

averageExport = nanmean(export);
averageExport2 = nanmean(export2);
%Reshape into rows with every three columns being a row

averageExport = reshape(averageExport,3,[]);
averageExport = averageExport.';

averageExport2 = reshape(averageExport2,4,[]);
averageExport2 = averageExport2.';
%Go ahead and set the first value in each column to be equal to the movie
%number as average frame is useless.

averageExport(:,1) = 1:numel(averageExport(:,1));
averageExport2(:,1) = 1:numel(averageExport2(:,1));
csvwrite(strcat(inputfolder,'\averagedata.csv'),averageExport);
csvwrite(strcat(inputfolder,'\averageSEDTFdata.csv'),averageExport2);

function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
% Get a list of all files and folders in this folder.
files    = dir(parentDir);
names    = {files.name};
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
% Extract only those that are directories.
subDirsNames = names(dirFlags);
end