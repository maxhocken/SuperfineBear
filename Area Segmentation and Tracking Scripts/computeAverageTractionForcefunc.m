function [] = computeAverageTractionForcefunc(inputpath)
%computeAverageTractionForcefunc Function handle which computes Average
%traction force from Danuser output
%   Passed the input directory containing tractionforce folders and compute
%   Average Traction force from specified TFM files. It should also need the
%   information from the .mat file containing the movie specifics like
%   pixel size to accurately compute area from pixels. 
%Strain Energy density 
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
%Input: Traction Map, Displacement Map, cell masks

%Output: Strain Energy density

%Open traction maps and Mask

load(convertCharsToStrings(inputpath) + '\iMasks.mat')
load(convertCharsToStrings(inputpath) + '\TFMPackage\forceField\tractionMaps.mat')


%Initialize strain energy holder based on traction field size (one per map)

AverageTraction = zeros(length(tMap),1);

%loop through the loaded fields and compute strain energy
cellArea = zeros(length(tMap),1);
for i = 1:numel(AverageTraction)
    curTmap = tMap{1,i};
    
    curMask = iMasks{i,1};
    
    %Get cell spread area from mask
    cellArea(i,1) = sum(sum(curMask))*(.441^2);
    
    %Dilate Mask slightly to account for tractions not within the cell
    %boundry. 
    SE = strel('diamond',40); 
    curMask = imdilate(curMask,SE);
    
    
    %Compute Average Traction without zeros, so sum divided by count
    %without zero
    curAverageTraction = mean(nonzeros(curTmap.*curMask));
    AverageTraction(i,1) = curAverageTraction;

end
%We can look at the correlation between strainEnergy and CellArea here. 
%[rho, pval] = corr(strainEnergies,cellArea);

%save strain energies
save(convertCharsToStrings(inputpath) + '\AverageTraction.mat', 'AverageTraction');

end

