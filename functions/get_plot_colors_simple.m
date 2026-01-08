function C = get_plot_colors_simple(N,M)

% RGB sets
C = ...
[000, 000, 000;
 255, 000, 000;
 000, 000, 255;
 000, 145, 010;
 255, 000, 255;
 243, 109, 004;
 118, 042, 131;
 000, 169, 183;
 101, 067, 033];

[MAX_N,~] = size(C);

if nargin < 1
    N = MAX_N;
end

if nargin < 2
    M = 1;
end

if N > MAX_N
    % warning(['N cannot be greater than ' num2str(MAX_N) '. Setting N=' num2str(MAX_N) '.']);
    % warning(['N cannot be greater than ' num2str(MAX_N) '.']);
    OLD_N = N;
    N = MAX_N;
    M = ceil(OLD_N/MAX_N);
end

if M < 1
    M = 1;
end

% Take first N and normalize to [0,1]
C = C(1:N,:) ./ 255;

% Repeat scheme M times
C = repmat(C,M,1);

end