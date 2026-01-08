function [Gtx, Grx, L, rsrp] = get_beamformed_path_loss_01(satellite,beam_idx, user) %, max_gain, noise_power)

    [~,th,ph] = get_relative_position(satellite.location, user.location);
  
    Gtx = satellite.beam{beam_idx}.get_gain(th,ph);% 

    [~, th, ph] = get_relative_position(user.location, satellite.location); 
    Grx = user.beam.get_gain(th,ph); % 
    
    L = get_path_loss(satellite, user); 
    rsrp = Gtx .* Grx ./ L; 
end 


%         %%%%%%
%         delta = [-45:0.1:45];
%         delta = delta.* pi/180; 
% 
%         N = length(delta); 
%         list_az_g = []; 
%         list_el_g = []; 
% 
%         az_delta = th + delta;
%         el_delta = ph +delta; 
%         for i=1:N
%             tmp_az = az_delta(i); 
%             tmp_el =el_delta(i);
%              tmp_az_g = satellite.get_gain(tmp_az, ph); 
%              tmp_el_g = satellite.get_gain(th, tmp_el); 
%            % tmp_az_g = user.get_gain(tmp_az, ph); 
%            % tmp_el_g = user.get_gain(th, tmp_el); 
%             list_az_g = [list_az_g tmp_az_g]; 
%             list_el_g = [list_el_g tmp_el_g]; 
%         end
% 
%         figure(1)
%         plot(az_delta * 180/pi, 10*log10(list_az_g/4096)); 
% 
%         figure(2)
%         plot(el_delta * 180/pi, 10*log10(list_el_g/4096)); 
        


        %plot(el_delta * 180/pi, 10 *log10(list_g/4096));




% %         %%%%%%
%         delta = [-45:0.1:45];
%         delta = delta.* pi/180; 
% 
%         N = length(delta); 
%         list_az_g = []; 
%         list_el_g = []; 
% 
%         az_delta = th + delta;
%         el_delta = ph +delta; 
%         for i=1:N
%             tmp_az = az_delta(i); 
%             tmp_el =el_delta(i);
% %             tmp_az_g = satellite.get_gain(tmp_az, ph); 
% %             tmp_el_g = satellite.get_gain(th, tmp_el); 
%             tmp_az_g = user.get_gain(tmp_az, ph); 
%             tmp_el_g = user.get_gain(th, tmp_el); 
%             list_az_g = [list_az_g tmp_az_g]; 
%             list_el_g = [list_el_g tmp_el_g]; 
%         end
% 
%         figure(1)
%         plot(az_delta * 180/pi, 10*log10(list_az_g/1024)); 
% 
%         figure(2)
%         plot(el_delta * 180/pi, 10*log10(list_el_g/1024)); 
        


        %plot(el_delta * 180/pi, 10 *log10(list_g/4096));

