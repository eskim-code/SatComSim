function [lla_cell_loc, ecef_cell_locations]=get_ecef_cell_locations(latitude, longitude, range, cell_radius_km)

cell_locations = hexagon_deployment(latitude, longitude, range, cell_radius_km); % total 924 cells 


[num_cells,~] = size(cell_locations);

altitude = zeros(num_cells,1); 
lla_cell_loc = cat(2, cell_locations,altitude);
ecef_cell_locations = lla2ecef(lla_cell_loc); 



end

% num_fband = 3; 
% cells_per_fband = zeros(num_fband, ceil(num_primary_cells/num_fband)); 
% cells_per_fband(1,:) = [1,3,5,7,9,11,13,15,17,19,21,34,36,38, 40,42,44,46,48,50,52,54,67,69,71,73,75,77,79,81,83,85,87];
% cells_per_fband(2,:) = [2,4,6,8,10,23,25,27,29,31,33,35,37,39,41,43,56,58,60,62,64,66,68,70,72,74,76,89,91,93,95,97,99];
% cells_per_fband(3,:) =[12,14,16,18,20,22,24,26,28,30,32,45,47,49,51,53,55,57,59,61,63,65,78,80,82,84,86,88,90,92,94,96,98];
% 
% [~,num_primary_cells_per_band] = size(cells_per_fband);
% num_secondary_cells_per_band = num_primary_cells_per_band; 
% 
