function [  ] = extract_example( img, annotation, img_name, s, type, is_stuff, is_crowd, root_out )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    [h, w, d] = size(img);
    pre_file = sprintf([root_out '%s/' num2str(annotation.category_id) '/'], type);
    
    
    mkdirByPath(pre_file);
    
    if annotation.area / s <= 0.03
        return ;
    end
    
    cells = strsplit(img_name, '.');
    %imwrite(img, [img_file cells{1} '.png']);
    if is_crowd == 0 && is_stuff ~= 1
        file_path = [pre_file num2str(annotation.id) '.png'];
        rs = MaskApi.frPoly(annotation.segmentation, h, w);
    else
        file_path = [pre_file num2str(annotation.id) '.png'];
        rs = annotation.segmentation;
    end
    mask = MaskApi.decode(rs);
    if d == 3
        masks = cat(3, mask, mask, mask);
    else
        masks = mask;
    end
    img(masks == 0) = 255;
    imwrite(imcrop(img, floor(annotation.bbox)), file_path);

end

