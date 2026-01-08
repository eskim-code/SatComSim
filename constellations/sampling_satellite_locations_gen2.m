function sampling_satellite_locations_gen2_r1(Settings, sim_period, sampling_time)

    spacex_fn = ['spacex_', num2str(sampling_time), 's_', num2str(sim_period), 'm.mat'];
    kuiper_fn = ['kuiper_', num2str(sampling_time), 's_', num2str(sim_period), 'm.mat'];

    %if ~exist(spacex_fn)
    startTime = datetime(2024,1,1); 
    startTime = startTime + hours(20); 
    stopTime = startTime + minutes(sim_period); % days(2); % minutes(10); % hours(48); 
    sampleTime = sampling_time; % 1 ms, sample 0.5ms,   sample every 10 sec % seconds
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

    save(fullfile(Settings.ConstellationFolder, kuiper_fn), 'k_loc');
   % save(fullfile('../Multi-cell-measurements/constellations', kuiper_fn),'k_loc') ; 
   
    sc = satelliteScenario(startTime, stopTime, sampleTime); 
    
    % Launch SpaceX satellites 
    sat_p1 = walkerDelta(sc,spacex1_radius, spacex1_inclination, spacex1_num_satellites, spacex1_num_planes, 1); 
    sat_p2 = walkerDelta(sc,spacex2_radius, spacex2_inclination, spacex2_num_satellites, spacex2_num_planes, 1);
    sat_p3 = walkerDelta(sc,spacex3_radius, spacex3_inclination, spacex3_num_satellites, spacex3_num_planes, 1);
    sat_p4 = walkerDelta(sc,spacex4_radius, spacex4_inclination, spacex4_num_satellites, spacex4_num_planes, 1);
    sat_p5 = walkerDelta(sc,spacex5_radius, spacex5_inclination, spacex5_num_satellites, spacex5_num_planes, 1);

    % 
    % Launch SpaceX satellites 
    p1 = states(sat_p1, 'CoordinateFrame', 'ecef'); 
    p2 = states(sat_p2, 'CoordinateFrame', 'ecef'); 
    p3 = states(sat_p3, 'CoordinateFrame', 'ecef'); 
    p4 = states(sat_p4, 'CoordinateFrame', 'ecef'); 
    p5 = states(sat_p5, 'CoordinateFrame', 'ecef'); 
    
    % 
    
    space_loc = cat(3, p1, p2, p3, p4, p5); 
    save(fullfile(Settings.ConstellationFolder, spacex_fn), 'space_loc')
    %save(fullfile('../Multi-cell-measurements/constellations', spacex_fn),'space_loc') ; 


end