function [] = computeNetContractileMomentfunc(inputdirectory)
%computeNetContractileMomentfunc Function handle which computes Net
%Contractile Moments
%   Passed the input directory containing tractionforce folders and compute
%   NCM from specified TFM files. 
%Compute net contractile moment
%Input: Mask of object, its centroid, and the relevant traction field. 
%Operation: Mask the traction field and shift the resulting object to 0,0
%by subtractin centroid coordinates. Then compute Net Contractile Moment,
%maybe strain energy density while we are here. 
%Outputs net contractile moment/strain energy density
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
% 
% 
%Step 1: Load the forcefields which is structure containing positions and vectors
%for each frame. Load Masks

load(convertCharsToStrings(inputdirectory) + '\TFMPackage\forceField\forceField.mat')
load(convertCharsToStrings(inputdirectory) + '\iMasks.mat')

unitConvert = (441*1e-9)^3 * 1e15; %This is dependent on what the units of tMap and dMap are, basically the size of each pixel

cMoments = cell(numel(forceFieldShifted),1);


for i = 1:numel(forceFieldShifted)
    
    %Step 2: Pull out a traction map/position from forceFieldShifted. Column 1
    %is x direction, column 2 is y direction
    positions = forceFieldShifted(i).pos;
    vectors = forceFieldShifted(i).vec;
    
    %Step 3: Seperate objects from masks using bwboundaries. Create bin to
    %hold moments for each boundary
    curMask = iMasks{i,1};
    boundaries = bwboundaries(curMask);
    
    moments = cell(numel(boundaries),1);
    if numel(boundaries) == 0
       moments = cell(1,1);
       moments{1,1} = [0,0;0,0];
    end
    %For each boundary object we will carry out these operations
    for j = 1:numel(boundaries)
       curBound = boundaries{j,1};
       maskedVec = vectors;
       %Recreate mask by plotting boundary points into empty set and filling
       newMask = zeros(size(curMask));
           for k = 1:numel(curBound(:,1))
              newMask(curBound(k,1),curBound(k,2)) = 1; 
           end
       %Fill the mask using imfill
       newMask = imfill(newMask,'holes');
       %Get cell centroid. We will use this later when computing distance
       %for our contractile moments
       stats = regionprops(newMask);
       centroid = stats.Centroid;
       
       %Dilate Mask slightly to account for tractions not within the cell
       %boundry. 40 is chosen arbitrarily by experience and inspection. 
       SE = strel('diamond',20); 
       newMask = imdilate(newMask,SE);
       
       %Step 4: Mask the traction field using object masks. Rebuild xy
       %Tmaps from position and vector maps. We actually can't do this
       %because of the template size being smaller than the actual image.
       %So we need to instead filter out all of the points not found in the
       %mask and set their vectors to 0. 
              
       %Find all xy points in mask
       [xvals, yvals] = find(newMask);
       profile on
       %Mask the vector using ismember function
       
       test = ismember(positions(:,:),[xvals, yvals],'rows');
       maskedVec = maskedVec.*test;
       
       %Looping is extrememely slow. Just vectorize as above. 
%        for n = 1:numel(positions(:,1))
%           test = ismember(positions(n,:),[xvals,yvals],'rows');
%           
%           
%               if test ~= 1
%                   %if not in the mask, then set the tmap at that location to zero
%                   maskedVec(n,:) = 0;
%               end
       %Now we have the masked vector field and positional data. We should
       %be able to compute net contractility moments for each object.
       
%        end


        %Step 5: Compute contractility moments given masked traction fields
        %for each object. Output object to storage array. loop through each
        %row in maskedVec. Subtracting x, y values from positions here to
        %get measurements in terms of centroid of the cell. 
     
        M11 = 0;
        M12 = 0;
        M21 = 0;
        M22 = 0;

        for l = 1:numel(maskedVec(:,1))
    

            M11 = M11 + (((positions(l,1)-centroid(1))*maskedVec(l,1) + (positions(l,1)-centroid(1))*maskedVec(l,1))*unitConvert * .5);

            M12 = M12 + (((positions(l,1)-centroid(1))*maskedVec(l,2) + (positions(l,2)-centroid(2))*maskedVec(l,1))*unitConvert * .5);

            M21 = M21 + (((positions(l,2)-centroid(2))*maskedVec(l,1) + (positions(l,1)-centroid(1))*maskedVec(l,2))*unitConvert * .5);

            M22 = M22 + (((positions(l,2)-centroid(2))*maskedVec(l,2) + (positions(l,2)-centroid(2))*maskedVec(l,2))*unitConvert * .5);
          
        end


        %put contractile moments in convienent matrix
        contractileMoments = [M11, M12 ; M21, M22];
        moments{j,1} = contractileMoments;
       
    end
   
    cMoments{i,1} = moments{1,1}(1,1) + moments{1,1}(2,2);
    
end

save(convertCharsToStrings(inputdirectory) + '\netContractileMoments.mat', 'cMoments');
end