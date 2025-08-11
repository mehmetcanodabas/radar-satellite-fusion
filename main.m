% Main; Radar and Sentinel-2 fusion pipeline
clc; clear; close all;

% Read radar data
[Ih,Qh,Iv,Qv,R_2] = read_radar_data();

% Derive radar moments and get  beam polygon
[ZHmean, R_km, lat_polygon, lon_polygon, color] = ...
    derive_radar_moments(Ih,Qh,Iv,Qv,R_2);

% Read Sentinel-2 data
[B2, ref] = read_sentinel_data("B2");
[B8, ~  ] = read_sentinel_data("B8");

% Crop Sentinel-2 imagery to radar field of view
xlimits = [411900 449900];
ylimits = [5819000 5859000];
[lat_sentinel, lon_sentinel, B2_cropped, B8_cropped] = ...
    extract_sentinel_roi(B2, B8, ref, xlimits, ylimits);

% Derive wti
[wti_radiance, wti_intensity] = derive_wti(B2_cropped, B8_cropped);

% Fuse radar and Sentinel-2
fh = radar_sentinel_fusion(lat_sentinel, lon_sentinel, wti_radiance, ...
                           lat_polygon, lon_polygon, color);

disp("✅ Pipeline finished.");
