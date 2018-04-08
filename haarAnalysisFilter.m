
function output = haarAnalysisFilter(input)
% Single-stage Haar analysis filter
% Haar analysis filters
fl = [1, 1]/sqrt(2);
fh = [-1, 1]/sqrt(2);

outputL = conv(input, fl); % filtering
outputL = outputL(2:2:end); % subsampling
outputH = conv(input, fh);
outputH = outputH(2:2:end); % necessary to exclude the first sample to preserve the block length
% output = vertcat(outputH, outputL); %just trial. Return to dual output if errors occur

output = vertcat(outputH,outputL);