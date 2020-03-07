%Matfile Creating Script
%%Script that will take input folder of matfiles of interest and
%%concatenate the data of interest into one matfile.
% Input:
%  - Input folder containing all matfiles and data produced by Danuser code
% Output:
%  - Saves a matfile structure in the working directory with the following 
%  variables: pixel size, image size, number of frames, traction map path, and 
%  displacement map path.
%  --Luca Menozzi 02 29 20
%   
%   Copyright (C) <2020>  <Luca Menozzi>
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
%%
function matfile = organizematdata(file_path)

% dummypath = 'C:\Users\luca1721\Documents\TFM Research\2 5 20 JR20 Parental 8 kPa_16_20.tif'

traction_map_path = '\TFMPackage\displacementField\dispMaps.mat';
displacement_map_path = '\TFMPackage\forceField\tractionMaps.mat';
movie_data_path = '\movieData.mat';

%At this point we probably don't need to load the traction or displacement
%maps and rather just want the filepaths to reference later. --MH 2020

%traction_map = load(strcat(file_path, traction_map_path));
%displacement_map = load(strcat(file_path, displacement_map_path));

movie_data = load(strcat(file_path, movie_data_path));

matfile.pixel_size = movie_data.MD.pixelSize_;
matfile.image_size = movie_data.MD.imSize_;
matfile.number_of_frames = movie_data.MD.nFrames_;
matfile.traction_map_path = strcat(file_path,traction_map_path);
matfile.displacement_map_path = strcat(file_path, displacement_map_path);

save(strcat(file_path,'\PipelineData.mat'), '-struct', 'matfile');
end