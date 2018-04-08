function steganoframe = performIDWT(DWTcoef_uint, subband_factors, expandscale)

% EXPANDER
hsqdec = dsp.ScalarQuantizerDecoder;
hsqdec.CodebookSource = 'Input port';
DWTcoef_rec_norm = step(hsqdec, DWTcoef_uint, expandscale);
% DWTcoef_rec_norm   reconstructed DWT coeficients in the range of <-1,1>

% rescale and reshape
DWTcoef_rec = DWTcoef_rec_norm .* (ones(16,1) * subband_factors);
DWTcoef_rec_1col = reshape(DWTcoef_rec, [512,1]);

% SYNTHESIS FILTERBANK %
hdydsyn = dsp.DyadicSynthesisFilterBank;
hdydsyn.Filter = 'Haar';
hdydsyn.NumLevels = 5;
hdydsyn.TreeStructure = 'Symmetric';
steganoframe = step(hdydsyn, DWTcoef_rec_1col);