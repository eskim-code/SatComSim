% To obtain constellation with the lowest altitude by changing the number
% of Kuiper satellites 
% Total number of Kuiper satellites: 
% num_satellites = [560 672 784 896 1008]

% larger time scale : sampleTime 20sec, duration 48 hours
% smaller time scale : sampleTime 1sec, duration 30 min
clearvars;

startTime = datetime(2024,1,1); 
startTime = startTime + hours(20); % + minutes(30); 
stopTime = startTime + hours(1); % days(2); % minutes(10); % hours(48); 
sampleTime = 60; % 1 ms, sample 0.5ms,   sample every 10 sec % seconds
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

spacex5_altitude = 530e3; 
spacex5_radius = radius_earth + spacex5_altitude; 
spacex5_inclination = 43; 
spacex5_num_satellites = 2492; 
spacex5_num_planes = 28;



% Launch Kuiper satellites 
sat_s1 = walkerDelta(sc,kuiper1_radius, kuiper1_inclination, kuiper1_num_satellites, kuiper1_num_planes, 1); %630 km
sat_s2 = walkerDelta(sc,kuiper2_radius, kuiper2_inclination, kuiper2_num_satellites, kuiper2_num_planes, 1); %610 km
sat_s3 = walkerDelta(sc,kuiper3_radius, kuiper3_inclination, kuiper3_num_satellites, kuiper3_num_planes, 1); %590 km


k_loc1 = states(sat_s1, 'CoordinateFrame', 'ecef');
k_loc2 = states(sat_s2, 'CoordinateFrame', 'ecef');
k_loc3 = states(sat_s3, 'CoordinateFrame', 'ecef');

k_loc = cat(3, k_loc1, k_loc2, k_loc3);  
% save('kuiper_20.mat', 'k_loc'); 
% save('kuiper_20_1.mat', 'k_loc'); 
save('kuiper_1s_10m.mat', 'k_loc');

%save('kuiper_nsample.mat', 'k_loc'); 



sc = satelliteScenario(startTime, stopTime, sampleTime); 

% 
% Launch SpaceX satellites 
sat_p1 = walkerDelta(sc,spacex1_radius, spacex1_inclination, spacex1_num_satellites, spacex1_num_planes, 1); 
sat_p2 = walkerDelta(sc,spacex2_radius, spacex2_inclination, spacex2_num_satellites, spacex2_num_planes, 1);
sat_p3 = walkerDelta(sc,spacex3_radius, spacex3_inclination, spacex3_num_satellites, spacex3_num_planes, 1);
sat_p4 = walkerDelta(sc,spacex4_radius, spacex4_inclination, spacex4_num_satellites, spacex4_num_planes, 1);
sat_p5 = walkerDelta(sc,spacex5_radius, spacex5_inclination, spacex5_num_satellites, spacex5_num_planes, 1);

p1 = states(sat_p1, 'CoordinateFrame', 'ecef'); 
p2 = states(sat_p2, 'CoordinateFrame', 'ecef'); 
p3 = states(sat_p3, 'CoordinateFrame', 'ecef'); 
p4 = states(sat_p4, 'CoordinateFrame', 'ecef'); 
p5 = states(sat_p5, 'CoordinateFrame', 'ecef'); 

% 

space_loc = cat(3, p1, p2, p3, p4, p5); 
%save('spacex_loc.mat', 'space_loc');
save('spacex_1s_10m.mat', 'space_loc');
% % 

% 
% % Launch SpaceX satellites 
% sat_p1 = walkerDelta(sc,spacex1_radius, spacex1_inclination, spacex1_num_satellites, spacex1_num_planes, 1); %540 km
% sat_p2 = walkerDelta(sc,spacex2_radius, spacex2_inclination, spacex2_num_satellites, spacex2_num_planes, 1); %550 km 
% sat_p3 = walkerDelta(sc,spacex3_radius, spacex3_inclination, spacex3_num_satellites, spacex3_num_planes, 1); %560 km
% sat_p4 = walkerDelta(sc,spacex4_radius, spacex4_inclination, spacex4_num_satellites, spacex4_num_planes, 1); %570 km

%% This is for visualization 

