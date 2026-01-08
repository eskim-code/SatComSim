classdef satellite < device
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
        child; % user object this satellite is serving

    end
    methods(Static)
        function obj = create(s,Nbeam)
            obj = satellite();
            if nargin >= 1
                if strcmpi(s,'primary')
                    obj.initialize_primary_satellite(Nbeam);
                elseif strcmpi(s,'secondary')
                    obj.initialize_secondary_satellite(Nbeam);
                end
            end
        end
    end
    methods
        function obj = satellite()
%              obj.nbeams=Nbeam;
%             for i=1:Nbeam
%                 obj.beam{i}=beam(); 
%             end
            obj.initialize();
            obj.initialize_satellite();
            obj.marker = 'o'; % for satellites
            obj.name = 'satellite';
        end
        
        function initialize_satellite(obj)
            % initialization that is specific to satellite not covered by device
        end
        
        function initialize_primary_satellite(obj, Nbeam)
            obj.nbeams=Nbeam;
            for i=1:Nbeam
                obj.beam{i}=beam(); 
            end

            obj.initialize_primary(); % inherited
            obj.set_type_satellite('primary');
        end
        
        function initialize_secondary_satellite(obj, Nbeam)
            obj.nbeams=Nbeam;
            for i=1:Nbeam
                obj.beam{i}=beam(); 
            end
            obj.initialize_secondary(); % inherited
            obj.set_type_satellite('secondary');
        end

        function set_type_satellite(obj,s)
            % actions to take when setting satellite type not covered by device
            obj.set_type(s); % inherited
            if strcmpi(s,'primary')
                % pass
            elseif strcmpi(s,'secondary')
                % pass
            end
        end
    end
end