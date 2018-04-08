function [DWTcoef_uint, subband_factors] = getQuantizedDwtCoefsMatrix(x, quantBoundary)
% x is a single-column input frame

% ANALYSIS FILTERBANK %
DWTcoef_1col = haarMultistageSymmetricalAnalysis(x, 5);
DWTcoef = reshape(DWTcoef_1col, [16,32]);

% normalizing each subband to range <-1,1>
subband_factors = max(abs(DWTcoef));
DWTcoef_norm = DWTcoef ./ (ones(16,1) * subband_factors);

% COMPRESSOR
hsqe = dsp.ScalarQuantizerEncoder;
hsqe.BoundaryPoints = quantBoundary;
hsqe.CodewordOutputPort = true;
hsqe.Codebook = int8(-128:127); % desired output resolution
DWTcoef_uint = uint8(step(hsqe, DWTcoef_norm));