function [  ] = deleteOtherStuff( stuff_annotation, out_file, sketch_file, is_first, avail_file, image_file )
% to produce valid image by two stage
% and then use makeSomeNoise.m to solve a problem by white edge
%   此处显示详细说明

    if is_first == 1
        file_path = image_file;
    else
        file_path = out_file;
    end
    
    files = dir(avail_file);
    nums = length(files);
%     stuff_ids = [106, 124, 157, 169];
    coco = CocoApi(stuff_annotation);
    tic
    for index = 3 : nums
        cur_name = files(index).name;
        cells = strsplit(cur_name, '.');
        if is_first == 1
            cur_image = imread(fullfile(file_path, [cells{1} '.jpg']));
        else
            cur_image = imread(fullfile(file_path, cur_name));
        end
        [~, ~, d] = size(cur_image);
        image_id = str2double(cells{1});
        annIds = coco.getAnnIds('imgIds', [image_id]);
        ann_nums = length(annIds);
        valid_num = 0;
        annotaitions = coco.loadAnns(annIds);
%         subplot(2, 1, 1)
%         imshow(cur_image)
        for j = 1 : ann_nums
            cur_anno = annotaitions(j);
            if cur_anno.category_id == 183
                continue;
            else
                if is_first == 1
                    mask = MaskApi.decode(cur_anno.segmentation);
                    if d == 3
                        masks = cat(3, mask, mask, mask);
                    else
                        masks = mask;
                    end
                    cur_image(masks == 1) = 255;
                    cur_sketch = fullfile(sketch_file, int2str(cur_anno.category_id), [int2str(cur_anno.id) '.png']);
                    if exist(cur_sketch, 'file') == 0
                        continue;
                    end
                    valid_num = valid_num + 1;
                else
                    cur_sketch = fullfile(sketch_file, int2str(cur_anno.category_id), [int2str(cur_anno.id) '.png']);
                    if exist(cur_sketch, 'file') == 0
                        continue;
                    end
                    valid_num = valid_num + 1;
                    cur_ske = imread(cur_sketch);
                    x = floor(cur_anno.bbox(1));
                    y = floor(cur_anno.bbox(2));
                    width = floor(cur_anno.bbox(3));
                    height = floor(cur_anno.bbox(4));

                    if x == 0
                        x = x + 1;
                        width = width - 1;
                    end

                    if y == 0
                        y = y + 1;
                        height = height - 1;
                    end

                    try
                        partial_origin = cur_image(y:y+height, x:x+width, :);
                    catch Error
                        disp(Error);
                        size(cur_image)

                    end
                    new_partial = combineFilteredAndSketch(partial_origin, cur_ske);
                    cur_image(y:y+height, x:x+width, :) = new_partial;
                end
            end
        end
        if valid_num > 0
            imwrite(cur_image, fullfile(out_file, [cells{1} '.png']));
        end
    end
    toc
end

