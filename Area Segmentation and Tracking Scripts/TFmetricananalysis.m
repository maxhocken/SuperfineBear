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

%Now run the code for everything in the subfolders. 

%Create cell array to store resulting data to combine later

dataExport = cell(1,numel(subfolders));
for i = 1:numel(subfolders)
   cursubfolder = subfolders{1,i};
   fulldirectory = strcat(inputfolder,'\',cursubfolder);
   disp('Processing')
   disp(fulldirectory)
   
   %check if TFM was run on this particular movie. if so proceed.
   
   if isfile(strcat(fulldirectory,'\TFMPackage\forceField\forceField.mat'))
       
       %check to see if these have already been processed. 

       if isfile(strcat(fulldirectory,'\netContractileMoments.mat'))

       else
           computeNetContractileMomentfunc(fulldirectory);
       end

       if isfile(strcat(fulldirectory,'\StrainEnergyDensities.mat'))

       else
           computeStrainEnergyDensityfunc(fulldirectory);
       end


       %Once both the NetContractileMoment and Strain energy density have run,
       %compile the results into a table to export as a csv for excel
       %load each of the data sets and set to dataExport
       load(strcat(fulldirectory,'\netContractileMoments.mat'))
       load(strcat(fulldirectory,'\StrainEnergyDensities.mat'))
       frames = transpose(1:numel(cMoments));
       data = horzcat(frames,strainEnergies,cell2mat(cMoments));
       dataExport{1,i} = data;

       %go ahead and export this as a csv as well

       csvwrite(strcat(fulldirectory,'\compiledData.csv'),data);
       %Horzcat will fail when the matrices do not have the same vertical
       %length as will happen with our data. 
       %dataExport = horzcat(dataExport,data);
   else
       disp('TFM has not been run on this movie')
       disp('ignoring...')
   end
end
export=[];
%save data export as csv 
for k = 1:numel(dataExport)
   curData = dataExport{1,k};
    
   
%    
%    s=size(curData(:,1));z=size(export(:,1));% (find size of both)
%    
%    d=[b;zeros(z(1)-s(1),1)]; % concatenate the smaller with zeros
%    c=[a,d]; % catenate the two vectors
   
   export = padconcatenation(export,dataExport{1,k},2);
end

csvwrite(strcat(inputfolder,'\data.csv'),export);




function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
% Get a list of all files and folders in this folder.
files    = dir(parentDir);
names    = {files.name};
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
% Extract only those that are directories.
subDirsNames = names(dirFlags);
end