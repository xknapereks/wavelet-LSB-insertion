[x, Fs] = audioread('/home/maco/Documents/FEI/diplomovka/coding/kralovany_synth.mp3');
% x = x(:,1);
% x = x(3100:end,1);
% x = x(1:512);

y = waveletLSBinsertion(x);

audiowrite('kr_1for1LSB.wav', y, Fs);

