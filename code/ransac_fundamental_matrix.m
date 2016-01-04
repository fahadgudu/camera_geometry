% RANSAC Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)
% row and column specify the size of new matrix which will be use to
% generate the random matrix of indices.
[row column] = size(matches_a);
% d accomadate the matrix of indices which we use to fetch the points from
% the matches_a and matches_b
d = transpose(randsample(row,row));
% patchmatrix1 and patchmatrix2 is used to fetch the 8*1 points from the matches_a and matches_b 
patchmatrix1 = zeros(8,2);
patchmatrix2 = zeros(8,2);
% Best_Fmatrix will be the fundamental matrix with best inliers in the
% array of points
Best_Fmatrix = zeros(3,3);
% variable to store the maximum values of best inliers in matches_a and matches_b
max_of_fm = 0;
% i and j will be use to fetch the chunk from d matrix of indices/
i = 1;
j = 8;
 for x = (1:103)
    % 1*8 matrix of points for fundamental matrix
    points_a = d(i:j);
    % get the 8 points from matches_a
    patchmatrix1=matches_a(points_a,:);
    % get the 8 points from matches_b
    patchmatrix2=matches_b(points_a,:);
    % increment to next chunk of the points
    i = i+8;
    j = j+8;
    % calculate the fundametal matrix of 8*8 points in matches_a and
    % matches_b
    F_matrix = estimate_fundamental_matrix(patchmatrix1, patchmatrix2);
    [U,S,V] = svd(F_matrix);
    M_norm_B=V(:,end);
    M_norm_B = reshape(M_norm_B,3,3);
    other_points = setdiff(d,points_a);
    number_of_matches = 0;
    inliersA = zeros(length(other_points),2);
    inliersB = zeros(length(other_points),2);
    inliersCount = 1;
    for t = (1:length(other_points))
        vt = other_points(t);
        tu = num2cell(matches_a(vt:vt,1:end));
        [u,v] = deal(tu{:});
        vw = num2cell(matches_b(vt:vt,1:end));
        [u_dash,v_dash] = deal(vw{:});
        if abs([u v 1] * M_norm_B * transpose([u_dash v_dash 1]) < 0.001)
            number_of_matches = number_of_matches + 1;
            inliersA(inliersCount:inliersCount,1:end) = [u v];
            inliersB(inliersCount:inliersCount,1:end) = [u_dash v_dash];
            inliersCount = inliersCount + 1; 
        end
    end
    if ( x == 1 )
        max_of_fm = number_of_matches;
    end
    if (max_of_fm <= number_of_matches)
        max_of_fm  = number_of_matches;
        Best_Fmatrix = M_norm_B;
        inliersA( all(~inliersA,2), : ) = [];
        inliersB( all(~inliersB,2), : ) = [];
        inliers_a = inliersA;
        inliers_b = inliersB;
    end
 end
 
end

