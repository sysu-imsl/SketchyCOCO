function [ annos ] = extract_image_examples( coco, catIds, image_file, type, avail_file, is_stuff, is_crowd, is_all, root_out )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

    images = dir(avail_file);
    imgIds = 1 : 1 : (length(images) - 2);
    for index = 3 : length(images)
        file_name = images(index).name;
        cells = strsplit(file_name, '.');
        imgIds(index-2) = str2double(cells{1});
    end
    if is_all == 1
        imgIds = [];
    end
    if is_stuff == 1
        annIds = coco.getAnnIds('imgIds', imgIds,'catIds',catIds);
    else
        annIds = coco.getAnnIds('imgIds', imgIds,'catIds',catIds, 'iscrowd', is_crowd);
    end

    annos = coco.loadAnns(annIds);

    for anno = annos
        image_id = anno.image_id;
        img = coco.loadImgs(image_id);
        s = img.height * img.width;
        img_name = [image_file img.file_name];
        I = imread(img_name);
        extract_example( I, anno, img.file_name, s, type, is_stuff, is_crowd, root_out);
    end

end

