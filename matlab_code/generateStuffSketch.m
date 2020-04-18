function [ ] = generateStuffSketch( dir_path, sketch_percentage, sketch_path, output_path, thresh_hold, output_dir, coco )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%     path to store segmentation infor
    class_out_path = [output_dir, 'CLASS_GT'];
    mask_out_path = [output_dir 'INSTANCE_GT'];
    mkdirByPath(class_out_path);
    mkdirByPath(mask_out_path);
    update_outdoor = [106, 124,  157, 169];
    thresh = 230;
    dirs = dir(dir_path);
    sketch_dir = dir([sketch_path '*.png']);
    sketch_nums = length(sketch_dir);
    tic;
    for i = 3 : length(dirs)
        cur_name = dirs(i).name;
        cells = strsplit(cur_name, '.');
        file_name = fullfile(dirs(i).folder, cur_name);
        output_img_name = fullfile(output_path, [cells{1} '.png']);
        img = imread(file_name);
        if exist(output_img_name, 'file') == 0
            output_img = zeros(size(img));
            output_img(output_img == 0) = 255;
        else
            output_img = imread(output_img_name);
        end

        [w, h, dim] = size(img);
%             build for annotation of segmentation
        cells = strsplit(dirs(i).name, '.');
        pre = cells{1};

        cur_class_gt_name = [pre, '.mat'];
        cur_mask_gt_name = [pre, '.mat'];
        if exist(fullfile(class_out_path, cur_class_gt_name), 'file') == 0
            CLASS_GT = zeros([w, h]);
        else
            CLASS_GT = load(fullfile(class_out_path, cur_class_gt_name), 'CLASS_GT');
            CLASS_GT = CLASS_GT.CLASS_GT;
        end

        if exist(fullfile(mask_out_path, cur_mask_gt_name), 'file') == 0
            INSTANCE_GT = zeros([w, h]);
        else
            INSTANCE_GT = load(fullfile(mask_out_path, cur_mask_gt_name), 'INSTANCE_GT');
            INSTANCE_GT = INSTANCE_GT.INSTANCE_GT;
        end

        annId = str2double(pre);
        ann = coco.loadAnns([annId]);
        mask = MaskApi.decode(ann.segmentation);
        cur_mask_box = imcrop(mask, floor(ann.bbox));
        bw_img = imbinarize(cur_mask_box);

        img_reg = regionprops(bw_img, 'boundingbox');

        area = ann.area;
        edge = floor(sqrt(area * sketch_percentage));
        rects = cat(1,  img_reg.BoundingBox);
        sketch_index = ceil(sketch_nums * rand(1));

        sketch_img_ = imread(fullfile(sketch_dir(sketch_index).folder, sketch_dir(sketch_index).name));
        [~, ~, dim1] = size(sketch_img_);
        if dim == 3 && dim1 == 1
            sketch_img = cat(3, sketch_img_, sketch_img_, sketch_img_);
        elseif dim == dim1
            sketch_img = sketch_img_;
        elseif dim == 1 && dim1 == 3
            sketch_img = sketch_img_(:, :, 1);
        end
        for j = 1:size(rects, 1)
            rects(j, :) = floor(rects(j, :));
            y = rects(j, 1);
            x = rects(j, 2);
            w1 = rects(j, 3);
            d1 = rects(j, 4);
            percentage = (w1 * d1) / area;
            num = floor(percentage / sketch_percentage);
            if num == 0
                continue;
            end
            is_stop = 0;
            start_newline = 1;
            x = max(1, x);
            y = max(1, y);
            cur_x = x;
            cur_y = y;
            edge_x = min(edge, d1);
            edge_y = min(edge, w1);
            end_column = 0;
            while ~is_stop
                if start_newline
                    if cur_y + edge_y <= y + w1 && cur_y + edge_y * 2 >= y + w1
                        end_column = 1;
                        edge_y = y + w1 - cur_y - 1;
                    else
                        edge_y = min(edge, w1);
                    end

                    cur_x = x;

                    start_newline = 0;
                end
                if cur_x + edge_x <= x + d1 && cur_x + 2*edge_x >= x + d1
                    start_newline = 1;

                    edge_x = x + d1 - cur_x - 1;
                    if end_column
                        is_stop = 1;
                    end
                else
                    edge_x = min(edge, d1);
                end

                available_square = cur_mask_box(cur_x:cur_x+edge_x-1, cur_y:cur_y+edge_y-1);
                available_area = length(find(available_square ~= 0));
                standard_area = edge_x * edge_y;
                if available_area / (standard_area) < thresh_hold
                    cur_x = cur_x + edge_x - 1;
                    if start_newline
                        cur_y = cur_y + edge_y - 1;
                    end
                    continue;
                end

                [out_x, out_y, out_edge] = generateOneSketch(cur_x, edge_x, cur_y, edge_y);
                img_resized = imresize(sketch_img, [out_edge, out_edge]);

                img_resized(img_resized <= thresh) = 0;
                img_resized(img_resized > thresh) = 255;

                available_pos_resized = img_resized ~= 255;

                cur_x = cur_x + edge_x - 1;
                if start_newline
                    cur_y = cur_y + edge_y - 1;
                end
                if dim == 3
                    for_CLASS_INSTANCE = img_resized(:, :, 1) ~= 255 & img_resized(:, :, 2) ~= 255 & img_resized(:, :, 3) ~= 255;
                else
                    for_CLASS_INSTANCE = img_resized ~= 255;
                end

                t_CLASS_GT = CLASS_GT(out_x:out_x + out_edge - 1, out_y:out_y + out_edge - 1);
                t_INSTANCE_GT = INSTANCE_GT(out_x:out_x + out_edge - 1, out_y:out_y + out_edge -1);

                t_CLASS_GT(for_CLASS_INSTANCE) = find(update_outdoor == ann.category_id) + 15;
                max_instance = max(INSTANCE_GT(:));
                t_INSTANCE_GT(for_CLASS_INSTANCE) = max_instance + 1;

                CLASS_GT(out_x:out_x + out_edge - 1, out_y:out_y + out_edge - 1) = t_CLASS_GT;
                INSTANCE_GT(out_x:out_x + out_edge - 1, out_y:out_y + out_edge -1) = t_INSTANCE_GT;

                temp = output_img(out_x:out_x+out_edge-1, out_y:out_y+out_edge - 1, :);

                temp(available_pos_resized) = img_resized(available_pos_resized);

                output_img(out_x:out_x+out_edge-1, out_y:out_y+out_edge - 1, :) = temp;
                    
                
            end
            
            save(fullfile(mask_out_path, cur_mask_gt_name), 'INSTANCE_GT');
            save(fullfile(class_out_path, cur_class_gt_name), 'CLASS_GT');

            cells = strsplit(output_img_name, '.');
            
            imwrite(uint8(output_img), [cells{1}, '.png']);
        end
        
    end
    toc;
end

