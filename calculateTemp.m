function [ Temp ] = calculateTemp( Data, emissivity, distance, reflected_temp, atmospheric_temp, relative_humidity, planck_R1, planck_R2, planck_B, planck_F, planck_O )
%CALCULATETEMP Calculate Temperature for every pixel from FLIR A65 raw data
%   data: FLIR Mono16 raw data (not temperatur linear data)
%   emissivity: Emissivity of object
%   distance: Distance to object in meters
%   reflected_temp: reflected apparent temperature in degree Celcius
%   atmospheric_temp: temperature of the atmoshpere in degree Celcius
%   relative_humidity: relative humidity in percentage
%   planck_R1: Planck R1 constant from EXIF Metadata
%   planck_R2: Planck R2 constant from EXIF Metadata
%   planck_B: Planck B constant from EXIF Metadata
%   planck_F: Planck F constant from EXIF Metadata
%   planck_O: Planck O constant from EXIF Metadata

% Quellen http://130.15.24.88/exiftool/forum/index.php/topic,4898.60.html
%         http://u88.n24.queensu.ca/exiftool/forum/index.php/topic,4898.msg23944.html#msg23944
%         Prof. Minkina W., Dudzik S: Infrared Thermography: Errors and Uncertainties, Wiley, 2009


% From EXIF Metadata to calculate air humidity impact
% Atmospheric Trans Alpha 1       : 0.006569
% Atmospheric Trans Alpha 2       : 0.012620
% Atmospheric Trans Beta 1        : -0.002276
% Atmospheric Trans Beta 2        : -0.006670
% Atmospheric Trans X             : 1.900000
ata1 = 0.006569;
ata2 = 0.01262;
atb1 = -0.002276;
atb2 = -0.00667;
atx = 1.9;

atmosphere = (relative_humidity/100) * exp(1.5587 + 0.06939 * (atmospheric_temp) - 0.00027816 * (atmospheric_temp) ^ 2 + 0.00000068455 * (atmospheric_temp)^3);
tau = atx * exp(-sqrt(distance) * (ata1 + atb1 * sqrt(atmosphere))) + (1-atx) * exp(-sqrt(distance) * (ata2 + atb2 * sqrt(atmosphere)));

reflectance_blackbody = planck_R1 / (planck_R2 * (exp(planck_B / (reflected_temp + 273.15)) - planck_F)) - planck_O;
reflectance = (1-emissivity) / emissivity * reflectance_blackbody;

atmospheric_emission_blackbody = planck_R1 / (planck_R2 * (exp(planck_B / (atmospheric_temp + 273.15)) - planck_F)) - planck_O;
atmospheric_emission = (1-tau)/emissivity/tau * atmospheric_emission_blackbody;
  
Object = (Data/emissivity/tau - atmospheric_emission - reflectance);
  
Temp = planck_B./log(planck_R1./(planck_R2 * (Object + planck_O)) + planck_F) - 273.15;

end

