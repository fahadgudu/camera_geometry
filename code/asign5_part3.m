clear
close all

pic_a = imread('data/Mount Rushmore/9193029855_2c85a50e91_o.jpg');
pic_b = imread('data/Mount Rushmore/7433804322_06c5620f13_o.jpg');
pic_a = imresize(pic_a, 0.25, 'bilinear');
pic_b = imresize(pic_b, 0.37, 'bilinear');

[Points_2D_pic_a, Points_2D_pic_b] = sift_wrapper( pic_a, pic_b );
% fprintf('Found %d possibly matching features\n',size(Points_2D_pic_a,1));
show_correspondence2(pic_a, pic_b, Points_2D_pic_a(:,1), Points_2D_pic_a(:,2), Points_2D_pic_b(:,1),Points_2D_pic_b(:,2));

%% Calculate the fundamental matrix using RANSAC
% !!! You will need to implement ransac_fundamental_matrix. !!!
[F_matrix, matched_points_a, matched_points_b] = ransac_fundamental_matrix(Points_2D_pic_a, Points_2D_pic_b);

% Draw the epipolar lines on the images and corresponding matches
show_correspondence2(pic_a, pic_b, matched_points_a(:,1), matched_points_a(:,2), matched_points_b(:,1),matched_points_b(:,2));

draw_epipolar_lines(F_matrix, pic_a, pic_b, matched_points_a, matched_points_b);

%optional - re estimate the fundamental matrix using ALL the inliers.
% [ F_matrix ] = estimate_fundamental_matrix_james(matched_points_a, matched_points_b);

% draw_epipolar_lines(F_matrix, pic_a, pic_b, matched_points_a, matched_points_b);
