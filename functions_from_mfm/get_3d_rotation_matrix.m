function [R,Rx,Ry,Rz] = get_3d_rotation_matrix(tilt_x,tilt_y,tilt_z)
% GET_3D_ROTATION_MATRIX Returns the 3-D rotation matrix corresponding to
% rotations (tilts) along the x-, y-, and z-axes.
% 
% Usage:
%  [R,Rx,Ry,Rz] = GET_3D_ROTATION_MATRIX(tilt_x)
%  [R,Rx,Ry,Rz] = GET_3D_ROTATION_MATRIX(tilt_x,tilt_y)
%  [R,Rx,Ry,Rz] = GET_3D_ROTATION_MATRIX(tilt_x,tilt_y,tilt_z)
%
% Args:
%  tilt_x: tilt around the x-axis (radians)
%  tilt_y: tilt around the y-axis (radians)
%  tilt_z: tilt around the z-axis (radians)
% 
% Returns:
%  R: the effective rotation matrix
%  Rx: the rotation matrix caused by rotation around the x-axis
%  Ry: the rotation matrix caused by rotation around the y-axis
%  Rz: the rotation matrix caused by rotation around the z-axis

if nargin < 2
    tilt_y = 0;
end

if nargin < 3
    tilt_z = 0;
end

Rx = [1 0 0; 0 cos(tilt_x) -sin(tilt_x); 0 sin(tilt_x) cos(tilt_x);];
Ry = [cos(tilt_y) 0 sin(tilt_y); 0 1 0; -sin(tilt_y) 0 cos(tilt_y);];
Rz = [cos(tilt_z) -sin(tilt_z) 0; sin(tilt_z) cos(tilt_z) 0; 0 0 1;];

R = Rx * Ry * Rz;
end

