function [lla_cell_loc, ecef_cell_locations, total_cells_band, cell_segment]...
    = ground_cell_deployment(austin_lat, austin_lon, cell_radius_km, frf_factor)
    
    test = false; 
    if cell_radius_km==12
        range = 3.2156; 
        %range = 0.82; 
    elseif cell_radius_km==10
        range = 2.65; % 4; % 2.65; %2.35; % 3.2156; 2.65, % 2.605;
    end
   
    [lla_cell_loc, ecef_cell_locations] = get_ecef_cell_locations(austin_lat, austin_lon, range, cell_radius_km);

    
    tmp_lat = lla_cell_loc(:,1); 
    tmp_lon = lla_cell_loc(:,2); 

    num_lat = length(unique(tmp_lat)); 
    num_lon = length(unique(tmp_lon))/2; 
    [total_cells_band, cell_segment] = cell_ids_by_frequency_reuse(num_lat, num_lon, frf_factor);
    
   
%% test purpose 

    plot_cells =  false; 
    colors = get_plot_colors_simple(100);

    if plot_cells 
        %run('cell_grouping.m');
        [cell_priorities, cell_centers] = cell_grouping('ra'); %'2a', '2b', '4a', '4b', '8a', '8b', '16a'
        [num_priority_groups,~] = size(cell_priorities);
        hexagon_deployment(austin_lat, austin_lon, range,  cell_radius_km); % total 924 cells 


        for idx_priority= 1: num_priority_groups
            cell_list = cell_priorities(idx_priority, :); 
            cell_list = cell_list(cell_list(:)>0);
            dot_colors = []; 
            dot_size = []; 
            dot_size(1:num_cells) = 40; 
            dot_colors = repmat(colors(idx_priority+1,:), num_cells,1);
            hold on; 
             geoscatter(lla_cell_loc(cell_list,1), lla_cell_loc(cell_list,2), dot_size, 'filled');         
              
            center_id = cell_centers(idx_priority); 
             center_loc = lla_cell_loc(center_id, :); 
            text(center_loc(1), center_loc(2),num2str(idx_priority), 'FontSize',20); 
        end

    end

    plot_association_check = false;
    if plot_association_check 
        rnd_idx = randi(301);
        pa = primary_cell_sat_association(rnd_idx,:); 
        color_list = unique(pa); 
    
        for i=1:952
            for j=1:length(color_list)
                if pa(i)== color_list(j)
                color_idx = j;
                end
            end
        
            dot_colors = []; 
           % dot_colors = repmat(colors(color_idx,:),1,1);
             dot_colors = repmat(colors(randi([1,24],1),:),1,1);
            dot_size = 40; 
    
            hold on; 
            geoscatter(lla_cell_loc(i,1), lla_cell_loc(i,2), dot_size, dot_colors, 'filled');               
    
        end
    end 


    plot_frf_cells = false;
    if plot_frf_cells
       hexagon_deployment(austin_lat, austin_lon, range, cell_radius_km);
       f1 = seg1; 
       num = length(f1); 
     
       
       dot_colors = []; 
       dot_size = []; 
       dot_colors = zeros(num,3); 
       dot_colors(:,3) = 1; 
       dot_size(1:num) = 30; 
       geoscatter(lla_cell_loc(f1,1), lla_cell_loc(f1,2), 'x'); % dot_size, dot_colors, 'filled');

       [num,~] =size(lla_cell_loc);
       for i=1:num
          x = lla_cell_loc(i,:);
          text(x(1), x(2),num2str(i), 'FontSize',6);
       end
    
       hold off; 
       
   end
    
 
end
