function [ out_x, out_y, out_edge ] = generateOneSketch( x1, edge_x, y1, edge_y )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%     (0.8, 0.9)
    scaling = (rand(1) + 8) / 10;
    cur_edge = min(edge_x, edge_y);
    out_edge = round(scaling * cur_edge);
    distance_x = edge_x - out_edge;
    distance_y = edge_y - out_edge;
    offset_x = round(rand(1) * distance_x);
    offset_y = round(rand(1) * distance_y);
    out_x = x1 + offset_x;
    out_y = y1 + offset_y;
end