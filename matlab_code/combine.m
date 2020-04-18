function [] = combine(origin_dir,  edge_dir, output_dir, image_width)

mkdirByPath(output_dir)

edgeList = dir(fullfile(edge_dir));
nEdgefile = numel(edgeList);

% originList = dir(fullfile(origin_dir));
% nOriginfile = numel(originList);
nOriginfile = nEdgefile;
image_type = '.png';
fprintf('edge num: %d; origin num: %d\n', nEdgefile, nOriginfile);
if nEdgefile == nOriginfile
    for n = 1 : nEdgefile
        fileName = edgeList(n).name;
        if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
            edgeFilePath = fullfile(edge_dir, fileName);
%             originFilePath = fullfile(origin_dir, originList(n).name);
            cells = strsplit(fileName, '.');
            originFilePath = fullfile(origin_dir, [cells{1} image_type]);
            outputFilePath = fullfile(output_dir, fileName);

            E = imread(edgeFilePath);
            size(E);
            E = cropToSquare(E, image_width);
            % E = imresize(E, [64, 64]);
            
            E = imresize(E,[image_width,image_width]);
            [~, ~, dim] = size(E);
            if dim == 3
                E_ = E;
            else
                E_ = cat(3, E, E, E);
            end
            
            O = imread(originFilePath);
            O = cropToSquare(O, image_width);
            O = imresize(O,[image_width,image_width]);
            
            [~, ~, dim_O] = size(O);
            if dim_O == 3
                O_ = O;
            else
                O_ = cat(3, O, O, O);
            end
            
            
            size(E_);
            size(O_);
            R = [E_, O_];
%             imwrite(R, outputFilePath, 'Quality',100);
            imwrite(R, outputFilePath);
            fprintf('process %d/%d images\n', n, nEdgefile);
        end
    end
else
    fprintf('file num unmatch\n');
end

end