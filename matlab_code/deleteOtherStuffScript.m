% the goal of this script is makding dataset


type2 = 'val';
type = 'val2';
version = 'V1';
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
coco_path = '/home/xuqi/Desktop/first';


% fixed parameters
thing_annotation = sprintf('%s/cocostuff/dataset/annotations/instances_%s2017.json', coco_path, type2);
stuff_annotation = sprintf('%s/cocostuff/dataset/annotations/stuff_%s2017.json', coco_path, type2);
image_file = sprintf('%s/cocostuff/dataset/images/%s2017/', coco_path, type2);
if strcmpi(type, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type);
end
out_file = sprintf('%s/data/Others/background_training/%s/%s/', root, version, name);
mkdirByPath(out_file);
sketch_file = sprintf('%s/data/Others/background/sketches/%s/%s/', root, version, name);

is_first = 1;
filter_file = sprintf('%s/data/Scene/GT/%s/', root, name);

deleteOtherStuff(stuff_annotation, out_file, sketch_file, is_first, filter_file, image_file);

deleteOtherStuff(stuff_annotation, out_file, sketch_file, ~is_first, filter_file, image_file);
