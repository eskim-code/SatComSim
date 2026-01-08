function [AntGainInterpolant,AntPattern] = satellite_tx_mask(frequency,Gmax, phi)
%g_max = 34.5; 
%frequency = 19; 

f = dbstack;
AntPattern = f(1).name;

diameterlambda = 10^((Gmax-7.7)/20);
ant_diam = diameterlambda * (0.3/frequency); 

hpw_bw = 70 *(0.3 /frequency)/ant_diam; 
phi_b = hpw_bw/2; 

Ls = -6.75; 
Y = 1.5 * phi_b; 
Z = Y * 10^(0.04 *(Gmax + Ls -0)); 

%phi = 0:0.001:180;
Gain = zeros(size(phi));


Gain((0<=phi)&(phi<1.5 * phi_b)) = Gmax - 3*(phi((0<=phi)&(phi<1.5 *phi_b))./phi_b).^2;
Gain((phi >=1.5 * phi_b)&(phi<Z)) = Gmax + Ls - 25 * log10(phi((phi >=1.5 * phi_b)&(phi<Z))/Y); 
Gain(phi>Z) = 0 ; 

AntGainInterpolant = griddedInterpolant(phi,Gain);

% plot(phi,Gain);
%hold on
 
end