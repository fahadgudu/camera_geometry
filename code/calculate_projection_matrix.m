function M = calculate_projection_matrix( Points_2D, Points_3D )

[row column]=size(Points_2D);
MATRIX = zeros(row*2,12);
x=1;
for i = (1:row)
      t = num2cell(Points_2D(i:i,1:end));
      [u1,v1] = deal(t{:});
      w = num2cell(Points_3D(i:i,1:end));
      [X1,Y1,Z1] = deal(w{:});
      u_alpha=[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1 u1]; 
      v_beta=[ 0  0  0  0 X1 Y1 Z1 1 -v1*Z1 -v1*Y1 -v1*Z1 v1];
      MATRIX(x:x,1:12)= u_alpha;
      MATRIX(x+1:x+1,1:12)= v_beta;
      x= x+2;
end

fprintf('Randomly setting matrix entries as a placeholder\n')
M = MATRIX
end

