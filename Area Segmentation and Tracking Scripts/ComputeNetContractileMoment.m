%Compute net contractile moment
%Input: Mask of object, its centroid, and the relevant traction field. 
%Operation: Mask the traction field and shift the resulting object to 0,0
%by subtractin centroid coordinates. Then compute Net Contractile Moment,
%maybe strain energy density while we are here. 
%Outputs net contractile moment/strain energy density in csv files. 
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

inputdirectory = uigetdir;
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
disp(i)
    cMoments{i,1} = moments{1,1}(1,1) + moments{1,1}(2,2);
    
end

save(convertCharsToStrings(inputdirectory) + '\netContractileMoments.mat', 'cMoments');

% The code below is outdated and not representative but left in case it proves useful. 
% %Create rectangular region to test
% rectshape = ones(5,2);
% I = rectshape;
% I=double(I);
% [r,c]=size(I); 
% m=zeros(r,c); 
% % geometric moments 
% for i=0:1 
%     for j=0:1 
%         for x=1:r 
%             for y=1:c 
%                 m(i+1,j+1)=m(i+1,j+1)+(x^i*y^j*I(x,y)); 
%             end
%         end
%     end
% end
% 
% xb=m(2,1)/m(1,1); 
% yb=m(1,2)/m(1,1);
% 
% %Above is the centroid of cells
% 
% %Compute Net Contractile Moment Mxx + Myy
% netContractMoment = m(1,1) + m(2,2);
% disp(netContractMoment)
% % central moments 
% u=[ 0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0]; 
% for i=0:3 
%     for j=0:3 
%         for x=1:r 
%             for y=1:c 
%                 u(i+1,j+1)=u(i+1,j+1)+(x-xb)^i*(y-yb)^j*I(x,y); 
%             end
%         end
%     end
% end
% % scale invariant moments 
% n=[ 0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0]; 
% for i=0:3 
%     for j=0:3 
%         n(i+1,j+1)=u(i+1,j+1)/(u(1,1)^(1+(i+j)/2)); 
%     end
% end
% %rotation invariant moments 
% I_1= n(3,1)+ n(1,3); 
% I_2=(n(3,1)- n(1,3) )^2+ (2*n(2,2))^2; 
% I_3=(n(4,1)-3*n(2,3))^2+ (3*n(3,2)-n(1,4))^2; 
% I_4=(n(4,1)+n(2,3))^2+ (n(3,2)+n(1,4))^2; 
% I_5=(n(4,1)-3*n(2,3))*(n(4,1)+n(2,3))*((n(4,1)+n(2,3))^2-3*(n(3,2)+n(1,4))^2)...
%     +(3*n(3,2)-n(1,4))*(n(3,2)+n(1,4))*(3*(n(4,1)+n(2,3))^2-(n(3,2)+n(1,4))^2); 
% I_6=(n(3,1)-n(1,3))*((n(4,1)+n(2,3))^2-(n(3,2)+n(1,4))^2)+ 4*n(2,2)*(n(4,1)...
%     +n(2,3))*(n(3,2)+n(1,4)); 
% I_7=(3*n(3,2)-n(1,4))*(n(4,1)+n(2,3))*((n(4,1)+n(2,3))^2- 3*(n(3,2)+n(1,4))^2 )...
%     - (n(1,4)-3*n(2,3))*(n(3,2)+n(1,4))*(3*(n(4,1)+n(2,3))^2-(n(3,2)+n(1,4))^2);
% M= [I_1 I_2 I_3 I_4 I_5 I_6 I_7];