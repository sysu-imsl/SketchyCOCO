% parameters which can be changed to fit users need
% val2 and val for building val dataset
% val and train for building valInTrain dataset
% train and train for building trainInTrain dataset
type = 'val2';
type2 = 'val';
version = 'paper_version'; % the version of the new dataset
root = '/home/xuqi/Desktop/work/edgeGANaddRef'; % the root path of the project
image_width = 256;

if strcmpi(type, 'val2')
    name = 'val';
else
    name = sprintf('%sInTrain', type);
end

background_training = sprintf('%s/data/Others/background_training/%s/%s/', root, version, name);
GT = sprintf('%s/data/Scene/GT/%s/', root, name);
output = sprintf('%s/data/Scene/Pairs/%d/%s/%s/', root, image_width, version, name);

mkdirByPath(output);
combine(GT, background_training, output, image_width);
