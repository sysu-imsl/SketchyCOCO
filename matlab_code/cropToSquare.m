function [ output, out_width ] = cropToSquare( input, targetWidth )
%UNTITLED9 此处显示有关此函数的摘要
%   此处显示详细说明
    [w, h, d] = size(input);
    
    
    if w > h
        ratio = targetWidth / h;
        out_width = h;
        [w, h, ~] = size(input);
        delta = w - h;
        if delta == 1
            deltaX = 1;
        else
            deltaX = floor(delta / 2);
        end
        
        output = input(deltaX:w+deltaX-delta - 1, :, :);
    elseif w < h
        ratio = targetWidth / w;
        out_width = w;
        
        [w, h, ~] = size(input);
        
        delta = h - w;
        if delta == 1
            deltaY = 1;
        else
            deltaY = floor(delta / 2);
        end
%         deltaY = floor(delta / 2);
        output = input(:, deltaY:h+deltaY-delta - 1 , :);
    else
        out_width = w;
        output = input;
    end
   % output = imresize(output, ratio);
    if d ~= 3
%         input = imresize(output, ratio);
%         output = cat(3, input, input, input);
    end
end

