

function [ele] = return_elevation_sats(locs1, cnt1, loc2, cnt2)
    % locs1, cnt1 : multiple satellite locs and steering point
    % locs2, cnt2: reference satellite loc and its steering point
%     vec1 = locs1 - cnt1; 
%     vec2 = loc2 - cnt2; 
%     angs = real(acos((vec1 * vec2')./sqrt(sum(vec1'.^2))'./sqrt(sum(vec2'.^2))') * 180/pi); 
% %     indx = find(ang <= angle_separation) ; 
% %     angs = ang(indx);
% %     locs = locs1(indx, :); % returning one or multiple sat loc satisfying the angle separation 
%     ele = 90 - angs; 


     % Ensure cnt1 and cnt2 are row vectors (1x3) if they're passed as column vectors
    if size(cnt1, 2) ~= 3
        cnt1 = cnt1'; % Convert to 1x3
    end
    
    if size(cnt2, 2) ~= 3
        cnt2 = cnt2'; % Convert to 1x3
    end
    
    % Calculate the vectors from the center points to the satellite locations
    vec1 = locs1 - cnt1;  % vec1 is (82x3)
    vec2 = loc2 - cnt2;   % vec2 is (82x3)
    
    % Compute the dot product of each corresponding pair of vectors
    dot_product = sum(vec1 .* vec2, 2);  % Dot product of vectors row-wise (82x1)
    
    % Compute the magnitudes of the vectors
    mag_vec1 = sqrt(sum(vec1.^2, 2));    % Magnitude of vec1 (82x1)
    mag_vec2 = sqrt(sum(vec2.^2, 2));    % Magnitude of vec2 (82x1)
    
    % Compute the angles between the vectors in degrees
    angs = real(acos(dot_product ./ (mag_vec1 .* mag_vec2)) * 180/pi);  % Resulting angles (82x1)
    
    % Compute the elevations
    ele = 90 - angs;  % Convert angle to elevation (82x1)ele
   
end

% function [id_satellites, loc_candidate, inview_angles, sat_id_per_cell, num_sat_per_cell, angles_per_cell] ...
%     = determine_candidate_satellites(loc_satellites, loc_cells, num_cells, elevation )    
%     id_satellites = []; 
%     inview_angles =[]; 
%     %loc_primary = []; 
%     % numer of satellites and corresponding view angles can be different
%     % per cell, however this aspect is not implemented in the simulation
%     % yet. 
%     num_sat_per_cell = []; % num candidate satellites per cell
%     angles_per_cell = []; % inview angles per cell 
% 
%     kappa = 90 - elevation;
% 
%     sat_id_per_cell = []; 
%     for idx_cell = 1: num_cells
%             pc = loc_satellites - loc_cells(idx_cell, :);
%             pe = loc_cells(idx_cell, :);
%             inner = pc *pe'; 
%             denom = sqrt(sum(pc'.^2)'.* sum(pe'.^2)'); 
%             beta = acos(inner ./ denom) * 180/pi; 
%             
%             alpha = acos((pc * pe')./(sqrt(sum(pc'.^2))'.*sqrt(sum(pe'.^2))')) * 180 /pi ; 
%             sat_ids = find(alpha <= kappa); 
%             inview = alpha(sat_ids); 
%     
%             %loc_primary = [loc_primary ; loc_satellites(sat_ids, :)]; 
%             sat_id_per_cell = [sat_id_per_cell;  sat_ids]; 
%             num_sat_per_cell = [num_sat_per_cell; length(sat_ids)]; 
%             angles_per_cell = [angles_per_cell; inview];      
%     end
% 
% 
%     id_satellites=sat_ids(1); %sat_id_per_cell{1}; %cell array containing arrays 
%     id_satellites=union(id_satellites, sat_id_per_cell);
% 
%     inview_angles = angles_per_cell(1); 
%     inview_angles = union(inview_angles, angles_per_cell); 
% 
%   %  num_primary_satellites = length(id_satellites); 
%     loc_candidate = loc_satellites(id_satellites,:); 
% 
% 
% end 
      
