clear all;
G = tf(1, [5 1], 'iodelay', 3);
[~, ~, wcg, ~] = margin(G);
freq_num = 1000;
freq_seq = (1 : freq_num) / freq_num * wcg;
gain = tf_gain(G, freq_seq);
totalTime = 100;
splInvl = 2;
stepRsp = step(G, 0 : splInvl : totalTime);
dataLen = length(stepRsp);
d1 = 1;
d2 = 2;
h1 = 0.5;
h2 = 0.5;
noiseStd = 0.03;
outlier_num = [0, 1, 3, 5];
outlier_amplitude = 1;
test_num = 100;
h = waitbar(0, [num2str(0), '/', num2str(length(outlier_num) * test_num)]);
for n = 1 : length(outlier_num)
    freq_err_list_huber{n} = [];
    freq_err_list_mse{n} = [];
    input_list{n} = [];
    output_list{n} = [];
    num_list_huber{n} = [];
    den_list_huber{n} = [];
    delay_list_huber{n} = [];
    num_list_mse{n} = [];
    den_list_mse{n} = [];
    delay_list_mse{n} = [];
    for i = 1 : test_num
        [input, output] = relay_data_generate(stepRsp, d1, d2, h1, h2, noiseStd);
        output = add_outlier(output, outlier_num(n), outlier_amplitude);
        input_list{n} = [input_list{n}; input'];
        output_list{n} = [output_list{n}; output'];
        idCase = relayid(input, output, splInvl, 'foptd', 'maxDelay', 10, 'settlingTime', 20);
        [num_huber, den_huber, delay_huber, suc_huber] = identify(idCase, 'rank', 'isKOptimized', true, 'loss', 'huber', 'delta', 0.09);
        [num_mse, den_mse, delay_mse, suc_mse] = identify(idCase, 'rank', 'isKOptimized', true, 'loss', 'mse');
        if suc_huber
            num_list_huber{n} = [num_list_huber{n}; num_huber];
            den_list_huber{n} = [den_list_huber{n}; den_huber];
            delay_list_huber{n} = [delay_list_huber{n}; delay_huber];
            G_huber = tf(num_huber, den_huber, 'iodelay', delay_huber);
            gain_huber = tf_gain(G_huber, freq_seq);
            relative_err = abs(gain_huber - gain) ./ abs(gain);
            freq_err_list_huber{n} = [freq_err_list_huber{n}; max(relative_err)];
        end
        if suc_mse
            num_list_mse{n} = [num_list_mse{n}; num_mse];
            den_list_mse{n} = [den_list_mse{n}; den_mse];
            delay_list_mse{n} = [delay_list_mse{n}; delay_mse];
            G_mse = tf(num_mse, den_mse, 'iodelay', delay_mse);
            gain_mse = tf_gain(G_mse, freq_seq);
            relative_err = abs(gain_mse - gain) ./ abs(gain);
            freq_err_list_mse{n} = [freq_err_list_mse{n}; max(relative_err)];
        end
        waitbar(((n - 1) * test_num + i) / (length(outlier_num) * test_num), h, [num2str((n - 1) * test_num + i), '/', num2str(length(outlier_num) * test_num)]);
    end
end
close(h);
    