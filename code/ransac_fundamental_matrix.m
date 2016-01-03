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
[row column] = size(matches_a);
d = transpose(randsample(row,row));
patchmatrix1 = zeros(8,2);
patchmatrix2 = zeros(8,2);
Best_Fmatrix = zeros(3,3);
max_of_fm = 0;
i = 1;
j = 8;
 for x = (1:103)
    points_a = d(i:j);
    patchmatrix1=matches_a(points_a,:);
    patchmatrix2=matches_b(points_a,:);
     i = i+8;
     j = j+8;
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
        if ([u v 1] * M_norm_B * transpose([u_dash v_dash 1]) > 1.5)
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

