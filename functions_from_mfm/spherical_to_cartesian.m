function [x,y,z] = spherical_to_cartesian(r,az,el)
% SPHERICAL_TO_CARTESIAN

x = r .* sin(az) .* cos(el);
y = r .* cos(az) .* cos(el);
z = r .* sin(el);

end

