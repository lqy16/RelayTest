function gain = tf_gain(tf, omega)
%TF_GAIN 根据传递函数和频率值向量计算增益向量
[mag, phase] = bode(tf, omega);
mag = squeeze(mag);
phase = squeeze(phase / 180 * pi);
gain = mag .* (cos(phase) + 1i * sin(phase));
end

