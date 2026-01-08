classdef user < device
    properties
        % Inherited:
        % location; % meters
        % carrier_frequency; % Hz
        % propagation_velocity; % meters/sec
        % carrier_wavelength; % meters
        % wave_number; % rad/meter
        % type; % 'default', 'primary', or 'secondary'
        % marker; % used when plotting
        % --------------------------------------------------
        parent; % satellite serving this user
        serving_cell; 
        serving_satellite; 
    end
    methods(Static)
        function obj = create(s, N)
            obj = user();
            if nargin >= 1
                if strcmpi(s,'primary')
                    obj.initialize_primary_user(N);
                elseif strcmpi(s,'secondary')
                    obj.initialize_secondary_user(N);
                end
            end
        end
    end
    methods
        function obj = user()
            obj.initialize();
            obj.initialize_user();
            obj.beam = beam(); % single rx beam at a user 
            obj.marker = '+'; % for users
            obj.name = 'user';
        end
        
        function initialize_user(obj)
            % initialization that is specific to user not covered by device
        end
        
        function initialize_primary_user(obj, N)
            obj.initialize_primary(); % inherited
            obj.set_type_user('primary', N);
        end
        
        function initialize_secondary_user(obj,N)
            obj.initialize_secondary(); % inherited
            obj.set_type_user('secondary',N);
        end

        function set_type_user(obj,s, N)
            % actions to take when setting user type not covered by device
            obj.set_type(s); % inherited
            if strcmpi(s,'primary')
                obj.beam.antenna.set_type('primary-user');
                obj.beam.set_array(array.create(N,N)); %(8,8)
                obj.color = 'r';
            elseif strcmpi(s,'secondary')
                obj.beam.antenna.set_type('secondary-user');
                obj.beam.set_array(array.create(N,N));
                obj.color = 'b';
            end
        end
    end
end