type = 'val2';
type2 = 'val';
version = 'V1';
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
annotation_path = '/home/xuqi/Desktop/first/cocostuff/dataset/annotations';
stuff_annotation = sprintf('%s/stuff_%s2017.json', annotation_path, type2);


if strcmpi(type, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type);
end
stuff_dir = sprintf('%s/data/Others/background/images/%s/', root, name);
root_sketch_dir = sprintf('%s/tdata/Others/background/sketches/%s/', root, version);

generateAll(name, stuff_annotation, root_sketch_dir, stuff_dir, type2, root);
