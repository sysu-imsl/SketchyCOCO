function [  ] = reconstruct_from_annotations( coco, catIds, image_file, merge_path, instance_path, avail_file, is_all, is_sketch  )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
%     imgIds = coco.getImgIds('catIds', catIds);

    %output_instance = '/home/xuqi/Desktop/dataset/update_outdoor/scene_level_128_new/gen/';
    %output_sketch = '/home/xuqi/Desktop/dataset/update_outdoor/scene_level_128_new/sketch/';
    %read_GT = '/home/xuqi/Desktop/dataset/sketches/gen_new/val/image/';
    %output_GT = '/home/xuqi/Desktop/dataset/update_outdoor/scene_level_128_new/GT/';

    images = dir(avail_file);
    imgIds = 1 : 1 : (length(images) - 2);
    for index = 3 : length(images)
        cur_name = images(index).name;
        cells = strsplit(cur_name, '.');
        imgIds(index - 2) = str2double(cells{1});
    end
    
    if is_all == 1
        imgIds = [];
    end
    
    annIds = coco.getAnnIds('imgIds', imgIds,'catIds',catIds,'iscrowd', [0]);
    annotations = coco.loadAnns(annIds);
    
    cur_image = [];
    dim = 0;
    file_name = '1';
    temp = -1;
    for annotation = annotations
        image_id = annotation.image_id;
        if temp ~= image_id
            if temp ~= -1

                cells = strsplit(file_name, '.');
                if dim == 1
                    cur_image = cat(3, cur_image, cur_image, cur_image);
                end
                imwrite(uint8(cur_image), [merge_path cells{1} '.png']);
            end
            temp = image_id;
            img_infor = coco.loadImgs([temp]);
            file_name = img_infor.file_name;
            cells = strsplit(file_name, '.');
            out_file = [merge_path cells{1} '.png'];
            if exist(out_file, 'file') == 0
                I = imread([image_file file_name]);
                [h, w, dim] = size(I);
                cur_image = zeros([h, w, dim]);
                cur_image(cur_image == 0) = 255;
                
            else
                cur_image = imread(out_file);
                [~, ~, dim] = size(cur_image);
            end
            
        end
        id = annotation.id;

        if exist([instance_path num2str(annotation.category_id) '/' num2str(id) '.png'], 'file') == 0
            continue;
        end
        instance = imread([instance_path num2str(annotation.category_id) '/' num2str(id) '.png']);
        %instance_newname = sprintf('%d_%d.png', annotation.category_id, annotation.id);
        instance_newname = sprintf('%d.png', annotation.id);
       
%         if is_sketch == 1
%             
%             sketch_output_file = fullfile(output_sketch, num2str(image_id));
%            
%             mkdirByPath(sketch_output_file);
%             imwrite(instance, fullfile(sketch_output_file, instance_newname));
%         else
%             instance_output_file =fullfile(output_instance, num2str(image_id));
%            
%             mkdirByPath(instance_output_file);
%             imwrite(instance, fullfile(instance_output_file, instance_newname));
%         end
%         
%         read_cate_file = fullfile(read_GT, num2str(annotation.category_id));
%         GT_instance = imread(fullfile(read_cate_file, instance_newname));
%         GT_output_file = fullfile(output_GT, num2str(image_id));
%         mkdirByPath(GT_output_file);
%         imwrite(paddingToSquare(GT_instance, 128), fullfile(GT_output_file, instance_newname));
        
        
        [~, ~, dim2] = size(instance);
        if dim2 < dim
            instance = cat(3, instance, instance, instance);
        elseif dim2 > dim
            instance = rgb2gray(instance);
        end
        x = floor(annotation.bbox(1)) + 1;
        y = floor(annotation.bbox(2)) + 1;
        width = floor(annotation.bbox(3));
        height = floor(annotation.bbox(4));
        
        instance = ResizeBySmall(instance, height, width, dim, is_sketch);

        try
            
            bbox_image = cur_image(y:y+height-1, x:x+width-1, 1:dim);
        catch Error
            disp(Error);

        end
        if dim == 1
            available_pos = instance ~= 255;
            bbox_image(available_pos) = instance(available_pos);
        else
            
            available_pos = instance(:, :, 1) ~= 255 & instance(:, :, 2) ~= 255 & instance(:, :, 3) ~= 255;
            available_poses = cat(3, available_pos, available_pos, available_pos);
            bbox_image(available_poses) = instance(available_poses);
        end
        cur_image(y:y+height-1, x:x+width-1, :) = bbox_image;
    end
    cells = strsplit(file_name, '.');
    if dim == 1
        cur_image = cat(3, cur_image, cur_image, cur_image);
    end
    imwrite(uint8(cur_image), [merge_path cells{1} '.png']);
end

