function [  ] = buildAll( name, thing_catIds, stuff_catIds, out_root_dir, thing_annotation, stuff_annotation, avail_file, stuff_root_seg, image_file, instance_paths )
%   为分割模块准备训练数据
%   
    
    
    mask_file = sprintf([out_root_dir '%s/INSTANCE_GT/'], name);
    class_file = sprintf([out_root_dir '%s/CLASS_GT/'], name);
    bbox_class = sprintf([out_root_dir '%s/BBOX/'], name);
    reference_file = sprintf([out_root_dir '%s/reference_image/'], name);
    mkdirByPath(mask_file);
    mkdirByPath(class_file);
    mkdirByPath(reference_file);    
    mkdirByPath(bbox_class);

    
    update_outdoor = [thing_catIds, stuff_catIds];
    
    
    is_stuff = 1;
    
    instance_path = stuff_root_seg;
   
    tic
    if ~isempty(find(stuff_catIds == 106, 1))
        coco_stuff = CocoApi(stuff_annotation);
    
        buildAnnotation(coco_stuff, stuff_catIds, image_file, mask_file, class_file, update_outdoor, is_stuff, instance_path, reference_file, avail_file, bbox_class, 0); 
    end
    
    toc
    
    tic
    if ~isempty(find(thing_catIds == 2, 1))
        coco = CocoApi(thing_annotation);
        buildAnnotation(coco, thing_catIds, image_file, mask_file, class_file, update_outdoor, ~is_stuff, instance_paths, reference_file, avail_file, bbox_class, 1);
    end
    toc
    
    
end

