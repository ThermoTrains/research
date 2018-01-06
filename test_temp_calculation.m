data = [2844 ]; 
emissivity = 0.95; 
distance = 0; 
reflected_temp = 20; 
atmospheric_temp = 20; 
% extr_lens_temp = 20; 
% extr_lens_transmission = 1; 
relative_humidity = 50; 
planck_R1 = 16556; 
planck_R2 = 0.046952017; 
planck_B = 1428; 
planck_F = 1; 
planck_O = -207;

temp = calculateTemp( data, emissivity, distance, reflected_temp, atmospheric_temp, relative_humidity, planck_R1, planck_R2, planck_B, planck_F, planck_O )

% h = 6.626068e-34;
% k = 1.38066e-23;
% c =2.997925e+8;
