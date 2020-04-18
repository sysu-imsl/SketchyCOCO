function [  ] = reconstructTrainOrVal( stuff_annotation, thing_annotation, stuff_catIds, thing_catIds, image_file, avail_file, background_path, foreground_path, sketch_path, gen_path, name, version, is_all  )
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
%     thing_catIds = [2 , 3 , 4 , 5 , 8 , 10 , 11 , 15 , 17 , 18 , 19 , 20 , 21 , 22 , 23 , 24 , 25  , 28 , 43 , 44 , 46 , 47 , 49 , 50 , 52 , 53 , 58 , 59 , 62 , 63  , 85 , 87 , 88];
%     stuff_catIds = [95,96, 97, 106, 119, 122, 124, 127, 128, 129, 134, 135, 142, 147, 148, 155, 157, 158, 159, 163, 169, 170, 178];
    is_sketch = 1;
    
    mkdirByPath(gen_path);
    mkdirByPath(sketch_path);
    merge_path = sprintf( '%s/%s/', gen_path, name);
    mergedsketch_path = sprintf('%s/%s/', sketch_path,name);

    
    mkdirByPath(merge_path);
    mkdirByPath(mergedsketch_path);
    
    
    tic
    coco_stuff = CocoApi(stuff_annotation);
    reconstruct_to_origin_instance(coco_stuff, stuff_catIds, image_file, merge_path, background_path, avail_file, is_all );
    deleteSpace(merge_path);
    toc
    tic
    copyToAnotherDir(merge_path, mergedsketch_path);
    toc
    
    foreground_path1 = sprintf('%s/generated/%s/%s/', foreground_path, version, name);
    foreground_path2 = sprintf('%s/sketches/%s/%s/', foreground_path, version, name);

    coco_thing = CocoApi(thing_annotation);
    tic
    reconstruct_from_annotations(coco_thing, thing_catIds, image_file, merge_path, foreground_path1, avail_file, is_all, ~is_sketch);
    reconstruct_from_annotations(coco_thing, thing_catIds, image_file, mergedsketch_path, foreground_path2, avail_file, is_all, is_sketch);
    toc
end
