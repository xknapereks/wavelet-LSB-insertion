function output = haarSynthesisFilter(inputH, inputL)
% Haar synthesis filters for PR
gl = [1, 1]/sqrt(2);
gh = [1, -1]/sqrt(2);

l = 2 * length(inputL);

outputL = zeros(l,1); 
outputL(1:2:end) = inputL; % supersampling
outputL = conv(outputL, gl); % filtering

outputH = zeros(l,1); 
outputH(1:2:end) = inputH; % supersampling
outputH = conv(outputH, gh); % filtering

output = outputL(1:end-1) + outputH(1:end-1); % now necessary to exclude the last sample to cancel out the time shift
