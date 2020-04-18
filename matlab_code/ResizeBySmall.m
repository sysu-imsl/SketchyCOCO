function [ last ] = ResizeBySmall( img, tH, tW, dim, is_sketch )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    if tW > tH
%         scale_element = tH / cW;
        temp = imresize(img, [tH tH]);
        padding = zeros([tH, 1]);
        padding(padding == 0) = 255;
        if dim == 3
            padding = cat(3, padding, padding, padding);
        end
        left_padding_times = floor((tW - tH) / 2);
%         right_padding_times = tW - cW - left_padding_times;
        last = temp;
%         size(temp)
        try
            for i = 1 : (tW - tH)
                if i <= left_padding_times
                    temp = [padding, last];
                else
                    temp = [last, padding];
                end
                last = temp;
            end
        catch
            sprintf('padding')
            size(padding)
            sprintf('last')
            size(last)
            sprintf('tH %d', tH);
            tH
        end
            
    elseif tW < tH
%         scale_element = tW / cW;
        temp = imresize(img, [tW tW]);
        padding = zeros([1, tW]);
        padding(padding == 0) = 255;
        if dim == 3
            padding = cat(3, padding, padding, padding);
        end
        top_padding_times = floor((tH - tW) /2);
        
        last = temp;
        try 
            for i = 1 : (tH - tW)
                if i <= top_padding_times
                    temp = [padding; last];
                else
                    temp = [last; padding];
                end
                last = temp;
            end
        catch
            sprintf('padding')
            size(padding)
            sprintf('last')
            size(last)
            sprintf('tW %d', tW);
            tW
        end
            
    else
%         scale_element = tW / cW;
        last = imresize(img, [tW tW]);
        
    end
    if is_sketch == 1
        threshold =160;
        if dim == 3
            availpos = last(:, :, 1) < threshold & last(:, :, 2) < threshold & last(:, :, 3) < threshold;
            availposes = cat(3, availpos, availpos, availpos);

            last(availposes) = 0;
        else
            last(last < threshold) = 0;
        end
    else
        threshold =220;
        if dim == 3
            availpos = last(:, :, 1) > threshold & last(:, :, 2) > threshold & last(:, :, 3) > threshold;
            availposes = cat(3, availpos, availpos, availpos);

            last(availposes) = 255;
        else
            last(last > threshold) = 255;
        end
    end
    

%     if is_sketch
%         availpos = last(:, :, 1) < threshold & last(:, :, 2) < threshold & last(:, :, 3) < threshold;
%         availposes = cat(3, availpos, availpos, availpos);
%         last(availposes) = 0;
%     end
end

