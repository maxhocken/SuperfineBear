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

%Define Column Headers
cHeaders = {'Frame', 'Strain Energy', 'Strain Energy Density',...
    'Average Traction', 'Net Contractile Moment', 'Cell Velocity', 'Cell Area',...
    'Cell Perimeter'};
for i = 1:numel(subfolders)
   cursubfolder = subfolders{1,i};
   fulldirectory = strcat(inputfolder,'\',cursubfolder);
   disp('Processing')
   disp(fulldirectory)
   
   %check if TFM was run on this particular movie. if so proceed.
   
   if isfile(strcat(fulldirectory,'\TFMPackage\forceField\forceField.mat'))
       
       %Check if iMasks exists
       if isfile(strcat(fulldirectory,'\iMasks.mat'))
           
%            computeNetContractileMomentfunc(fulldirectory);
%            computeStrainEnergyDensityfunc(fulldirectory);
%            computeAverageTractionForcefunc(fulldirectory); 
%            computeCellAreasfunc(fulldirectory);
%            computeCellVelfunc(fulldirectory);
%            computeCellPerimeterfunc(fulldirectory);

           
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
           
           if isfile(strcat(fulldirectory,'cellVelocities.mat'))
               
           else
               computeCellVelfunc(fulldirectory);
           end
           
           if isfile(strcat(fulldirectory,'cellPerimeters.mat'))
               
           else
               computeCellPerimeterfunc(fulldirectory);
           end
           %Load back the strain energydensities,cellAreas and the average tractions
           %and export averages as csv, as well as periodic data
           load(strcat(fulldirectory,'\AverageTraction.mat'))
           load(strcat(fulldirectory,'\StrainEnergyDensities.mat'))
           load(strcat(fulldirectory,'\cellArea.mat'))
           load(strcat(fulldirectory,'\StrainEnergies.mat'))
           load(strcat(fulldirectory,'\netContractileMoments.mat'))
           load(strcat(fulldirectory,'\cellVelocities.mat'))
           load(strcat(fulldirectory,'\cellPerimeters.mat'))
           frames = transpose(1:numel(AverageTraction));
           %convert NCM to double
           cMoments = cell2mat(cMoments);

           %Once metrics have run,
           %compile the results into a table to export as a csv for excel
           %load each of the data sets and set to dataExport

           data = horzcat(frames,strainEnergies,strainEnergiesDensities,AverageTraction,cMoments,cellVel,cellArea,cellPerim);
           dataColumns = numel(data(1,:));
           %Add header, make into cell array to handle mixed data
           data2 = cell(numel(cMoments)+1,dataColumns);
           data2(1,:) = cHeaders;
           data2(2:end,:) = num2cell(data);
           dataExport{1,i} = data2;

           %go ahead and export this as a csv as well

           xlswrite(strcat(fulldirectory,'\compiledData.xlsx'),data2);
           %Horzcat will fail when the matrices do not have the same vertical
           %length as will happen with our data. So we use cell array
           %dataExport = horzcat(dataExport,data);
       else
           disp('Movie has not been masked...ignoring')
           
       end
   else
       disp('TFM has not been run on this movie')
       disp('ignoring...')
   end
end

%Concatenates each set of data next to each other. Need to strip header and
%convert back into double array to compute averages. 
export = [];
%save data export as csv 
for k = 1:numel(dataExport)
   curData = dataExport{1,k};
   %Remove Header
   curData = curData(2:end,:);
   curData = cell2mat(curData);

   %We need to remove nan values from the data set and replace them with
   %something reasonable. 
   
%    
%    s=size(curData(:,1));z=size(export(:,1));% (find size of both)
%    
%    d=[b;zeros(z(1)-s(1),1)]; % concatenate the smaller with zeros
%    c=[a,d]; % catenate the two vectors
   
   export = padconcatenation(export,curData,2);
end

xlswrite(strcat(inputfolder,'\data.csv'),export);

%Compute averages for each column and export as csv

averageExport = nanmean(export);
%Reshape into rows with every three columns being a row

averageExport = reshape(averageExport,dataColumns,[]);
averageExport = averageExport.';

%Go ahead and set the first value in each column to be equal to the movie
%number as average frame is useless.

averageExport(:,1) = 1:numel(averageExport(:,1));

%Now add back in a header and export as xlsx file
cHeaders{1,1} = 'Movie';
averageExport2 = cell(size(averageExport,1)+1,dataColumns);
averageExport2(1,:) = cHeaders;
averageExport2(2:end,:) = num2cell(averageExport);

xlswrite(strcat(inputfolder,'\averagedata.xlsx'),averageExport2);