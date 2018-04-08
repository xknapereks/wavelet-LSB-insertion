
% This is my implementation of 1st order filterbank compatible with the
% dsp-library approach actually used in the project

% filter bank designed to work with 512-sample blocks

x = audioread('/home/maco/Documents/FEI/diplomovka/coding/kralovany_synth.mp3');
x = x(3100:end,1);
x = x(513:1024);


% Haar analysis filters
fl = [1, 1]/sqrt(2);
fh = [-1, 1]/sqrt(2);
% Haar synthesis filters for perfect reconstruction
gl = fl;
gh = -fh;

l = length(x);

% NOT WORKING BLOCK: introducing time-shift
% % analysis
% xla = conv(x, fl); % filtering
% xl = xla(1:2:end-1); % subsampling
% xha = conv(x, fh);
% xh = xha(1:2:end-1); % necessary to exclude the very last sample to preserve the block length
% 
% % room for manipulation with xl & xh
% 
% % synthesis
% yla = zeros(l,1); 
% yla(1:2:end) = xl; % supersampling
% yl = conv(yla, gl); % filtering
% 
% yha = zeros(l,1); 
% yha(1:2:end) = xh; % supersampling
% yh = conv(yha, gh); % filtering
% 
% y = yl(2:end) + yh(2:end); % excluding the first sample this time

% analysis
xla = conv(x, fl); % filtering
xl = xla(2:2:end); % subsampling
xha = conv(x, fh);
xh = xha(2:2:end); % necessary to exclude the first sample to preserve the block length

% room for manipulation with xl & xh

% synthesis
yla = zeros(l,1); 
yla(1:2:end) = xl; % supersampling
yl = conv(yla, gl); % filtering

yha = zeros(l,1); 
yha(1:2:end) = xh; % supersampling
yh = conv(yha, gh); % filtering

y = yl(1:end-1) + yh(1:end-1); % now necessary to exclude the last sample to cancel out the time shift