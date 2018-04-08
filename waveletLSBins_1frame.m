function x_rec = waveletLSBins_1frame(x)

% % % % % % % % % % % %
% ANALYSIS FILTERBANK %
% % % % % % % % % % % %

% hdydanal = dsp.DyadicAnalysisFilterBank;
% hdydanal.Filter = 'Haar';
% hdydanal.NumLevels = 5;
% hdydanal.TreeStructure = 'Symmetric';
% DWTcoef_1col = step(hdydanal, x);
% % This dyadic analysis filter bank introduces an unwanted shift of 2^N - 1,
% % where N is the number of FB stages, therefore we have implemented our own
% % FB with shift compensation

% The elements of DWTcoef_1col are ordered with the highest frequency
% subband first followed by subbands in decreasing frequency
DWTcoef_1col = haarMultistageSymmetricalAnalysis(x, 5);

% reorganizing: each subband in a column of 16 samples. Starting with the
% highest frequency subband
DWTcoef = reshape(DWTcoef_1col, [16,32]);
subband_factors = max(abs(DWTcoef)); % saving maximal value of each subband

% normalizing each subband to range <-1,1>
DWTcoef_norm = DWTcoef ./ (ones(16,1) * subband_factors);


% % % % % % % % % % % % % % %
% MU-LAW 8-BIT QUANTIZATION %
% % % % % % % % % % % % % % %

mu = 255;
linscale = -1:(2/255):1; % linear scale of range <-1,1> with 256 points

% compressed_input = sign(linscale) .* (log(1 + mu * abs(linscale)) / log(1 + mu)); % mu-law compression

% mu-law expansion
expandscale = sign(linscale) .* (((mu + 1) .^ abs(linscale) - 1) / mu);

% COMPRESSOR
% setting boundary points to central positions between adjacent
% expandscale values. Leading to compression (higher density for values
% around zero, low for peaks)
boundary = diff(expandscale)/2 + expandscale(1:end-1);
boundary = [-1, boundary, 1]; % absolute upper- and lower bound

hsqe = dsp.ScalarQuantizerEncoder;
hsqe.BoundaryPoints = boundary;
hsqe.CodewordOutputPort = true;
hsqe.Codebook = int8(-128:127); % desired output resolution
DWTcoef_uint = uint8(step(hsqe, DWTcoef_norm));

% DWTcoef_uint    quantized input matrix in the range of 0:255 ready to
% write steganographic data

% EXPANDER
codebook = expandscale;
indices = DWTcoef_uint;
hsqdec = dsp.ScalarQuantizerDecoder;
hsqdec.CodebookSource = 'Input port';
DWTcoef_rec_norm = step(hsqdec, indices, codebook);
% DWTcoef_rec_norm   reconstructed DWT coeficients in the range of <-1,1>

% remaining: back-scale the bands, testing. Writing and reading
DWTcoef_rec = DWTcoef_rec_norm .* (ones(16,1) * subband_factors);
DWTcoef_rec_1col = reshape(DWTcoef_rec, [512,1]);

% % % % % % % % % % % % 
% SYNTHESIS FILTERBANK %
% % % % % % % % % % % %

hdydsyn = dsp.DyadicSynthesisFilterBank;
hdydsyn.Filter = 'Haar';
hdydsyn.NumLevels = 5;
hdydsyn.TreeStructure = 'Symmetric';
x_rec = step(hdydsyn, DWTcoef_rec_1col);
% x_rec = step(hdydsyn, DWTcoef_1col); % testing filterbanks only

% figure(1)
% hold on
% for i = 0:31
%     plot(DWTcoef_1col(i*16 + 1:(i+1)*16))
% end