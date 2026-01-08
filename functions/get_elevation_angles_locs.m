function sat_elevation = get_elevation_angles_locs(sat_loc, ecef_cell_locations)
    [num_cells, ~] = size(ecef_cell_locations); 
    sat_elevation = zeros(num_cells, 1); 
       
    for idx_cell=1:num_cells
        cell_cnt = ecef_cell_locations(idx_cell,:); 
        sat_elevation(idx_cell) = return_elevation_sats(sat_loc, cell_cnt, cell_cnt, [0,0,0]);
    end
  
end
