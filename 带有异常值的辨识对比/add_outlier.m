function outlier_seq = add_outlier(origin_seq, outlier_num, outlier_amplitude)
%ADD_OUTLIER 添加随机异常值
%   origin_seq:         初始序列
%   outlier_num:        异常值数量
%   outlier_amplitude:  异常值幅值
%   outlier_seq:        含有异常值的序列
outlier_pos = zeros(outlier_num, 1);
for i = 1 : outlier_num
    rand_pos = ceil(rand * length(origin_seq));
    while any(outlier_pos == rand_pos)
        rand_pos = ceil(rand * length(origin_seq));
    end
    outlier_pos(i) = rand_pos;
end
outlier_seq = origin_seq;
for pos = outlier_pos
    if rand > 0.5
        outlier_seq(pos) = outlier_seq(pos) + outlier_amplitude;
    else
        outlier_seq(pos) = outlier_seq(pos) - outlier_amplitude;
    end
end
end

