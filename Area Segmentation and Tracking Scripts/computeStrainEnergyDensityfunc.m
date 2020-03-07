function [] = computeStrainEnergyDensityfunc(inputpath)
%computeStrainEnergyDensityfunc Function handle which computes Strain
%Energy Density
%   Passed the input directory containing tractionforce folders and compute
%   StrainEnergyDensity from specified TFM files. 
%Strain Energy density 
%  --Max Hockenberry 3 5 20
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
%Input: Traction Map, Displacement Map, cell masks

%Output: Strain Energy density


%U = 1/2 * Integral(T dot u dxdy)

%Open displacement and traction maps and Mask

load(convertCharsToStrings(inputpath) + '\iMasks.mat')
load(convertCharsToStrings(inputpath) + '\TFMPackage\forceField\tractionMaps.mat')
load(convertCharsToStrings(inputpath) + '\TFMPackage\displacementField\dispMaps.mat')

%Initialize strain energy holder based on traction field size (one per map)
unitconvert = (441*1e-9)^3 * 1e15; %This is dependent on what the units of tMap and dMap are, basically the size of each pixel
%in. Need to confirm dimensions but want to output in fJ = 1e15 Nm
strainEnergies = zeros(length(dMap),1);
%loop through the loaded fields and compute strain energy
cellArea = zeros(length(dMap),1);
for i = 1:numel(strainEnergies)
    curTmap = tMap{1,i};
    curUmap = dMap{1,i};
    curMask = iMasks{i,1};
    
    %Get cell spread area from mask
    cellArea(i,1) = sum(sum(curMask))*(.441^2);
    
    %Dilate Mask slightly to account for tractions not within the cell
    %boundry. 
    SE = strel('diamond',40); 
    curMask = imdilate(curMask,SE);
    
    
    %Compute Strain Energy Density
    curStrainEnergyDensity = 0.5 * unitconvert * sum(sum(curTmap.*curUmap.*curMask));
    strainEnergies(i,1) = curStrainEnergyDensity;
    
    
end
%We can look at the correlation between strainEnergy and CellArea here. 
%[rho, pval] = corr(strainEnergies,cellArea);

%save strain energies
save(convertCharsToStrings(inputpath) + '\StrainEnergyDensities.mat', 'strainEnergies');
end

