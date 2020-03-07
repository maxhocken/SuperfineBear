%Input: User defined directory to processed images. 
%Output: Plots numerous correlation statistics of the data sets and makes
%figure for review. 
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
close all
inputfolder = uigetdir;
load(strcat(inputfolder,'\iMasks.mat'))
data = csvread(strcat(inputfolder,'\compiledData.csv'));

centroids = cell(numel(iMasks),1);
difference = zeros(numel(iMasks),1);
Areas = zeros(numel(iMasks),1);
for i = 1:numel(iMasks)
   curMask = iMasks{i,1}; 
   stats = regionprops(curMask);
   
   if isempty(stats) == 1
       %use old value for centroid if the mask fails
       centroids{i,1} = centroids{i-1,1};
       %disp('hi')
       Areas(i,1) = Areas(i-1,1);
   else
       centroid = stats.Centroid;
       %disp(centroid)
       centroids{i,1} = centroid;
       Areas(i,1) = stats.Area;
   end
   
   %Compute difference from last centroid value and store
   curCent = centroids{i,1}; 
   if i == 1
       lastCent = curCent;
   else
   lastCent = centroids{i-1,1};
   end
   
   diff = curCent - lastCent;
   
   %difference{i,1} = diff;
   %This is still failing all of the time because of masking failures.
   %Might be a good metric to put in a bin to manually segment, etc. 
   dist = sqrt(diff(1)^2 + diff(2)^2);
   if dist > 20
       dist = difference(i-1,1);
       
   end
   difference(i,1) = dist;
end
%Sum up larger time points to get rid of noise, sample every few time
%points

%For Basicplotting
xvals = 1:numel(iMasks);
xvals = xvals.*5;
figure
plot(xvals,data(:,2))
xlabel('Time (Mins)')
ylabel('Strain Energy (fJ)')
title('Strain Energy over Time')
figure
plot(xvals,difference(:))
xlabel('Time (Mins)')
ylabel('Centroid Displacement (pixels)')
title('Centroid Displacement over Time')
figure
plot(xvals,Areas)
xlabel('Time (Mins)')
ylabel('Area (Pixels^2)')
title('Area over Time')

%Correlation statistics, plot each against each other
%disp('Centroid displacement Vs. Strain Energy')
[rho1 pval1] = corr(difference,data(:,2));
figure 
scatter(difference,data(:,2))
xlabel('Centroid Displacement (pixels)')
ylabel('Strain Energy (fJ)')
title('Strain Energy Vs. Centroid Displacement')

hold on
%Plot polyfit of the correlation to look at the general trend
Fit = polyfit(difference,data(:,2),1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
plot(difference,polyval(Fit,difference),'r')

h = line(nan, nan, 'Color', 'none');
legend(h, strcat('Rho =  ',num2str(rho1), '   ', 'Pval =  ', num2str(pval1)), 'Best')




%disp('Centroid displacement Vs. Net Contractile Moment')
[rho2 pval2] = corr(difference,data(:,3));
figure 
scatter(difference,data(:,3))
xlabel('Centroid Displacement (pixels)')
ylabel('Net Contractile Moment (pNm)')
title('Net Contractile Moment Vs. Centroid Displacement')
%disp('Strain Energy Vs. NCM')

hold on
%Plot polyfit of the correlation to look at the general trend
Fit = polyfit(difference,data(:,3),1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
plot(difference,polyval(Fit,difference),'r')

h = line(nan, nan, 'Color', 'none');
legend(h, strcat('Rho =  ',num2str(rho2), '   ', 'Pval =  ', num2str(pval2)), 'Best')

[rho3 pval3] = corr(data(:,2),data(:,3));
figure 
scatter(data(:,2),data(:,3))
xlabel('Strain Energy (fJ)')
ylabel('Net Contractile Moment (pNm)')
title('Net Contractile Moment Vs. Strain Energy')

hold on
%Plot polyfit of the correlation to look at the general trend
Fit = polyfit(data(:,2),data(:,3),1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
plot(data(:,2),polyval(Fit,data(:,2)),'r')

h = line(nan, nan, 'Color', 'none');
legend(h, strcat('Rho =  ',num2str(rho3), '   ', 'Pval =  ', num2str(pval3)), 'Best')


%SED
%Compute Strain Energy Density
SED = data(:,2)./Areas;
figure
plot(xvals,SED)
xlabel('Time (Mins)')
ylabel('Strain Energy Density (fJ/pixel)')
title('Strain Energy Density over Time')



