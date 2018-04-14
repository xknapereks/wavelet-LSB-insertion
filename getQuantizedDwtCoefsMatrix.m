% Edited by Stefan Knaperek on 2018/04/14

function [DWTcoef_uint, subband_factors] = getQuantizedDwtCoefsMatrix(x)
% function [DWTcoef_uint, subband_factors] = getQuantizedDwtCoefsMatrix(x)
% Computes the whole analysis part of the algorithm for one frame
%
% INPUT
% x             a single-column input frame (512 single samples)
%
% OUTPUT
% DWTcoef_uint  16x32 matrix reshaped to a vector, containing DWT
%               coefficients in the range of 0 - 65536
% subband_factors 1x32 vector containing scaling coefficient for each band

% ANALYSIS FILTERBANK %
DWTcoef_1col = haarMultistageSymmetricalAnalysis(x, 5);
DWTcoef = reshape(DWTcoef_1col, [16,32]);

% normalizing each subband to nominal range of uint16
subband_factors = max(abs(DWTcoef))/32750; % getting a row with the column maxima
DWTcoef_norm = DWTcoef ./ (ones(16,1) * subband_factors) + 32760;
DWTcoef_norm = DWTcoef_norm(:);
DWTcoef_uint = uint16(DWTcoef_norm);
