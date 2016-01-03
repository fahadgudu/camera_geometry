% Fundamental Matrix Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

[row column]=size(Points_a);
MATRIX = zeros(row,9);
for i = (1:row)
    t = num2cell(Points_a(i:i,1:end));
    [u,v] = deal(t{:});
    w = num2cell(Points_b(i:i,1:end));
    [X,Y] = deal(w{:});
    row_matrix=[u*X,u*Y,u,v*Y,v*X,v,X,Y,1];
    MATRIX(i:i,1:9)= row_matrix;
end

%This is an intentionally incorrect Fundamental matrix placeholder
F_matrix = MATRIX;
end

