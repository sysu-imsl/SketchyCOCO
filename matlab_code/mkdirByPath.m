function [ is_maked ] = mkdirByPath( path )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    is_maked = exist(path, 'file');
    if exist(path, 'file') == 0
        mkdir(path);
    end

end