% sat_s1.MarkerColor = [1,0,0]; 
% sat_s2.MarkerColor = [1,0,0]; 
% sat_s3.MarkerColor = [1,0,0]; 
% 
% sat_s1.MarkerSize =4;
% sat_s2.MarkerSize =4; 
% sat_s3.MarkerSize =4; 
% 
% sat_p1.MarkerColor = [0,1,0];
% sat_p2.MarkerColor = [0,1,0];
% sat_p3.MarkerColor = [0,1,0];
% sat_p4.MarkerColor = [0,1,0];
% 
% sat_p1.MarkerSize =4; 
% sat_p2.MarkerSize =4; 
% sat_p3.MarkerSize =4; 
% sat_p4.MarkerSize = 4; 
% 
% viewer3D = satelliteScenarioViewer(sc, 'ShowDetails', false); 
% 
% 
% 
% for i=1:3236
%     ss = sc.Satellites(i); 
%     ss.Orbit.LineWidth=1;
%     ss.Orbit.LineColor = [0,0,1]; 
%     ss.Orbit.VisibilityMode = 'manual';
% end
% 
% viewer3D1 = satelliteScenarioViewer(sc, 'ShowDetails', false); 
% sat_s1.MarkerColor = [1,0,1]; 
% sat_s2.MarkerColor = [1,0,1]; 
% sat_s3.MarkerColor = [1,0,1]; 
% 
% sat_s1.MarkerSize =4;
% sat_s2.MarkerSize =4; 
% sat_s3.MarkerSize =4; 
% 


% % kuiper3_num_satellites_per_plane = [20, 24, 28, 32, 36]; 
% % num_satellites = [560 672 784 896 1008]
% num_satellites1 = 560; 
% num_satellites2 = 672; 
% num_satellites3 = 784; 
% num_satellites4 = 896; 
% num_satellites5 = 1008; 
% 
% sc1 = walkerDelta(sc, kuiper3_radius, kuiper3_inclination, num_satellites1, kuiper3_num_planes, 1); 
% sc2 = walkerDelta(sc, kuiper3_radius, kuiper3_inclination, num_satellites2, kuiper3_num_planes, 1); 
% sc3 = walkerDelta(sc, kuiper3_radius, kuiper3_inclination, num_satellites3, kuiper3_num_planes, 1); 
% sc4 = walkerDelta(sc, kuiper3_radius, kuiper3_inclination, num_satellites4, kuiper3_num_planes, 1); 
% sc5 = walkerDelta(sc, kuiper3_radius, kuiper3_inclination, num_satellites5, kuiper3_num_planes, 1); 
% 



%  
% 
% % Obtain position of satellites
% % pos = states(sat) returns a 3-by-n-by-m array of the position history
% % samples, n is the number of time samples and m is the numer of satellites
% % 
% 
% k_loc1 = states(sat_s1, 'CoordinateFrame', 'ecef');
% %save('kuiper_nsample_loc1.mat', 'k_loc1'); 
% 
% k_loc_s2 = states(sat_s2, 'CoordinateFrame', 'ecef');
% %k_loc2 =cat(3, k_loc1, k_loc_s2);
% %save('kuiper_nsample_loc2.mat', 'k_loc2'); 
% 
% k_loc_s3 = states(sat_s3, 'CoordinateFrame', 'ecef');
% %k_loc3 = cat(3, k_loc2, k_loc_s3); 
% k_loc = cat(3, k_loc1, k_loc2, k_loc3);  
% 
% save('kuiper_nsample.mat', 'k_loc'); 
% % k_loc3 = k_loc; 
% % 
% k_loc = cat(3, k_loc1, k_loc2, k_loc3 ); 
% %k_loc = cat(3, k_loc, sec_pos3); 
% save('kuiper_loc_nsample.mat', 'k_loc'); 
% 




