function [] = computeCellPerimeterfunc(inputpath)
%computeCellPerimeterfunc Function handle which computes cell perimeter from masks
%   Passed the input directory containing tractionforce folders and compute
%   Cell Peremiters from specified TFM files. It should also need the
%   information from the .mat file containing the movie specifics like
%   pixel size to accurately compute area from pixels. 
%
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
%Input: Traction Force Folder path

%Output: Perimeters as csv file



%Open displacement and traction maps and Mask

load(convertCharsToStrings(inputpath) + '\iMasks.mat')

%Initialize strain energy holder based on traction field size (one per map)
unitconvert = (441*1e-9)^2 * 1e12; %This is dependent on microscope pixel size
%outputs area in microns

%loop through the loaded fields and compute strain energy
cellPerim = zeros(length(iMasks),1);
for i = 1:numel(iMasks)
    curMask = iMasks{i,1};
    
    %Get cell spread area from mask
     Perims = regionprops(curMask,'perimeter');
     cellPerim(i,1) = Perims.Perimeter;

end
%We can look at the correlation between strainEnergy and CellArea here. 
%[rho, pval] = corr(strainEnergies,cellArea);

%save strain energies
save(convertCharsToStrings(inputpath) + '\cellPerimeters.mat', 'cellPerim');

end

