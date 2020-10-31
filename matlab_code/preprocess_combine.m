clc;
clear;
tic
type = 'train';
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
image_width = 128;
origin_files = sprintf('%s/data/Object/GT/%s/', root, type);
edge_files = sprintf('%s/data/Object/Edge/%s/', root, type);
output_files = sprintf('%s/data/Object/Pairs/%d/%s/', root, image_width, type);
origin_dirs = dir(origin_files);

for index = 3 : length(origin_dirs)
    cur_name = origin_dirs(index).name;
    origin_dir = sprintf('%s/%s/', origin_files, cur_name);
    edge_dir = sprintf('%s/%s/', edge_files, cur_name);
    output_dir = sprintf('%s/%s/', output_files, cur_name);
    

    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    edgeList = dir(fullfile(edge_dir));
    nEdgefile = numel(edgeList);

    originList = dir(fullfile(origin_dir));
    nOriginfile = numel(originList);

    fprintf('edge num: %d; origin num: %d\n', nEdgefile, nOriginfile);
    if nEdgefile == nOriginfile
        for n = 1 : nEdgefile
            fileName = edgeList(n).name;
            if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
                edgeFilePath = fullfile(edge_dir, fileName);
                originFilePath = fullfile(origin_dir, originList(n).name);
                outputFilePath = fullfile(output_dir, fileName);

                E = imread(edgeFilePath);
                % E = imresize(E, [64, 64]);
                % size(E)
                [h, w, dim] = size(E);
                E_ = zeros(h, w, 3);
                if dim == 3
                    E_ = E;
                else
                    E_ = cat(3, E, E, E);
                end
                E_r = E_;
                if h < w
                    padding = floor((w-h)/2);
                    block = ones(padding, w, 3)*255;
                    E_r = [block; E_; block];
                else
                    if h > w
                        padding = floor((h-w)/2);
                        block = ones(h, padding, 3)*255;
                        E_r = [block, E_, block];
                    end
                end

                E_result = imresize(E_r, [image_width,image_width]);
    %             figure;
    %             imshow(E_result);
                O = imread(originFilePath);
                [h, w, dim] = size(O);
                O_ = zeros(h, w, 3);
                if dim == 3
                    O_ = O;
                else
                    O_ = cat(3, O, O, O);
                end
                O_r = O_;
                if h < w
                    padding = floor((w-h)/2);
                    block = ones(padding, w, 3)*255;
                    O_r = [block; O_; block];
                else if h > w
                        padding = floor((h-w)/2);
                        block = ones(h, padding, 3)*255;
                        O_r = [block, O_, block];
                    end
                end

                O_result = imresize(O_r,[image_width,image_width]);

                R = [E_result, O_result];
    %             sketch = R(:, 1:image_width, :);
    %             figure;
    %             subplot(1,2,1);
    %             imshow(E_result);
    %             subplot(1,2,2);
    %             imshow(sketch);

                imwrite(R, [outputFilePath(1:end-4), '.png']);
                % imwrite(sketch, outputFilePath);
                fprintf('process %d/%d images\n', n, nEdgefile);
            end
        end
    else
        fprintf('file num unmatch\n');
    end
end
toc
