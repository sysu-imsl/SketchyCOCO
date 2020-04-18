thing_catIds = [];
stuff_catIds = [];
type = 'train';
type2 = 'train';

if strcmpi(type2, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type2);
end

version = 'paper_version';
thing_annotation = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/annotations/instances_%s2017.json', type);
stuff_annotation = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/annotations/stuff_%s2017.json', type);
image_file = sprintf('/home/xuqi/Desktop/first/cocostuff/dataset/images/%s2017/', type);

if strcmpi(type2, 'val2')
    avail_file = sprintf('/home/xuqi/Desktop/dataset/train_for_pix2pix_versions/exceptStuff2/exceptCroppedDeleted0.5/%s/', type);
else
    avail_file = sprintf('/home/xuqi/Desktop/dataset/update_outdoor/extractExceptStuff/model/%s/', type2);
end

is_all = 0;

root = '/home/xuqi/Desktop/work/edgeGANaddRef';

background_path = sprintf('%s/data/Others/background/sketches/%s/%s/', root, version, name);


foreground_path = sprintf('%s/data/Others/foreground/', root);
sketch_path = sprintf('%s/tdata/Scene/Sketches/%s/', root, version);
gen_path = sprintf('%s/tdata/Others/Intermediate product/%s/', root, version);

reconstructTrainOrVal(stuff_annotation, thing_annotation, stuff_catIds, thing_catIds, image_file, avail_file, background_path, foreground_path, sketch_path, gen_path, name, version, is_all);