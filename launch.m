% Edited by Stefan Knaperek on 2018/04/14
% 
% This script performs steganographic insertion of random data into a wav
% file, retrieves them and computes the bit error rate (BER) with respect
% to starting depth of insertion
%
% variables:
% x             vector of PCM samples. Firstly int16, then single to support
%               signal processing
% Fs            sampling frequency of the signal
% data          vector of random double numbers used to test retrieval
% frameSize     number of processed samples in one filterbank loop
% coverAudio    signal samples of the current processed frame
% a             starting bit of insertion. 1-based
% b             last bit of insertion. 1-based
% outputArray   matrix of BER results
%   1st col     value of a
%   2nd col     measured BER
%   layers      results for various signal frames (100 frames chosen)
% averageBERs   matrix containing BER with respect to starting bit,
%               averaged over 100 frames
% y             resulting PCM samples after DWT LSB insertion
% aux_W         auxiliary matrix containing all 512 normalized DWT
%               coefficients of current frame in binary format after data
%               insertion and before inverse DWT
% aux_R         auxiliary matrix containing all 512 normalized DWT
%               coefficients after DWT in retrieval process
% data_rec      recovered data in format of vector, double



% load song
[x, Fs] = audioread('example.wav', 'native');
x = x(:,1);
x = x(3100:end,1);
x = single(x); 

data = rand(300000,1);

frameSize = 512;
b = 8;

outputArray = zeros(8,2,100);

for i = 1 : 100
    coverAudio = x((i-1) * frameSize + 1 : i * frameSize);
    
   for a = 1 : 8
       [y, aux_W] = waveletLSBembed(coverAudio, data, a, b);
       [data_rec, aux_R] = waveletLSBretrieve(y, a, b);
       outputArray(a,1,i) = a;
       [~, outputArray(a,2,i)] = countBitErrors(aux_W, aux_R, a, b);
   end
end

averageBERs = mean(outputArray, 3)

plot(averageBERs(:,1) - 1, averageBERs(:,2), 'kx')
xlabel('Starting depth of insertion')
ylabel('Bit error rate')
