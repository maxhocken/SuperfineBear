%'I:\Dropbox\SuperfineBear Lab\Raw data\ARP23 tests\012820 2kPa Arp23 Parental\Processed Data';

function [] = computeCorrelationStatistics(folderPath)
%computeCorrelationStatistics computes population statistics of folder
%containing folders of processed TF data
%   %Want to look into population correlation statistics. 

    %Input: Folder of images for analysis

    %Output: csv containing the pvals and rho vals of the pearson coefficients

    directories = GetSubDirsFirstLevelOnly(folderPath);
    %loop through directories, compute the Correlations and store them in a
    %cell to write to csv
    exportData = cell(numel(directories)+1,6);
    
    
    dataHeader = {'CentroidDisp vs. Strain Energy rho', 'CentroidDisp vs. Strain Energy pval', 'CentroidDisp vs. NCM rho', 'CentroidDisp vs. NCM pval', 'Strain Energy Vs. NCM rho', 'Strain Energy Vs. NCM pval'};
    
    for l = 1:numel(dataHeader)
       exportData{1,l} = dataHeader{l}; 
    end
    
    for i = 1:numel(directories)
       %disp(directories(i)) 
       curFolder = strcat(folderPath,'\',directories(i));
       curFolder = curFolder{1,1};
       %disp(strcat(curFolder,'\iMasks.mat'))
       load(strcat(curFolder,'\iMasks.mat'))
       data = csvread(strcat(curFolder,'\compiledData.csv'));
       centroids = cell(numel(iMasks),1);
       difference = zeros(numel(iMasks),1);
       Areas = zeros(numel(iMasks),1);
    
        for j = 1:numel(iMasks)
           curMask = iMasks{j,1}; 
           stats = regionprops(curMask);

           if isempty(stats) == 1
               %use old value for centroid if the mask fails
               centroids{j,1} = centroids{j-1,1};
               %disp('hi')
               Areas(j,1) = Areas(j-1,1);
           else
               centroid = stats.Centroid;
               %disp(centroid)
               centroids{j,1} = centroid;
               Areas(j,1) = stats.Area;
           end

           %Compute difference from last centroid value and store
           curCent = centroids{j,1}; 
           if j == 1
               lastCent = curCent;
           else
           lastCent = centroids{j-1,1};
           end

           diff = curCent - lastCent;

           %difference{i,1} = diff;
           %This is still failing all of the time because of masking failures.
           %Might be a good metric to put in a bin to manually segment, etc. 
           dist = sqrt(diff(1)^2 + diff(2)^2);
           if dist > 20
               dist = difference(j-1,1);

           end
           difference(j,1) = dist;
        end
        
        
        %SED
        %Compute Strain Energy Density
        SED = data(:,2)./Areas;
       
        %Compute correlation parameters
        [rho1, pval1] = corr(difference,data(:,2));
        
        [rho2, pval2] = corr(difference,data(:,3));
        
        [rho3, pval3] = corr(data(:,2),data(:,3));
        
        data2Export = {rho1, pval1, rho2, pval2, rho3,pval3};
        for k = 1:numel(data2Export)
           exportData{i+1,k} = data2Export{k}; 
            
        end
        %exportData{i,:} = [data2Export];
        %csvwrite(strcat(folderPath,'\Correlations.csv'),exportdata);
    end
    
    %Merge cell arrays and export as xlsx
    
    
    output_matrix = exportData;%[{' '} dataHeader exportData];     %Join cell arrays
    xlswrite(strcat(folderPath,'\Correlations.xls'),output_matrix);     %Write data and header
    
    
end