% 
% xx =[]; 
% yy =[]; 
% zz =[]; 
% 
% for i=1:kuiper1_num_satellites
%     x = sec_pos1(1, 1, i); 
%     y = sec_pos1(2, 1, i);
%     z = sec_pos1(3, 1, i);
%     xx = [x; xx];
%     yy = [y; yy];
%     zz = [z; zz]; 
% end 
% s_loc1 = [xx yy zz];
% save('kuiper1_loc.mat', 's_loc1');
% 
% sec_pos2 = states(sat_s2, 'CoordinateFrame', 'ecef');
% 
% xx =[]; 
% yy =[]; 
% zz =[]; 
% 
% for i=1:kuiper2_num_satellites
%     x = sec_pos2(1, 1, i); 
%     y = sec_pos2(2, 1, i);
%     z = sec_pos2(3, 1, i);
%     xx = [x; xx];
%     yy = [y; yy];
%     zz = [z; zz]; 
% end 
% s_loc2 = [ xx yy zz];
% save('kuiper2_loc.mat', 's_loc2');
% 
% sec_pos3 = states(sat_s3, 'CoordinateFrame', 'ecef');
% 
% xx =[]; 
% yy =[]; 
% zz =[]; 
% 
% for i=1:kuiper3_num_satellites
%     x = sec_pos3(1, 1, i); 
%     y = sec_pos3(2, 1, i);
%     z = sec_pos3(3, 1, i);
%     xx = [x; xx];
%     yy = [y; yy];
%     zz = [z; zz]; 
% end 
% s_loc3 = [xx yy zz];
% save('kuiper3_loc.mat', 's_loc3');
% 
% s_loc = [s_loc1; s_loc2; s_loc3]; 
% save('kuiper_all_loc.mat', 's_loc'); 
% 
% 


% SpaceX Constellation 
% Altitude Inclination #planes #sat/plane #satelltes
% 550        53         72      22          1584
% 540        53.2       72      22          1584
% 560        97.6       4       43          172
% 560        97.6       6       58          348
% 570        70         36      20          720

% % SpaceX shell 1
% spacex1_altitude = 540e3; 
% spacex1_radius = radius_earth + spacex1_altitude; 
% spacex1_inclination = 53.2 ; 
% spacex1_num_satellites = 1584; 
% spacex1_num_planes = 72; 
% 
% 
% 
% % SpaceX shell 2
% spacex2_altitude = 550e3; 
% spacex2_radius = radius_earth + spacex2_altitude; 
% spacex2_inclination = 53 ; 
% spacex2_num_satellites = 1584; 
% spacex2_num_planes = 72; 
% 
% 
% 
% 
% % SpaceX shell 3
% spacex3_altitude = 560e3; 
% spacex3_radius = radius_earth + spacex3_altitude; 
% spacex3_inclination = 97.6; 
% spacex3_num_satellites = 520; 
% spacex3_num_planes = 10; 
% 
% % SpaceX shell 4
% spacex4_altitude = 570e3; 
% spacex4_radius = radius_earth + spacex4_altitude; 
% spacex4_inclination = 70; 
% spacex4_num_satellites = 720; 
% spacex4_num_planes = 36; 
% 
% 
% startTime = datetime(2023,1,1); 
% startTime = startTime + hours(20); 
% stopTime = startTime + seconds(5); % days(2); % minutes(10); % hours(48); 
% sampleTime = 1e-3; % 1 ms, sample 0.5ms,   sample every 10 sec % seconds
% sc = satelliteScenario(startTime, stopTime, sampleTime); 
% 
% % 
% % Launch SpaceX satellites 
% sat_p1 = walkerDelta(sc,spacex1_radius, spacex1_inclination, spacex1_num_satellites, spacex1_num_planes, 1); 
% sat_p2 = walkerDelta(sc,spacex2_radius, spacex2_inclination, spacex2_num_satellites, spacex2_num_planes, 1);
% sat_p3 = walkerDelta(sc,spacex3_radius, spacex3_inclination, spacex3_num_satellites, spacex3_num_planes, 1);
% sat_p4 = walkerDelta(sc,spacex4_radius, spacex4_inclination, spacex4_num_satellites, spacex4_num_planes, 1);
% 
% % 
% % 
% % viewer3D = satelliteScenarioViewer(sc, 'ShowDetails', false); 
% % sat_p1.MarkerColor = [1,0,0]; 
% % sat_p2.MarkerColor = [1,0,0]; 
% % sat_p3.MarkerColor = [1,0,0]; 
% 
% 
% p1 = states(sat_p1, 'CoordinateFrame', 'ecef'); 
% p2 = states(sat_p2, 'CoordinateFrame', 'ecef'); 
% p3 = states(sat_p3, 'CoordinateFrame', 'ecef'); 
% p4 = states(sat_p4, 'CoordinateFrame', 'ecef'); 
% % 
% 
% % 
% space_loc = cat(3, p1, p2, p3, p4); 
% save('spacex_loc.mat', 'space_loc'); 
% % % 
