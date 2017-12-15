function [ temp ] = calculateTemp( data, emissivity, distance, reflected_temp, atmospheric_temp, extr_lens_temp, extr_lens_transmission, relative_humidity, planck_R1, planck_R2, planck_B, planck_F, planck_O )
%CALCULATETEMP Calculate Temperature for every pixel from FLIR A65 raw data
%   data: FLIR Mono14 raw data
%   emissivity: Emissivity of object

% From EXIF Metadata
% Atmospheric Trans Alpha 1       : 0.006569
% Atmospheric Trans Alpha 2       : 0.012620
% Atmospheric Trans Beta 1        : -0.002276
% Atmospheric Trans Beta 2        : -0.006670
% Atmospheric Trans X             : 1.900000
ATA1 = 0.006569;
ATA2 = 0.01262;
ATB1 = -0.002276;
ATB2 = -0.00667;
ATX = 1.9;

extr_lens_emission = 1 - extr_lens_transmission;
extr_lens_reflectance = 0;

atmosphere = (relative_humidity/100) * exp(1.5587 + 0.06939 * (atmospheric_temp) - 0.00027816 * (atmospheric_temp) ^ 2 + 0.00000068455 * (atmospheric_temp)^3);
tau1 = ATX * exp(-sqrt(distance/2) * (ATA1 + ATB1 * sqrt(atmosphere))) + (1-ATX) * exp(-sqrt(distance/2) * (ATA2 + ATB2 * sqrt(atmosphere)));
tau2 = ATX * exp(-sqrt(distance/2) * (ATA1 + ATB1 * sqrt(atmosphere))) + (1-ATX) * exp(-sqrt(distance/2) * (ATA2 + ATB2 * sqrt(atmosphere)));

reflectance_before_extr_lens = planck_R1 / (planck_R2 * (exp(planck_B / (reflected_temp + 273.15))-planck_F)) - planck_O;
reflectance_before_extr_lens_attenuated = (1-emissivity) / emissivity * reflectance_before_extr_lens;

atmospheric_emission_before_extr_lens = planck_R1 / (planck_R2 * (exp(planck_B / (atmospheric_temp + 273.15)) - planck_F)) - planck_O;
atmospheric_emission_before_extr_lens_attenuated = (1-tau1)/emissivity/tau1 * atmospheric_emission_before_extr_lens;

extr_lens_emittance = planck_R1 / (planck_R2 * (exp(planck_B / (extr_lens_temp + 273.15)) - planck_F)) - planck_O;
extr_lens_emittance_attenuated = extr_lens_emission/emissivity/tau1/extr_lens_transmission * extr_lens_emittance;
  
reflectance_after_extr_lens = planck_R1 / (planck_R2 * (exp(planck_B / (reflected_temp + 273.15)) - planck_F)) - planck_O;
reflectance_after_extr_lens_attenuated = extr_lens_reflectance/emissivity/tau1/extr_lens_transmission * reflectance_after_extr_lens;

atmospheric_emission_after_extr_lens = planck_R1/(planck_R2*(exp(planck_B/(atmospheric_temp+273.15))-planck_F))-planck_O;
atmospheric_emission_after_extr_lens_attenuated = (1-tau2)/emissivity/tau1/extr_lens_transmission/tau2 * atmospheric_emission_after_extr_lens;
  
object = (data/emissivity/tau1/extr_lens_transmission/tau2 - atmospheric_emission_before_extr_lens_attenuated - atmospheric_emission_after_extr_lens_attenuated - extr_lens_emittance_attenuated - reflectance_before_extr_lens_attenuated - reflectance_after_extr_lens_attenuated);
  
temp = planck_B./log(planck_R1./(planck_R2 * (object + planck_O)) + planck_F) - 273.15;

end

