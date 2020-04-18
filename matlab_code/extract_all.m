function [ annos ] = extract_all( type, annotation, image_file, catIds, avail_file, is_stuff, is_all, is_crowd, root_out )
%   to extract specified thing or stuff in the coco
%   

    coco = CocoApi(annotation);
    annos = extract_image_examples(coco, catIds, image_file, type, avail_file, is_stuff, is_crowd, is_all, root_out);
 
    
end

