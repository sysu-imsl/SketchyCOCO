function [  ] = buildAnnotation( coco, catIds, image_file, mask_path, class_path, update_outdoor, isStuff, instance_path, reference_path, avail_file, bbox_path, is_instance )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    images = dir(avail_file);
    imgIds = 1:1:(length(images)-2);
    for index = 3 : length(images)
        cur_name = images(index).name;
        cells = strsplit(cur_name, '.');
        imgIds(index-2) = str2double(cells{1});
    end
    if isStuff
        stuff_mask_path = [instance_path 'INSTANCE_GT'];
        stuff_class_path = [instance_path 'CLASS_GT'];
    end


    annIds = coco.getAnnIds('imgIds', imgIds,'catIds',catIds,'iscrowd', [0]);
    annotations = coco.loadAnns(annIds);
    INSTANCE_GT = [];
    CLASS_GT = [];
    BBOX = [];
%     BBOX_I = [];
    
    file_name = '1';
    temp = -1;
    for annotation = annotations
         image_id = annotation.image_id;
        if temp ~= image_id
            if temp ~= -1
                pre = strsplit(file_name, '.');
                pre = pre{1};
                bbox_out = [bbox_path, pre];
%                 bbox_i_out = [bbox_i_path, pre];
                mask_out = [mask_path, pre];
                class_out = [class_path, pre];
                
                save(bbox_out, 'BBOX');
%                 save(bbox_i_out, 'BBOX_I');
                
                save(mask_out, 'INSTANCE_GT');
                save(class_out, 'CLASS_GT');
                
            end
            temp = image_id;
            img_infor = coco.loadImgs([temp]);
            file_name = img_infor.file_name;
%             out_file = [merge_path file_name];
            pre = strsplit(file_name, '.');
            pre = pre{1};
            bbox_out = [bbox_path, pre];
%             bbox_i_out = [bbox_i_path, pre];
            mask_out = [mask_path, pre];
            class_out = [class_path, pre];
