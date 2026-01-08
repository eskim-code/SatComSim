% To obtain constellation with the lowest altitude by changing the number
% of Kuiper satellites 
% Total number of Kuiper satellites: 
% num_satellites = [560 672 784 896 1008]

% larger time scale : sampleTime 20sec, duration 48 hours
% smaller time scale : sampleTime 1sec, duration 30 min
clearvars;

startTime = datetime(2023,1,1); 
startTime = startTime + hours(21) ; 
stopTime = startTime + minutes(10); % days(2); % minutes(10); % hours(48); 
sampleTime = 60; % sample 0.5ms,   sample every 10 sec % seconds
sc = satelliteScenario(startTime, stopTime, sampleTime); 

% Kuiper constellation 
% Kuiper constellation has three shells with three different altitudes
% Altitude (Km) Inclination(deg)  #planes  #sat/plane  #sat 
%     630           51.9            34      34         1156
%     610           42              36      36         1296 
%     590           33              28      28         784
%
radius_earth = 6371e3; 


% % num_satellites_set1 = kuiper1_num_planes.* num_sat_plane1(1) + num_
% 
% Kuiper shell 1 
kuiper1_altitude = 630e3; 
kuiper1_radius = radius_earth + kuiper1_altitude; 
kuiper1_inclination = 51.9 ; 
kuiper1_num_satellites = 1156; 
kuiper1_num_planes = 34; 
% 
% 
% Kuiper shell 2
kuiper2_altitude = 610e3; 
kuiper2_radius = radius_earth + kuiper2_altitude; 
kuiper2_inclination = 42; 
kuiper2_num_satellites = 1296; 
kuiper2_num_planes = 36; 
% 
% Kuiper shell 3 
kuiper3_altitude = 590e3; 
kuiper3_radius = radius_earth + kuiper3_altitude; 
kuiper3_inclination = 33; 
kuiper3_num_satellites = 784; 
kuiper3_num_planes = 28 ; 


% SpaceX shell 1
spacex1_altitude = 540e3; 
spacex1_radius = radius_earth + spacex1_altitude; 
spacex1_inclination = 53.2 ; 
spacex1_num_satellites = 1584; 
spacex1_num_planes = 72; 



% SpaceX shell 2
spacex2_altitude = 550e3; 
spacex2_radius = radius_earth + spacex2_altitude; 
spacex2_inclination = 53 ; 
spacex2_num_satellites = 1584; 
spacex2_num_planes = 72; 




% SpaceX shell 3
spacex3_altitude = 560e3; 
spacex3_radius = radius_earth + spacex3_altitude; 
spacex3_inclination = 97.6; 
spacex3_num_satellites = 520; 
spacex3_num_planes = 10; 

% SpaceX shell 4
spacex4_altitude = 570e3; 
spacex4_radius = radius_earth + spacex4_altitude; 
spacex4_inclination = 70; 
spacex4_num_satellites = 720; 
spacex4_num_planes = 36; 



% Launch Kuiper satellites 
sat_s1 = walkerDelta(sc,kuiper1_radius, kuiper1_inclination, kuiper1_num_satellites, kuiper1_num_planes, 1); 
sat_s2 = walkerDelta(sc,kuiper2_radius, kuiper2_inclination, kuiper2_num_satellites, kuiper2_num_planes, 1);
sat_s3 = walkerDelta(sc,kuiper3_radius, kuiper3_inclination, kuiper3_num_satellites, kuiper3_num_planes, 1); 



% 
% Launch SpaceX satellites 
sat_p1 = walkerDelta(sc,spacex1_radius, spacex1_inclination, spacex1_num_satellites, spacex1_num_planes, 1); 
sat_p2 = walkerDelta(sc,spacex2_radius, spacex2_inclination, spacex2_num_satellites, spacex2_num_planes, 1);
sat_p3 = walkerDelta(sc,spacex3_radius, spacex3_inclination, spacex3_num_satellites, spacex3_num_planes, 1);
sat_p4 = walkerDelta(sc,spacex4_radius, spacex4_inclination, spacex4_num_satellites, spacex4_num_planes, 1);

sat_s1.MarkerColor = [1,0,0]; 
sat_s2.MarkerColor = [1,0,0]; 
sat_s3.MarkerColor = [1,0,0]; 

sat_s1.MarkerSize =4;
sat_s2.MarkerSize =4; 
sat_s3.MarkerSize =4; 

sat_p1.MarkerColor = [0,1,0];
sat_p2.MarkerColor = [0,1,0];
sat_p3.MarkerColor = [0,1,0];
sat_p4.MarkerColor = [0,1,0];

sat_p1.MarkerSize =4; 
sat_p2.MarkerSize =4; 
sat_p3.MarkerSize =4; 
sat_p4.MarkerSize = 4; 

viewer3D = satelliteScenarioViewer(sc, 'ShowDetails', false); 

