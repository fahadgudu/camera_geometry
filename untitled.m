MATRIX = zeros(40,12);
u_alpha=[ 1 2 3 1 0  0  0  0 -2 -3 -4 5]; 
v_beta=[ 0  0  0  0 1 2 3 1 -4 -5 -6 7];

MATRIX(1:1,1:12)= v_beta;
MATRIX(2:2,1:12)= u_alpha;

MATRIX