%             exist(out_file, 'file')
            if exist([bbox_out '.mat'], 'file') == 0
                I = imread([image_file file_name]);
                
                [h, w, ~] = size(I);
                BBOX = zeros([h, w]);
            else
                BBOX = load([bbox_out '.mat'], 'BBOX');
                BBOX = BBOX.BBOX;
            end
            
            
            if exist([mask_out '.mat'], 'file') == 0
                I = imread([image_file file_name]);
                if reference_path ~= -1
                    imwrite(I, [reference_path file_name]);
                end
                
                [h, w, ~] = size(I);
                INSTANCE_GT = zeros([h, w]);
            else
                INSTANCE_GT = load([mask_out '.mat'], 'INSTANCE_GT');
                INSTANCE_GT = INSTANCE_GT.INSTANCE_GT;
            end
            
            if exist([class_out '.mat'], 'file') == 0
                I = imread([image_file file_name]);
                [h, w, ~] = size(I);
                CLASS_GT = zeros([h, w]);
            else
                CLASS_GT = load([class_out '.mat'], 'CLASS_GT');
                CLASS_GT = CLASS_GT.CLASS_GT;
            end
            
        end
        id = annotation.id;
        cId = annotation.category_id;
        sketch_path = [instance_path num2str(cId) '/' num2str(id) '.png'];

        if exist(sketch_path, 'file') == 0
            continue;
        end
        
        
        
        cur_cate = find(update_outdoor == cId);
        x = floor(annotation.bbox(1));
        y = floor(annotation.bbox(2));
        width = floor(annotation.bbox(3));
        height = floor(annotation.bbox(4));
        x = max(x, 1);
        y = max(y, 1);
        
        try
            bbox_class = CLASS_GT(y:y+height-1, x:x+width-1);
            bbox_instance = INSTANCE_GT(y:y+height-1, x:x+width-1);
        catch Error
            disp(Error);
            size(CLASS_GT)
            size(INSTANCE_GT)
            y+height-1
            x+width-1
        end
        
        if isStuff == 1
            cur_mask_path = fullfile(stuff_mask_path, [num2str(id) '.mat']);
            cur_class_path = fullfile(stuff_class_path, [num2str(id) '.mat']);
            cur_INSTANCE_GT = load(cur_mask_path, 'INSTANCE_GT');
            cur_INSTANCE_GT = cur_INSTANCE_GT.INSTANCE_GT;
            
            cur_CLASS_GT = load(cur_class_path, 'CLASS_GT');
            cur_CLASS_GT = cur_CLASS_GT.CLASS_GT;
            cur_temp_class = cur_CLASS_GT(1:height, 1:width);
            avail_pos_class = cur_temp_class ~= 0;
            bbox_class(avail_pos_class) = cur_temp_class(avail_pos_class);
            CLASS_GT(y:y+height-1, x:x+width-1) = bbox_class;
            [h_IN, w_IN, ~] = size(cur_INSTANCE_GT); 
            temp = zeros([h_IN, w_IN]);
            

            max_instances = max(INSTANCE_GT(:));
            temp(temp == 0) = max_instances;
            cur_INSTANCE_GT = cur_INSTANCE_GT + temp;
            cur_INSTANCE_GT(cur_INSTANCE_GT == max_instances) = 0;
            cur_temp_instance = cur_INSTANCE_GT(1:height, 1:width);
            avail_pos_instance = cur_temp_instance ~= 0;
            bbox_instance(avail_pos_instance) = cur_temp_instance(avail_pos_instance);
            INSTANCE_GT(y:y+height-1, x:x+width-1) = bbox_instance;
        else
            sketch = imread(sketch_path);
        
            if isStuff == 0

                [~, ~, cDim] = size(sketch);
                %sketch = imresize(sketch, size(bbox_class));
                 sketch = ResizeBySmall(sketch, height, width, cDim, 1);

            else
                sketch = imresize(sketch, size(bbox_class));
            end
   
            if length(size(sketch)) == 3
                bbox_class(sketch(:, :, 1) == 0) = cur_cate;

                max_instance = max(INSTANCE_GT(:));
                bbox_instance(sketch(:, :, 1) == 0) = max_instance + 1;
            else

                bbox_class(sketch == 0) = cur_cate;

                max_instance = max(INSTANCE_GT(:));
                bbox_instance(sketch == 0) = max_instance + 1;
            end
            
%             if height > width
%                 delta = (height - width) / 2;
%                 [h, w, ~] = size(BBOX);
%                 temp_bbox = zeros([h, w]);
%                 temp_bbox(y+delta-1:y+delta-1+width, x:x+width-1) = cur_cate;
% %                 BBOX_I(y+delta-1:y+delta-1+width, x:x+width-1) = max_instance + 1;
%             else
%                 delta = (width - height) / 2;
%                 [h, w, ~] = size(BBOX);
%                 temp_bbox = zeros([h, w]);
%                 temp_bbox(y:y+height-1, x+delta-1:x+delta-1+height) = cur_cate;
% %                 BBOX_I(y:y+height-1, x+delta-1:x+delta-1+height) = max_instance + 1;
%             end
            [h, w, ~] = size(BBOX);
            temp_bbox = zeros([h, w]);
            temp_bbox(y:y+height-1, x:x+width-1) = cur_cate;
            BBOX = cat(3, BBOX, temp_bbox);
          
           
            
            
            CLASS_GT(y:y+height-1, x:x+width-1) = bbox_class;
            INSTANCE_GT(y:y+height-1, x:x+width-1) = bbox_instance;
        end
        
    end
    pre = strsplit(file_name, '.');
    pre = pre{1};
    
    
    bbox_out = [bbox_path, pre];
    mask_out = [mask_path, pre];
    class_out = [class_path, pre];

    save(bbox_out, 'BBOX');

    
    save(mask_out, 'INSTANCE_GT');
    save(class_out, 'CLASS_GT');
end

