function [  ] = copyToAnotherDir( source_dir, target_dir )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    images = dir(source_dir);
    nums = length(images);
    for index = 3:nums
        cur_name = images(index).name;
        copyfile(fullfile(source_dir, cur_name), fullfile(target_dir, cur_name));
    end

end

