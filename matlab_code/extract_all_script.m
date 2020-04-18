
type2 = 'val';
type = 'val2';
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
coco_path = '/home/xuqi/Desktop/first';
root_foreground =sprintf('%s/data/Others/foreground/images/', root);
root_background = sprintf('%s/data/Others/background/images/', root);
thing_annotation = sprintf('%/cocostuff/dataset/annotations/instances_%s2017.json', coco_path, type2);
stuff_annotation = sprintf('%s/cocostuff/dataset/annotations/stuff_%s2017.json', coco_path, type2);
image_file = sprintf('%s/cocostuff/dataset/images/%s2017/', coco_path, type2);

stuff_catIds = [106, 124, 157, 169];
thing_catIds = [2, 3, 4, 5, 10, 11, 17, 18, 19, 20, 21, 22, 24, 25];
is_stuff = 1;
is_crowd = 0;
is_all = 1;


if strcmpi(type, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type);
end
filter_file = sprintf('%s/data/Scene/GT/%s/', root, name);
tic
extract_all(name, thing_annotation, image_file, thing_catIds, filter_file, ~is_stuff, ~is_all, is_crowd, root_foreground);
toc

tic
extract_all(name, stuff_annotation, image_file, stuff_catIds, avail_file, is_stuff, ~is_all, is_crowd, root_background);
toc