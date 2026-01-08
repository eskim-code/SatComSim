function [col_idx, min_consecutive_ones] = find_shortest_consecutive_ones(A)
    [num_rows, num_cols] = size(A);
    
    % Initialize variables to store the min count of consecutive 1's and the corresponding column index
    min_consecutive_ones = Inf;  % Start with a large value
    col_idx = 0;

    % Loop through each column
    for col = 1:num_cols
        count_ones = 0;
        found_one = false;  % Track if we have encountered any 1's in this column

        % Loop through each row in the column
        for row = 1:num_rows
            if A(row, col) == 1
                count_ones = count_ones + 1;  % Increment the counter if it's a 1
                found_one = true;  % Mark that we have encountered 1's
            else
                % Check and update min_consecutive_ones if a sequence ended
                if count_ones > 0 && count_ones < min_consecutive_ones
                    min_consecutive_ones = count_ones;
                    col_idx = col;  % Update the column index with the current column
                end
                count_ones = 0;  % Reset the counter when a 0 is encountered
            end
        end

        % Check again after the loop in case the column ends with a sequence of 1's
        if count_ones > 0 && count_ones < min_consecutive_ones
            min_consecutive_ones = count_ones;
            col_idx = col;
        end

        % Handle case where no 1's are found in the column
        if ~found_one
            min_consecutive_ones = 0;
            col_idx = col;
        end
    end
end
