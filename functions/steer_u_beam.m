function usr = steer_u_beam(usr, sat)

        [~,th,ph] = get_relative_position([0,0,0], usr.location); 
        usr.beam.array.steer(th,ph,true); 

        [~,th,ph] = get_relative_position(usr.location, sat.location); 
        usr.beam.array.steer(th,ph,true); 
        usr.beam.set_steering_direction(th,ph); 
 
end 
 