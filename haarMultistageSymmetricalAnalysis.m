function output = haarMultistageSymmetricalAnalysis(input, numStages)
% input: single-column signal
% output: signal in bands, starting with the highest frequency band
l = length(input);

output = input;

for i = 0 : (numStages - 1)
    numBands = 2^i;
    bandSize = l / numBands;
    for j = 1 : numBands
        output((j-1) * bandSize + 1 : j * bandSize) = ...
            haarAnalysisFilter(output((j-1) * bandSize + 1 : j * bandSize));
    end
end

end
