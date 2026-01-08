classdef beam < handle
    properties
        name; % human-readable identifier
        location; % meters
        location_rot; %rotated_location
        carrier_frequency = 1; % Hz
        propagation_velocity = 1; % meters/sec
        carrier_wavelength; % meters
        wave_number; % rad/meter
        bandwidth; % Hz
        noise_power_spectral_density = 1; % watts/Hz
        noise_power; % watts (integrated over bandwidth)
        transmit_power; % watts
        type; % 'default', 'primary', or 'secondary'
        marker; % used when plotting
        color; % used when plotting
        label; % used mainly when plotting
        
        % ---
        antenna; % antenna object
        array; % array object
        max_gain_dB; 
        %-----
         serving_cell; % ground serving cell idx
         serving_sat; % serving satellite idx
         serving_sat_loc;  %serving satellite location
      % id; 
    end
    methods(Static)
        function obj = create()
            obj = beam();
            obj.initialize();
            if nargin >= 1
                if strcmpi(s,'primary')
                    obj.initialize_primary();
                elseif strcmpi(s,'secondary')
                    obj.initialize_secondary();
                end
            end
        end
    end


    methods
        function obj = beam()
            obj.initialize();
        end
        
        function initialize(obj)
            obj.marker = 'x';
            obj.name = 'device';
            obj.set_propagation_velocity(3e8);
            obj.set_carrier_frequency(20e9);
            obj.set_bandwidth(1);
            obj.set_type('default');
            obj.set_antenna(antenna.create('default'));
            obj.set_array(array.create(64, 64)); 
            %obj.set_location(0,0,0);
            obj.set_service(0,0,[0,0,0]);
        end
        
        function initialize_primary(obj)
            obj.set_type('primary');
        end
        
        function initialize_secondary(obj)
            obj.set_type('secondary');
        end
        
        function set_type(obj,type)
            obj.type = type;
            if strcmpi(type,'primary')
                obj.color = 'r';
                obj.label = 'Incumbent';
            elseif strcmpi(type,'secondary')
                obj.color = 'b';
                obj.label = 'Kuiper';
            else
                obj.color = 'k';
                obj.label = 'Device';
            end
        end
        
        function set_carrier_frequency(obj,fc)
            obj.carrier_frequency = fc;
            obj.carrier_wavelength = obj.propagation_velocity / fc;
            obj.wave_number = 2 * pi / obj.carrier_wavelength;
        end
        
%         function set_location(obj,x,y,z)
%             if nargin < 2 || isempty(x)
%                 x = 0;
%                 y = 0;
%                 z = 0;
%             end
%             if nargin < 3
%                 y = x(2);
%                 z = x(3);
%                 x = x(1);
%             end
%             obj.location = [x,y,z];
%             obj.location_rot = [x,y,z];
%             % translate array object too
%             xyz = [x,y,z] ./ obj.carrier_wavelength;
%             obj.array.translate(xyz(1),xyz(2),xyz(3));
%         end
             
        function set_propagation_velocity(obj,vel)
            obj.propagation_velocity = vel;
            obj.carrier_wavelength = vel / obj.carrier_frequency;
            obj.wave_number = 2 * pi / obj.carrier_wavelength;
        end
        
        function set_bandwidth(obj,B)
            obj.bandwidth = B;
            PSD = obj.noise_power_spectral_density;
            obj.noise_power = PSD * B;
        end
        
        function set_noise_power_spectral_density(obj,PSD)
            obj.noise_power_spectral_density = PSD;
            B = obj.bandwidth;
            obj.noise_power = PSD * B;
        end
        
        function set_antenna(obj,ant)
            obj.antenna = ant;
        end
        
        function set_array(obj,arr)
            obj.array = arr;
        end
        
        function set_steering_direction(obj,az,el)
            obj.antenna.set_steering_direction(az,el); % this line was commented, but don't know why
            v = obj.array.get_array_response(az,el);
            obj.array.set_weights(conj(v));
        end
        
        function G = get_gain(obj,az,el)
            % G = obj.antenna.get_gain(az,el);
            g = obj.array.get_array_gain(az,el);
            G = abs(g).^2;
            G = sqrt(G); % temporary normalization (transmit and receive side)
        end
        
        function [rg,az,el] = get_relative_position(obj,dev)
            % dev is any other device object
            [rg,az,el] = get_relative_position(obj.location,dev.location);
        end

        function set_service(obj, idx_cell, idx_sat, loc)
            % translate array object 
            xyz = loc ./ obj.carrier_wavelength;
            obj.array.translate(xyz(1),xyz(2),xyz(3));
            
            obj.serving_cell = idx_cell; 
            obj.serving_sat = idx_sat; 
            obj.serving_sat_loc = loc; 
        end 
    end
end