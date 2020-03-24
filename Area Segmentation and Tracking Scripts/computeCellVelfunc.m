function [] = computeCellVelfunc(inputpath)
%computeCellVelfunc Computes cell velocity over time
%   Inputs iMasks and retrieves centroid values at each time point from
%   which velocity is calculated and exported as a .mat file as well as
%   csv. 
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

%Open Masks

load(convertCharsToStrings(inputpath) + '\iMasks.mat')

unitconvert = (441*1e-9)^2 * 1e12; %This is dependent on microscope pixel size
%outputs area in microns

%loop through the loaded masks and compute velocity
cellVel = zeros(length(iMasks),1);
cellCent = cell(length(iMasks),1);
firstMask = iMasks{1,1};
firstCent = regionprops(firstMask,'centroid');
firstCent = firstCent.Centroid;
cellCent{1,1} = firstCent;
cellVel(1,1) = 0;
for i = 2:numel(iMasks)
    lastCent = cellCent{i-1,1};
    curMask = iMasks{i,1};
    curCent = regionprops(curMask,'centroid');
    if isempty(curCent)
        curCent =  lastCent;
    else
        curCent = curCent.Centroid;        
    end
    
    cellCent{i,1} = curCent;
    xvel = lastCent(1)-curCent(1);
    yvel = lastCent(2)-curCent(2);
    
    diff = sqrt(xvel^2 + yvel^2);
    %Get cell spread area from mask
    cellVel(i,1) = diff;
end

%Detect some outliers and correct to avoid massive spikes
stdVel = std(cellVel);
for i = 1:numel(cellVel)
   if cellVel(i) >= 3*stdVel
      cellVel(i) = 0;
   end
end

%save velocities
save(convertCharsToStrings(inputpath) + '\cellVelocities.mat', 'cellVel');

end

