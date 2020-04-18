clear
tic
% Parameters
Gamma = 0.945;
Phi = 200;
Epsilon = -0.1;
k = 1.6;
Sigma = 0.6;

type = 'train';
root = '/home/xuqi/Desktop/work/edgeGANaddRef';
origin_files = sprintf('%s/data/Object/GT/%s/', root, type);
edge_files = sprintf('%s/data/Object/Edge/%s/', root, type);

origin_dirs = dir(origin_files);

for index = 3 : length(origin_dirs)
    cur_name = origin_dir(index).name;
    origin_dir = sprintf('%s/%s/', origin_files, cur_name);
    
    output_dir = sprintf('%s/%s/', edge_files, cur_name);

    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    originList = dir(fullfile(origin_dir));
    nOriginfile = numel(originList);

    fprintf('origin num: %d\n', nOriginfile-2);
    for n = 1 : nOriginfile
        disp('');
        disp(string(n)+'/'+string(nOriginfile));
        fileName = originList(n).name;
        if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
            originFilePath = fullfile(origin_dir, originList(n).name);
            outputFilePath = fullfile(output_dir, fileName);
            inputIm = imread(originFilePath);
            
            if size(inputIm,3) == 3
                inputIm = rgb2gray(inputIm);
            end
            inputIm = im2double(inputIm);

            % Gauss Filters
            gFilteredIm1 = imgaussfilt(inputIm, Sigma);
            gFilteredIm2 = imgaussfilt(inputIm, Sigma * k);

            differencedIm2 = gFilteredIm1 - (Gamma * gFilteredIm2);

            x = size(differencedIm2,1);
            y = size(differencedIm2,2);

            % Extended difference of gaussians
            for i=1:x
                for j=1:y
                    if differencedIm2(i, j) < Epsilon
                        differencedIm2(i, j) = 1;
                    else
                        differencedIm2(i, j) = 1 + tanh(Phi*(differencedIm2(i,j)));
                    end
                end
            end

            % XDoG Filtered Image
            % figure, imshow(mat2gray(differencedIm2));

            XDOGFilteredImage = mat2gray(differencedIm2);

            % take mean of XDoG Filtered image to use in thresholding operation
            meanValue = mean2(XDOGFilteredImage);

            x = size(XDOGFilteredImage,1);
            y = size(XDOGFilteredImage,2);

            % thresholding
            for i=1:x
                for j=1:y
                    if XDOGFilteredImage(i, j) <= meanValue
                        XDOGFilteredImage(i, j) = 0.0;
                    else
                        XDOGFilteredImage(i, j) = 1.0;
                    end
                end
            end

            % figure, imshow(mat2gray(XDOGFilteredImage));

            %create XDoG Filtered Image and the thresholded one
    %         imwrite(mat2gray(differencedIm2), outputFilePath);
    %         str1 = outputFilePath(1:end-4);
    %         imwrite(mat2gray(XDOGFilteredImage), [str1 '_Thresholded.jpg']);
            imwrite(mat2gray(XDOGFilteredImage), outputFilePath);

        end
    end
end
toc
