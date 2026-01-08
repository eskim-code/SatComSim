function [u,v,w] = rotate_cartesian_point(x,y,z,tilt_x,tilt_y,tilt_z)
% ROTATE_CARTESIAN_POINT Returns a point in Cartesian space after having
% undergone some rotation (tilt) along the x-, y-, and z-axes.
%
% Usage:
%  u = ROTATE_CARTESIAN_POINT(x,y,z,tilt_x,tilt_y,tilt_z) Returns the
%  rotated point as a 3-element column vector.
%
%  [u,v,w] = ROTATE_CARTESIAN_POINT(x,y,z,tilt_x,tilt_y,tilt_z) Returns the
%  rotated point as three coordinates (x,y,z).
%
% Args:
%  x: the x coordinate of the original point in 3-D Cartesian space
%  y: the y coordinate of the original point in 3-D Cartesian space
%  z: the z coordinate of the original point in 3-D Cartesian space
%  tilt_x: tilt around the x-axis (radians)
%  tilt_y: tilt around the y-axis (radians)
%  tilt_z: tilt around the z-axis (radians)
% 
% Returns:
%  u: the x coordinate of the rotated point
%  v: the y coordinate of the rotated point
%  w: the z coordinate of the rotated point

t = [x; y; z;];
R = get_3d_rotation_matrix(tilt_x,tilt_y,tilt_z);
u = R * t;

if nargout == 2
    v = u(2);
    u = u(1);
end

if nargout == 3
    v = u(2);
    w = u(3);
    u = u(1);
end

return
