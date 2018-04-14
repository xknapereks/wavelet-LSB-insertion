% Edited by Stefan Knaperek on 2018/04/14

function [numOfErrors, BER] = countBitErrors(array1, array2, a, b)
% function [numOfErrors, BER] = countBitErrors(array1, array2, a, b)
% computes the bit error rate based on comparing array1 and array2 in the
% range of <a,b>
%
% INPUT VARIABLES
% array1, array2  (uint16) integer arrays to be compared on bit level
% <a,b>           interval of bits in each number to compare (LSB = 1, MSB
%                   = 16)
% OUTPUT VARIABLES
% numOfErrors       overall number of bits inconsistent in array1 and
%                   array2
% BER               bit error rate

frameSize = length(array1);
errVector = zeros(frameSize * ((b - a) + 1), 1);

for i = a : b
    errVector((i - a) * frameSize + 1 : (i - a + 1) * frameSize) = ...
        bitxor(bitget(array1, i), bitget(array2, i));
end

numOfErrors = sum(errVector);
BER = numOfErrors / length(errVector);