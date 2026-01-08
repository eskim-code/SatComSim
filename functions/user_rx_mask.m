function [AntGainInterpolant,AntPattern,diameter] = user_rx_mask(frequency,phi, varargin)
 
f = dbstack;
AntPattern = f(1).name;
 
lambda = 3e8/frequency/1e9; % in m
 
nargs = length(varargin);
for n = 1:nargs
    switch varargin{n}
        case 'Max Antenna Gain'
            Gmax = varargin{n+1};
        case 'Diameter'
            diameter = varargin{n+1};
        case 'Half-Power Beamwidth'
            phim = varargin{n+1};
        case 'Gain Floor'
            Gfloor = varargin{n+1};
        otherwise
            continue;
    end 
end
 
% diameterlambda = diameter/lambda;
 
if ~exist('diameter','var') && exist('Gmax','var')
    diameter = ((lambda/pi)^2* 1/0.6 * 10^(Gmax/10))^0.5;
end
if exist('diameter','var') && ~exist('Gmax','var')
    Gmax = 10*log10(0.6*(pi*diameter/lambda)^2);
end
 
diameterlambda = 10^((Gmax-7.7)/20);
 
%phi = 0:0.001:180;
% phi = 0:0.05:35; 
Gain = zeros(size(phi));
 
G1 = 2 + 15*log10(diameterlambda);
 
if ~exist('phim','var')
    phim = 20*(diameterlambda)^(-1) * sqrt(Gmax-G1);
end
    
if diameterlambda >=100
    
    phir = 15.85*(diameterlambda)^(-0.6);
    
    Gain((0<=phi)&(phi<phim)) = Gmax - 2.5e-3 * (diameterlambda* phi((0<=phi)&(phi<phim))).^2;
    Gain((phim<=phi)&(phi<phir)) = G1;
    Gain((phir<=phi)&(phi<48)) = 32 - 25*log10(phi((phir<=phi)&(phi<48)));
    Gain((48<=phi)&(phi<=180)) = -10;
    
elseif diameterlambda < 100
    
    phir = 100*(diameterlambda)^-1;
    
    Gain((0<=phi)&(phi<phim)) = Gmax - 2.5e-3 * (diameterlambda* phi((0<=phi)&(phi<phim))).^2;
    Gain((phim<=phi)&(phi<phir)) = G1;
    Gain((phir<=phi)&(phi<48)) =52 - 10*log10(diameterlambda) - 25*log10(phi((phir<=phi)&(phi<48)));
    Gain((48<=phi)&(phi<=180)) =  10-10*log10(diameterlambda);


%     Gain((phir<=phi)&(phi<48)) = 52 - 10*log10(diameterlambda) - 25*log10(phi((phir<=phi)&(phi<48)));
%  %    Gain((phir<=phi)&(phi<48)) = 32 - 25*log10(phi((phir<=phi)&(phi<48)));
%     Gain((48<=phi)&(phi<=180)) = 10-10*log10(diameterlambda);
%     
end
 
if exist('Gfloor','var')
    Gain = max(Gain,Gfloor);
end
 
AntGainInterpolant = griddedInterpolant(phi,Gain);
%figure(); 
%plot(phi,Gain);

end