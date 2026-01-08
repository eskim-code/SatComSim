% geographical location and area size of simulation 
austin_lat = 30.2672 + 1; % Austin's latitude
austin_lon = -97.7431; % Austin's longitude
%rng = 0.82; %degree

% ground cell layout 
if mask==true
    cell_radius_km = 12; 
else 
    cell_radius_km = 10; % 8.8; 
end 

cell_radius_lat = cell_radius_km / 110.574;
cell_radius_lon = cell_radius_km / (111.320 * cosd(austin_lat));

% user distribution range and resolution 
% user_resolution = 0.1; 
% rng_d = rng + user_resolution; 
% lat_range = austin_lat + [-rng_d * 0.7, rng_d* 0.7]; 
% lon_range = austin_lon + [-rng_d, rng_d];
num_primary_users_per_cell = 1; %10; 
num_measurement_users_per_cell = num_primary_users_per_cell; 
num_secondary_users_per_cell = num_primary_users_per_cell; 

% satellite minimum elevation angles and other sat. parameters
ang_pele = 40; 
ang_sele = 40; 
num_spot_beams = 127* 3; %  61*2; % 16 ; 
max_sat_size = 60; 
% primary_policy = 'Highest_elevation'; 
% 
% primary_users = cell(num_cells,1);
% secondary_users = cell(num_cells,1);


psat = satellite.create('primary', num_spot_beams);
ksat = satellite.create('secondary', num_spot_beams);

pusr = user.create('primary', 32); 
musr = user.create('primary', 32); 
susr = user.create('secondary', 32); 


%[~, num_tsample, Nk] = size(k_loc); 
%[~, num_tsample, Np] = size(space_loc); 

%primary_satellites_in_view = zeros(num_tsample, max_sat_size); 
%secondary_satellites_in_view = zeros(num_tsample, max_sat_size); 

