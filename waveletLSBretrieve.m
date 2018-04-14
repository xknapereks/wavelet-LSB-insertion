% Edited by Stefan Knaperek on 2018/04/14

function [data, DWTcoef_uint] = waveletLSBretrieve(x, a, b)
% function [data, DWTcoef_uint] = waveletLSBretrieve(x, a, b)
% Reads steganographically hidden data by the means of 5-level FB
%
% INPUT VARIABLES
% x         vector of PCM samples (single)
% <a,b>     scope of insertion into LWT coefficients. a = starting bit, b =
%           last overwritten bit. LSB = 1, MSB = 16
%
% OUTPUT VARIABLES
% data      retrieved data in format of a "double" vector
% DWTcoef_uint debugging output of matrix of DWT coefficients in binary
%           format after the phase of analysis filterbank

embedDepth = b - a + 1;
frameSize = 512;
iter = floor(length(x)/frameSize); % number of full frames
data_bin = logical(zeros(iter * frameSize * embedDepth, 1));
for i = 1 : iter
    [DWTcoef_uint, ~] = ...
        getQuantizedDwtCoefsMatrix((x((i-1) * frameSize + 1 : i * frameSize)));
    
    % data retrieval
    newData = logical(de2bi(DWTcoef_uint));
    newData = newData(:, a : b);
    
    data_bin((i-1) * frameSize * embedDepth + 1 : ...
        i * frameSize * embedDepth) = newData(:);    
end
data_bin = (reshape(data_bin, [64, iter * frameSize * embedDepth / 64]))';
data_uint64 = uint64(bi2de(data_bin));
data = typecast(data_uint64, 'double');