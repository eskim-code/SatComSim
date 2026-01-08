
function cell_locs = hexagon_deployment(lat, lon, range, cell_radius_km)
% hexagon_deployment(latitude, longitude, range, cell_radius_km)
% Define the center of Austin, Texas (latitude and longitude)
% austin_lat = 30.2672; % Austin's latitude
% austin_lon = -97.7431; % Austin's longitude

% Define the radius of each hexagon cell in kilometers
% cell_radius_km = 10;

% Convert cell radius to degrees
    cell_radius_lat = cell_radius_km / 110.574;
    cell_radius_lon = cell_radius_km / (111.320 * cosd(lat));
    
    hex_width = sqrt(3)* cell_radius_lat; % Width is sqrt(3) times the radius in latitude
    hex_height = sqrt(3) * cell_radius_lon; % Height is twice the radius in longitude
    
    % Distance between centers of hexagons (vertically and horizontally)
    vertical_spacing = 1.5 * cell_radius_lat;
    horizontal_spacing = 1.5 * cell_radius_lon;
    
    % Define the range of the grid (to cover a wider area around Austin)
    lat_range = lat + [-range*0.7 , range*0.7 ]; % larger range for demonstration
    lon_range = lon + [-range, range]; % larger range for demonstration
    
    lat_centers = (lat_range(1):vertical_spacing:lat_range(2))';
    lon_centers = (lon_range(1):horizontal_spacing:lon_range(2))';
    
    
    % Offset every other column to create a hexagonal pattern
    [lon_grid, lat_grid] = meshgrid(lon_centers, lat_centers);
    lon_grid(2:2:end, :) = lon_grid(2:2:end, :) + hex_width / 2;
 
     
    % Flatten the matrices
    lat_centers_vector = reshape(lat_grid, [], 1);
    lon_centers_vector = reshape(lon_grid, [], 1);
    
    % Function to calculate hexagon vertices
    hexagon = @(x, y, size) [cosd(0:60:360)' * size + x, sind(0:60:360)' * size + y];
   
    % Initialize arrays for vertices
    all_lats = [];
    all_lons = [];
    
    % Calculate vertices for all hexagons
    for i = 1:numel(lat_centers_vector)
        vertices = hexagon(lat_centers_vector(i), lon_centers_vector(i), cell_radius_lat);
        all_lats = [all_lats; vertices(:,1); NaN]; % NaN to separate polygons
        all_lons = [all_lons; vertices(:,2); NaN];
    end
    
    % Plotting figure;
    %ax = geoaxes; 
    plot_map = false; 
    
     if plot_map 
        figure
        geoplot( all_lats, all_lons, 'b-', 'LineWidth', 0.2);
        ax.Scalebar.Visible = 'off';
    %     width = 600; 
    %     height = 700; 
    % 
    %     set(gcf, 'Position', [100, 100, width, height]);
    
      %  geobasemap('streets'); % Set the basemap for context
        title('Hexagonal Grid');
     end
   


    cell_locs = [lat_centers_vector, lon_centers_vector]; 


end
