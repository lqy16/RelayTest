G = tf(1, [5 1], 'iodelay', 3);
totalTime = 98;
splInvl = 2;
stepRsp = step(G, 0 : splInvl : totalTime);
dataLen = length(stepRsp);
settlingTime = 98;
settlingTimeIndex = round(settlingTime / splInvl) + 1;
d1 = 1;
d2 = 2;
h1 = 0.5;
h2 = 0.5;
noiseStd = 0.03;
[input, output] = relay_data_generate(stepRsp, d1, d2, h1, h2, noiseStd);
% plot(input);
% hold on;
% plot(output);
inputDiff = input - [0; input(1 : end - 1)];
coeffMat = zeros(dataLen, dataLen);
for i = 1 : dataLen
    for j = 1 : i
        coeffMat(i, j) = inputDiff(i - j + 1);
    end
end
%estStepRsp = (coeffMat * [eye(settlingTimeIndex), zeros(settlingTimeIndex, 1); zeros(dataLen - settlingTimeIndex, settlingTimeIndex), ones(dataLen - settlingTimeIndex, 1)]) \ output;
estStepRsp = coeffMat \ output;
plot((0 : splInvl : totalTime), estStepRsp);
xlabel('时间 (s)');
ylabel('估计的阶跃响应');