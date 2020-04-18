function [  ] = generateAll( name, annotation, root_dir, stuff_dir, type, root )
    
    mkdirByPath(root_dir);
    coco = CocoApi(annotation);
    output_dir = sprintf([root_dir '%s/'], name);
    if exist(output_dir, 'file') == 0
        mkdir(output_dir);
    end
    dirs = dir(stuff_dir);
    for d = 1 : length(dirs)
        if strcmpi(dirs(d).name, '169') || strcmpi(dirs(d).name, '124') || strcmpi(dirs(d).name, '106') || strcmpi(dirs(d).name, '157')
            image_path = [fullfile(dirs(d).folder, dirs(d).name), '/'];
            if strcmpi(dirs(d).name, '157') 
                sketch_dir = sprintf('%s/data/Others/sketches_background/cloud/%s/', root, type);
                %sketch_percentage = 0.1;
                sketch_percentage = 0.15;
            elseif strcmpi(dirs(d).name, '124') 
                sketch_dir = sprintf('%s/data/Others/sketches_background/grass/%s/', root, type);
                %sketch_percentage = 0.05;
                sketch_percentage = 0.1;
            elseif strcmpi(dirs(d).name, '169') 
                %sketch_percentage = 0.15;
                sketch_percentage = 0.2;
                sketch_dir = sprintf('%s/data/Others/sketches_background/tree/%s/', root, type);
            elseif strcmpi(dirs(d).name, '106')
                
                %sketch_percentage = 0.08;
                sketch_percentage = 0.15;
                sketch_dir = sprintf('%s/data/Others/sketches_background/cloud/%s/', root, type);
            end
            out_path = fullfile(output_dir, dirs(d).name);
            thresh_hold = 0.45;
            if exist(out_path, 'file') == 0
                mkdir(out_path);
            end
            generateStuffSketch(image_path, sketch_percentage, sketch_dir, out_path, thresh_hold, output_dir, coco);
        end
    end

end

