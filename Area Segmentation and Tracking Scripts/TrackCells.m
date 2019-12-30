%%Function that takes input cell array of points and outputs matched cell
%%tracks using MATLAB Simple Tracker (Jean-Yves Tinevez). 
% Input:
%   - Input cell array where each cell contains the xy coordinates of a
%   cells centroid as defined in the Simple Tracker documentation.
% Output:
%   - Outputs the tracks and adjacency tracks as cell arrays which can be
%   used to match up with the coordinates to get the full length tracks.
%   These tracks are plotted as shown below. Further the average velocity
%   on those tracks is outputted as an array for each track. 
%  --Max Hockenberry 12 30 19
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
%%
function [tracks, adjacency_tracks, averagevel] = TrackCells(points)
%TrackCells: Given an input of centroid positions, will recapitulate the 
% tracks using simpletracker
%   points must be matlab cell array object containing xy points in
%   each cell. Output cell array telling you which of your points
%   correspond to which tracks which you can then break down and plot. 

%Settings
max_linking_distance = Inf;
max_gap_closing = Inf;
debug = true;
%Run simpletracker on the provided points
[tracks, adjacency_tracks ] = simpletracker(points,...
    'MaxLinkingDistance', max_linking_distance, ...
    'MaxGapClosing', max_gap_closing, ...
    'Debug', debug);
%loop through results and then plot them based on cell movement. 
n_tracks = numel(tracks);
colors = hsv(n_tracks);

all_points = vertcat(points{:});

averagevel = zeros(numel(n_tracks),1);

for i_track = 1 : n_tracks
   
    % We use the adjacency tracks to retrieve the points coordinates. It
    % saves us a loop.
    
    track = adjacency_tracks{i_track};
    track_points = all_points(track, :);
    
    plot(track_points(:,1), track_points(:, 2), 'Color', colors(i_track, :))
    hold on

    %Average Velocity
    %vel = p(i) - p(i-1)/ (t(i) - t(i-1))
    %assuming time is constant, we can fix the absolute value later
    vel = diff(track_points);
    vel = sqrt(vel(:,1).^2 + vel(:,2).^2);
    avgvel = mean(vel);
    averagevel(i_track) = avgvel;
end

%Calculate whatever we want here from the tracks, FMI, Velocity,
%Persistance, etc. We implementented velocity for demonstration purposes
end