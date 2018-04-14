% Edited by Stefan Knaperek on 2018/04/14

function steganoframe = performIDWT(DWTcoef_rec_norm, subband_factors)
% function steganoframe = performIDWT(DWTcoef_rec_norm, subband_factors)
% Performs inverse 5-level DWT returning a vector of 512 stego PCM samples
%
% INPUT VARIABLES:
% DWTcoef_rec_norm matrix of normalized 512 DWT coefficients in single
%                   precision
% subband_factors   scaling coefficients for each one of the 32 wavelet 
%                   subbands
%
% OUTPUT VARIABLES
% steganoframe      vector of 512 stego PCM samples

DWTcoef_rec_norm = reshape(DWTcoef_rec_norm, [16,32]);

% rescale and reshape
DWTcoef_rec = DWTcoef_rec_norm - 32760;
DWTcoef_rec = DWTcoef_rec .* (ones(16,1) * subband_factors);
% DWTcoef_rec = DWTcoef_rec_norm .* (ones(16,1) * subband_factors);
DWTcoef_rec_1col = reshape(DWTcoef_rec, [512,1]);

% SYNTHESIS FILTERBANK %
hdydsyn = dsp.DyadicSynthesisFilterBank;
hdydsyn.Filter = 'Haar';
hdydsyn.NumLevels = 5;
hdydsyn.TreeStructure = 'Symmetric';
steganoframe = step(hdydsyn, DWTcoef_rec_1col);