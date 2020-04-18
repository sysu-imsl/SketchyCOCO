thing_catIds = [2, 3, 4, 5, 10, 11, 17, 18, 19, 20, 21, 22, 23, 24, 25];
stuff_catIds = [106, 124,  157, 169];
type = 'train';
type2 = 'train';

if strcmpi(type2, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type2);
end
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
version = 'paper_version';
out_root_dir = sprintf('%s/data/Scene/Annotations/%s/', root, version);
backgroud_path = sprintf( '%s/data/Others/background/sketches/%s/%s/', root, version, name);
instance_path = sprintf('%s/data/Others/foreground/sketches/%s/%s/', root, version, name); 
thing_annotation = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/annotations/instances_%s2017.json', type);
stuff_annotation = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/annotations/stuff_%s2017.json', type);
image_file = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/images/%s2017/', type);

if strcmpi(type2, 'val2')
    filter_file = sprintf('/home/xuqi/Desktop/dataset/train_for_pix2pix_versions/exceptStuff2/exceptCroppedDeleted0.5/%s/', type);
else
    filter_file = sprintf('/home/xuqi/Desktop/dataset/update_outdoor/extractExceptStuff/model/%s/', type2);
end



buildAll(name, thing_catIds, stuff_catIds, out_root_dir, thing_annotation, stuff_annotation, filter_file, backgroud_path, image_file, instance_path);