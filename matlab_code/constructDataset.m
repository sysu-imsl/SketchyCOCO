% parameters which can be changed to fit users need
% val2 and val for building val dataset
% val and train for building valInTrain dataset
% train and train for building trainInTrain dataset
type = 'val2';
type2 = 'val';
version = 'V1'; % the version of the new dataset
root = '/home/xuqi/Desktop/work/edgeGANaddRef'; % the root path of the project
coco_path = '/home/xuqi/Desktop/first'; % the path of the COCOAPI


% fixed parameters
thing_annotation = sprintf('%s/cocostuff/dataset/annotations/instances_%s2017.json', coco_path, type2);
stuff_annotation = sprintf('%s/cocostuff/dataset/annotations/stuff_%s2017.json', coco_path, type2);
image_file = sprintf('%s/cocostuff/dataset/images/%s2017/', coco_path, type2);
thing_catIds = [2, 3, 4, 5, 10, 11, 17, 18, 19, 20, 21, 22, 24, 25];
stuff_catIds = [106, 124,  157, 169];

if strcmpi(type, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type);
end

% generate background sketches
stuff_dir = sprintf('%s/data/Others/background/images/%s/', root, name);
root_sketch_dir = sprintf('%s/data/Others/background/sketches/%s/', root, version);
generateAll(name, stuff_annotation, root_sketch_dir, stuff_dir, type2, root);


% generate scene sketches and annotations for segmentation
out_root_dir = sprintf('%s/data/Scene/Annotation/%s/', root, version);
backgroud_path = sprintf( '%s/data/Others/background/sketches/%s/%s/', root, version, name);
instance_path = sprintf('%s/data/Others/foreground/sketches/%s/%s/', root, version, name); 

filter_file = sprintf('%s/data/Scene/GT/%s/', root, name);

buildAll(name, thing_catIds, stuff_catIds, out_root_dir, thing_annotation, stuff_annotation, filter_file, backgroud_path, image_file, instance_path);

thing_catIds = [];
stuff_catIds = [];
is_all = 0;
background_path = sprintf('%s/data/Others/background/sketches/%s/%s/', root, version, name);
foreground_path = sprintf('%s/data/Others/foreground/', root);
sketch_path = sprintf('%s/data/Scene/Sketch/%s', root, version);
gen_path = sprintf('%s/data/Others/intermediate product/%s', root, version);

reconstructTrainOrVal(stuff_annotation, thing_annotation, stuff_catIds, thing_catIds, image_file, filter_file, background_path, foreground_path, sketch_path, gen_path, name, version, is_all);

% build datas for background training

out_file = sprintf('%s/data/Others/background_training/%s/%s/', root, version, name);
mkdirByPath(out_file);
sketch_file = sprintf('%s/data/Others/background/sketches/%s/%s/', root, version, name);

is_first = 1;

deleteOtherStuff(stuff_annotation, out_file, sketch_file, is_first, filter_file, image_file);

deleteOtherStuff(stuff_annotation, out_file, sketch_file, ~is_first, filter_file, image_file);
