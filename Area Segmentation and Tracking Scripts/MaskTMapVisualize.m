%Visualize masked traction maps. Basic approach to visualize Danuser code
%traction maps without using their GUI. Can prove useful on slower (most)
%machines. 


maskedTMap = cell(numel(dMap),1);
for i = 1:numel(dMap)
    curMask = iMasks{i,1};
    SE = strel('diamond',50); 
    curMask = imdilate(curMask,SE);
    maskedTMap{i,1} = tMap{1,i}.*curMask;
    filename = convertStringsToChars(convertCharsToStrings('C:\Users\Max\Desktop\test\') + num2str(i) + '.tif');
    imwrite(mat2gray(maskedTMap{i,1}), filename)
    
end

imagesc(maskedTMap{1,1})