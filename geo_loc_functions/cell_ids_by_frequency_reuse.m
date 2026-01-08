function [total_cells_band, cell_segment] = cell_ids_by_frequency_reuse(num_lat, num_lon, frf_factor)
    if frf_factor ==3
        f1=[]; 
        f2=[]; 
        f3=[];
        
        for i=1:num_lon %28
            start = num_lat*(i-1) + 1;
            ending = num_lat*(i-1) + num_lat; 
            if rem(i,3)==1
                temp1 = start:2:ending; 
                temp2 = start+1:2:ending; 
                f1 =[f1;temp1'];
                f2 = [f2;temp2'];
            elseif rem(i,3)==2
                temp3 = start:2:ending; 
                temp1 = (start+1):2:ending;
                f3 =[f3; temp3'];
                f1 = [f1;temp1'];
            elseif rem(i,3)== 0
                temp2 = start:2:ending; 
                temp3 = (start+1):2:ending; 
                f2 = [f2;temp2'];
                f3 = [f3;temp3']; 
            end
        end
        f1_num_cell = length(f1); %314
        f2_num_cell = length(f2); %313
        f3_num_cell = length(f3); %297
    
        num_col = max([f1_num_cell, f2_num_cell, f3_num_cell]); 
        ff2 = [f2; zeros(num_col - f2_num_cell,1)]; 
        ff3 = [f3; zeros(num_col - f3_num_cell,1)];
        total_cells_band = [f1'; ff2'; ff3']; 
        seg1=[]; 
        seg2=[]; 
        seg3=[];
        
        for i=1:num_lon
            start = num_lat*(i-1) + 1;
            ending = num_lat*(i-1) + num_lat; 
            if rem(i,3)==1
                temp1 = start:6:ending; 
                temp2 = start +2:6:ending; 
                temp3 = start+4:6:ending;
                seg1 = [seg1; temp1'];
                seg2 = [seg2; temp2'];
                seg3 = [seg3; temp3'];

            elseif rem(i,3) ==2
                temp3 = start+1:6:ending; 
                temp1 = start+3:6:ending; 
                temp2 = start+5:6:ending;
                seg1 = [seg1; temp1'];
                seg3 = [seg3;temp3'];
                seg2=[seg2;temp2'];
            end
        end
        num_s1 = length(seg1); 
        num_s2 = length(seg2); 
        num_s3 = length(seg3);
        num_col = max([num_s1, num_s2, num_s3]); 

        ss2 = [seg2; zeros(num_col - num_s2,1)]; 
        ss3 = [seg3; zeros(num_col - num_s3,1)];
        cell_segment = [seg1'; ss2'; ss3']; 
   
    elseif frf_factor ==4
        f1=[]; 
        f2=[]; 
        f3=[]; 
        f4=[]; 


        for i=1:num_lon %28
            start = num_lat*(i-1) + 1;
            ending = num_lat*(i-1) + num_lat; 
            if rem(i,2)==1
                temp1 = start:4:ending; 
                temp2 = start+1:4:ending;
                temp3 = start+2:4:ending;
                temp4 = start+3:4:ending;
                f1 =[f1;temp1'];
                f2 =[f2; temp2'];
                f3 = [f3;temp3'];
                f4 = [f4; temp4'];
            else
                temp3 = start:4:ending; 
                temp4 = start+1:4:ending;
                temp1 = start+2:4:ending;
                temp2 = start+3:4:ending;
                f1 =[f1;temp1'];
                f2 =[f2; temp2'];
                f3 = [f3;temp3'];
                f4 = [f4; temp4'];
            end
        end
        f1_num_cell = length(f1); %314
        f2_num_cell = length(f2); %313
        f3_num_cell = length(f3); %297
        f4_num_cell = length(f4); %2

        num_col = max([f1_num_cell, f2_num_cell, f3_num_cell, f4_num_cell]); 
        ff2 = [f2; zeros(num_col - f2_num_cell,1)]; 
        ff3 = [f3; zeros(num_col - f3_num_cell,1)];
        total_cells_band = [f1'; f2'; f3'; f4']; 
    end

end 


