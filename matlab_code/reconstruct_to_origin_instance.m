function [  ] = reconstruct_to_origin_instance( coco, catIds, image_file, output_path, instance_path, avail_file, is_all )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
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
                imwrite(uint8(cur_image), fullfile(output_path, [cells{1} '.png']));
            end
            temp = image_id;
            img_infor = coco.loadImgs([temp]);
            file_name = img_infor.file_name;

            cells = strsplit(file_name, '.');
            out_file = [output_path cells{1} '.png'];

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
        sketch_path = [instance_path num2str(annotation.category_id) '/' num2str(id) '.png'];
        

        if exist(sketch_path, 'file') == 0
            continue;
        end
        instance = imread(sketch_path);
        [~, ~, dim2] = size(instance);
        
        if dim2 < dim
            instance = cat(3, instance, instance, instance);
        end
        
        x = floor(annotation.bbox(1));
        y = floor(annotation.bbox(2));
        width = floor(annotation.bbox(3));
        height = floor(annotation.bbox(4));
        
        if x == 0
            x = x + 1;
            width = width - 1;
        end
        
        if y == 0
            y = y + 1;
            height = height - 1;
        end
        try
            bbox_image = cur_image(y:y+height, x:x+width, 1:dim);
        catch Error
            disp(Error);
            size(cur_image)

        end
        if dim == 1
            available_pos = instance ~= 255;            
            bbox_image(available_pos) = instance(available_pos);
        else
            available_pos = instance(:, :, 1) ~= 255 & instance(:, :, 2) ~= 255 & instance(:, :, 3) ~= 255;
            available_poses = cat(3, available_pos, available_pos, available_pos);
            
            bbox_image(available_poses) = instance(available_poses);
        end
        cur_image(y:y+height, x:x+width, :) = bbox_image;
    end
    
    if dim == 1
        cur_image = cat(3, cur_image, cur_image, cur_image);
    end
    cells = strsplit(file_name, '.');
    imwrite(uint8(cur_image), fullfile(output_path, [cells{1} '.png']));
    
end

