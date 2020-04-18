function [  ] = deleteSpace( target )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%     target = '/home/xuqi/Desktop/dataset/outdoor/mergedImage2/sketch/*.jpg';
%     origin = '/home/xuqi/Desktop/dataset/outdoor/mergedImage2/image';
%     target = '/home/xuqi/Desktop/dataset/merged_for_pick/train/sketch/*.jpg';
%     origin = '/home/xuqi/Desktop/dataset/merged_for_pick/train/origin';
    
    cates = dir(target);
    total = 0;
    for i = 3:length(cates)
        
        cur_dir = fullfile(target, cates(i).name);
        if ~isdir(cur_dir)
            cur_dir = target;  
        end
        sketches = dir(cur_dir);
        for j = 3:length(sketches)
            file_name = fullfile(cur_dir, sketches(j).name);
%             origin_file = fullfile(origin, dirs(i).name);
            img = imread(file_name);
            [h, w, dim] = size(img);
    %         length(find(img == 255))

            if h * w * dim == length(find(img == 255))
                delete(file_name);
    %             delete(origin_file);
                total = total + 1;
            end
        end
        
        if ~isdir(fullfile(target, cates(i).name))
            sprintf('%s delete %d', target, total)
            break;
        else
            sprintf('%s delete %d', cates(i).name, total)
        end
        total = 0;
    end
    
end

