function [rg,az,el] = get_relative_position(loc_1,loc_2)
% GET_RELATIVE_POSITION Returns the relative position
% parameters (range, azimuth, and elevation) between two locations.
%
% Usage:
%  [rg,az,el] = GET_RELATIVE_POSITION(loc_1,loc_2)
%
% Args:
%  loc_1: the first location
%  loc_2: the second location
%
% Returns:
%  rg: the range (in meters) between locations
%  az: the azimuth angle (in radians) between locations
%  el: the elevation angle (in radians) between locations
%
% Note:
%  We are finding the position of loc_2 relative to the
%  the position of loc_1.
%
%  Our convention is that the elevation angle is from the x-y
%  plane, increasing in the +z direction. It extends from -pi/2
%  to pi/2.
%
%  Our convention is that the azimuth angle is from the +y-z
%  plane, increasing toward the +x axis and decreasing toward
%  the -x axis. It extends from -pi to pi.
dxyz = loc_2 - loc_1;
rg = sqrt(sum(dxyz.^2,2));
az = atan2(dxyz(:,1),dxyz(:,2));
dim = size(dxyz); 
%if size(dxyz(1,:)) == 3
if dim(:,2) == 3
    el = atan2(dxyz(:,3),sqrt(dxyz(:,1).^2 + dxyz(:,2).^2));
else
    el = zeros(size(az));
end

end