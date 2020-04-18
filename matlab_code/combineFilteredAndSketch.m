function [ filtered ] = combineFilteredAndSketch( filtered, sketch )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

    [~, ~, dim] = size(filtered);
    if dim == 3
        pos = filtered(:, :, 1) == 255 & filtered(:, :, 2) == 255 & filtered(:, :, 3) == 255;
        poses = cat(3, pos, pos, pos);
    else
        poses = filtered == 255;
    end
    filtered(poses) = sketch(poses);

end

