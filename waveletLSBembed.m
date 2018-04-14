% Edited by Stefan Knaperek on 2018/04/14

function [y, newDWTcoef_uint] = waveletLSBembed(x, data, a, b)
% function [y, newDWTcoef_uint] = waveletLSBembed(x, data, a, b)
% Performs steganographic insertion of data into single PCM samples x in
% the scope of bits <a,b> (1-based) and returns y containing stego PCM
% samples and also newDWTcoef_uint for debugging purposes.
%
% INPUT PARAMETERS:
% x       (single) cover audio data
% data    (double) column vector containing data to embed - 64b in each
%                  element
% embedDepth       number of LSBs to overwrite in each DWT coefficient,
%                  usual is 7-9, 8 is recommended for optimal
%                  capacity/quality ratio
% <a,b>            interval of bits where data should be embedded. LSB = 1
%                  and MSB = 16
%
% OUTPUT VARIABLES:
% y                 vector of stego PCM samples (single)
% newDWTcoef_uint   matrix of DWT coefficients in binary form after
%                   inserting data
%
% OTHER VARIABLES:
% data_bin (uint8) matrix of binary values, each 0/1 saved as uint8
%                  (smallest possible in Matlab). Number of rows
%                  equals to frame size. In insertion process are the whole
%                  columns copied to binary DWTcoef_bin matrices.
%                  

embedDepth = b - a + 1;
y = single(zeros(size(x)));
frameSize = 512;
iter = floor(length(x)/frameSize); % number of full frames

% temporary solution if data is larger than capacity available
data = data(1 : iter * frameSize * embedDepth / 64); % drop superfluous data

data_uint64 = typecast(data, 'uint64');
data_bin = logical(de2bi(data_uint64, 64)); % second parameter fixes output columns number to 64
data_bin2 = reshape(data_bin', [frameSize, length(data) * 64 / frameSize]);

for i = 1 : iter
    [DWTcoef_uint, subband_factors] = ...
        getQuantizedDwtCoefsMatrix((x((i-1) * frameSize + 1 : i * frameSize)));
    DWTcoef_bin = logical(de2bi(DWTcoef_uint));
    
    % data insertion
    DWTcoef_bin(:, a : b) = ...
        data_bin2(:, (i-1) * embedDepth + 1 : i * embedDepth);
   
    newDWTcoef_single = single(bi2de(DWTcoef_bin));
    newDWTcoef_uint = uint16(newDWTcoef_single);
    y((i-1) * frameSize + 1 : i * frameSize) = ...
        performIDWT(newDWTcoef_single, subband_factors);
end

y(i * frameSize + 1 : end) = x(i * frameSize + 1 : end); % copying the last incomplete block

