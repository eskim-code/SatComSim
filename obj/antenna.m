classdef antenna < handle
    properties
        name; % human-readable identifier
        % location; % meters
        carrier_frequency = 1; % Hz
        propagation_velocity = 1; % meters/sec
        carrier_wavelength; % meters
        wave_number; % rad/meter
        type; % 'default' or other string-specifiers
        % marker; % used when plotting
        % color; % used when plotting
        % label; % used mainly when plotting
        steering_direction; % where the antenna is steered toward (az,el) (radians)
    end
    methods(Static)
        function obj = create(s)
            obj = antenna();
            obj.initialize();
            if nargin >= 1
                obj.set_type(s);
            end
        end
    end
    methods
        function obj = antenna()
            obj.initialize();
        end
        
        function initialize(obj)
            obj.name = 'antenna';
            obj.set_propagation_velocity(3e8);
            obj.set_carrier_frequency(28e9);
            obj.set_type('default');
            obj.set_steering_direction(0,0);
        end
                
        function set_type(obj,type)
            obj.type = type;
            if strcmpi(type,'dish-1')
                % pass
            elseif strcmpi(type,'dish-2')
                % pass
            else % default
                % pass
            end
        end
        
        function set_carrier_frequency(obj,fc)
            obj.carrier_frequency = fc;
            obj.carrier_wavelength = obj.propagation_velocity / fc;
            obj.wave_number = 2 * pi / obj.carrier_wavelength;
        end
                     
        function set_propagation_velocity(obj,vel)
            obj.propagation_velocity = vel;
            obj.carrier_wavelength = vel / obj.carrier_frequency;
            obj.wave_number = 2 * pi / obj.carrier_wavelength;
        end
        
        function set_steering_direction(obj,az,el)
            % [az,el] = wrap_theta_phi(az,el);
            obj.steering_direction = [az,el];
        end
        
        function G = get_gain(obj,az,el)
            % [az,el] = wrap_theta_phi(az,el);
            type = obj.type;
            if strcmpi(type,'primary-user')
                G = obj.get_gain_user(az,el);
            elseif strcmpi(type,'secondary-user')
                G = obj.get_gain_user(az,el);
            elseif strcmpi(type,'primary-satellite')
                G = obj.get_gain_default(az,el);
            elseif strcmpi(type,'secondary-satellite')
                G = obj.get_gain_default(az,el);
            else % default
                G = obj.get_gain_default(az,el);
            end
        end
        
        function G = get_gain_default(obj,az,el)
            % assumes a dish physically steered toward some az,el
            sd = obj.steering_direction;
            rel_az = az(:) - sd(1);
            % rel_az = wrapToPi(rel_az); % need to confirm
            rel_el = el(:) - sd(2);
            [x,y,z] = spherical_to_cartesian(1,az,el);
            [u,v,w] = spherical_to_cartesian(1,sd(1),sd(2));
            xyz = [x,y,z];
            uvw = [u,v,w];
            tmp = sum(xyz .* uvw);
            alpha = acos(tmp);
            % rel_el = wrapToPi(rel_el); % need to confirm
            % [rel_az,rel_el] = wrap_theta_phi(rel_az,rel_el);
            a = 0.1 ; % 10 * obj.carrier_wavelength; % dish radius
            % G_az = obj.gain_function_bessel(rel_az,a);
            % G_el = obj.gain_function_bessel(rel_el,a);
            % G = G_az .* G_el;
            G = obj.gain_function_bessel(alpha,a);
        end
        
        function G = gain_function_bessel(obj,theta,a)
            G = zeros(length(theta),1);
            G(theta == 0) = 1;
            k = obj.wave_number;
            tmp = k .* a .* sin(theta(theta ~= 0));
            val = besselj(1,tmp) ./ tmp;
            G(theta ~= 0) = 4 .* abs(val).^2;
        end


%         function g = get_dish_gain_type_01(obj,phi,theta)
%             % 3GPP
%             % theta and phi are -pi/2 to pi/2, 0 is broadside
%             theta = theta(:);
%             phi = phi(:);
%             if length(theta) == length(phi)
%                 N = length(theta);
%             else
%                 error('Theta and phi must be same length');
%             end 
%             
%             k = obj.wave_number;
%             a = obj.radius;
%             val = k .* a .* sin(theta(theta ~= 0));
%             order = 1;
%             v = ones(N,1);
%             v(theta ~= 0) = 2 .* besselj(order,val) ./ val;
%             g_theta = abs(v).^2;
%             v = ones(N,1);
%             val = k .* a .* sin(phi(phi ~= 0));
%             v(phi ~= 0) = 2 .* besselj(order,val) ./ val;
%             g_phi = abs(v).^2;
%             %g = g_theta .* g_phi; % confirm
%             g = g_theta*g_phi;
%         end
% 


        function G = get_gain_user(obj,az,el)
            max_gain_dB = 0; % max gain
            sll_dB = -20; % side lobe suppression (relative to max gain)
            bw_az = deg2rad(30);
            bw_el = deg2rad(30);
            sd = obj.steering_direction;
            rel_az = az(:) - sd(1);
            rel_el = el(:) - sd(2);
            idx_main = (abs(rel_az) <= bw_az/2) & (abs(rel_el) <= bw_el/2);
            G_dB(idx_main) = max_gain_dB;
            G_dB(~idx_main) = max_gain_dB + sll_dB;
            G = dB2pow(G_dB);
        end
    end
end