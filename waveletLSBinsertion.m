function y = waveletLSBinsertion(x, data)

y = zeros(size(x));
frameSize = 512;

% MU-LAW 8-BIT QUANTIZATION %
mu = 255;
linscale = -1:(2/255):1; % linear scale of range <-1,1> with 256 points
expandscale = sign(linscale) .* (((mu + 1) .^ abs(linscale) - 1) / mu);

% setting boundary points to central positions between adjacent
% expandscale values.
quantBoundary = diff(expandscale)/2 + expandscale(1:end-1);
quantBoundary = [-1, quantBoundary, 1]; % absolute upper- and lower bound


iter = floor(length(x)/frameSize);

for i = 1 : iter
    [DWTcoef_uint, subband_factors] = ...
        getQuantizedDwtCoefsMatrix((x((i-1) * frameSize + 1 : i * frameSize)), quantBoundary);
    
    % data embedding
    DWTcoef_bin = de2bi(reshape(DWTcoef_uint,[512,1]));
    DWTcoef_bin = [ones(512,1), DWTcoef_bin(:,2:end)];
    
    newDWTcoef_uint = reshape(bi2de(DWTcoef_bin),[16,32]);
    y((i-1) * frameSize + 1 : i * frameSize) = ...
        performIDWT(newDWTcoef_uint, subband_factors, expandscale);
end

y(i * frameSize + 1 : end) = x(i * frameSize + 1 : end);

