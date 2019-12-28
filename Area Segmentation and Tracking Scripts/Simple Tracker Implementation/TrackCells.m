function [tracks, adjacency_tracks] = TrackCells(points)
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


%[tracks, adjacency_tracks] = simpletracker(points);
[tracks, adjacency_tracks ] = simpletracker(points,...
    'MaxLinkingDistance', max_linking_distance, ...
    'MaxGapClosing', max_gap_closing, ...
    'Debug', debug);
%loop through results and then plot them based on cell movement. 
n_tracks = numel(tracks);
colors = hsv(n_tracks);

all_points = vertcat(points{:});
%display(all_points)
for i_track = 1 : n_tracks
   
    % We use the adjacency tracks to retrieve the points coordinates. It
    % saves us a loop.
    
    track = adjacency_tracks{i_track};
    %display(track)
    track_points = all_points(track, :);
    %display(track_points)
    
    plot(track_points(:,1), track_points(:, 2), 'Color', colors(i_track, :))
    hold on
    %How do we want to visualize a plot? overlay with the cell images?
end

%Calculate whatever we want here from the tracks, FMI, Velocity,
%Persistance, etc. Lets implement velocity for demonstration purposes
end