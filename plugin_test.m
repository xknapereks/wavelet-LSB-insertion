

x = audioread('/home/maco/Documents/FEI/diplomovka/coding/kralovany_synth.mp3');
x = x(3100:end,1);
x = x(513:1024);

[xh, xl] = haarAnalysisFilter(x);
y = haarSynthesisFilter(xh, xl);

% myslienka: nejako to zoptimalizovat, aby sa dalo ratat paralelne viacero
% vetveni. Konvolucia vsak nevie ratat celu maticu, bude treba pouzit cykly