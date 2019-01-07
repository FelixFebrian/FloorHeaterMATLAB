function [A] = fun_calculateMatrixA...
    (n, bUnique, indMat1, mat2_lambda, mat1_lambda, ...
    ind_mat2to1_south, ind_mat2to1_north, ind_mat2to1_east, ind_mat2to1_west,...
    indCauchy, alpha, indDirichlet1, indDirichlet2)
% This function returns the coefficient matrix A (A*T + S = dTdt)
% Input:    - n: n (integer) indicates the grid size (n x n = resolution)
%           - b: vector that indicates the system border cells
%           - lambda_:  thermal conductivity for heat conduction
%           - i...:     indices from function fun_findNeighbouringCells.m
%           - indCauchy: Indices of cells with cauchy bc (q =alpha(T-Tinf))
%           - alpha:    heat transfer coeff
%           - indDirichlet: Indices of cells with dirichlet bc (T = const)
% Output:   - Matrix A (n*n x n*n)
%% pre
indAll(:,1) = 1:1:n*n; % generiert eine Matrix mit Indices. Jede Zelle ist einer einer Zahl zugeordnet.
lambda_avg = fun_doMean(mat2_lambda, mat1_lambda); % calculate a mean lambda (either harmonic OR arithmetic)

bNorth  = 1:n:n*n; % obere Zellen mit Außengrenze
bSouth  = n:n:n*n; % untere Zellen mit Außengrenze
bWest   = 1:1:n; % linke Zellen mit Außengrenze
bEast   = n*n-n+1:1:n*n; % rechte Zellen mit Außengrenze
%% Bestimme die verschiedenen Einträge von A


%% Pre-Allocate
% ap=zeros(n*n,1);
an=zeros(n*n,1);
as=zeros(n*n,1);
aw=zeros(n*n,1);
ae=zeros(n*n,1);

an(indAll,1)=mat2_lambda;
as(indAll,1)=mat2_lambda;
aw(indAll,1)=mat2_lambda;
ae(indAll,1)=mat2_lambda;

an(indMat1,1)=mat1_lambda;
as(indMat1,1)=mat1_lambda;
aw(indMat1,1)=mat1_lambda;
ae(indMat1,1)=mat1_lambda;

%% Write-Over
% Einträge für die Beton-Zellen, die südlich von sich eine Holz-Zelle haben 
as(ind_mat2to1_south) = lambda_avg; % Die Betonzelle
an(ind_mat2to1_south+1) = lambda_avg; % Die Holzzelle. Logische Schlussfolgerung, da WÜ in beide Richtungen.
% Einträge für die Beton-Zellen, die nördlich von sich eine Holz-Zelle haben 
an(ind_mat2to1_north) = lambda_avg; % Die Betonzelle
as(ind_mat2to1_north-1) = lambda_avg; % Die Holzzelle.
% Einträge für die Beton-Zellen, die westlich von sich eine Holz-Zelle haben 
aw(ind_mat2to1_west) = lambda_avg; % Die Betonzelle
ae(ind_mat2to1_west-n) = lambda_avg; % Die Holzzelle.
% Einträge für die Beton-Zellen, die östlich von sich eine Holz-Zelle haben 
ae(ind_mat2to1_east) = lambda_avg; % Die Betonzelle
aw(ind_mat2to1_east+n) = lambda_avg; % Die Holzzelle.

%% Sum up to ap
an(bNorth)  = 0;
ae(bEast)   = 0;
as(bSouth)  = 0;
aw(bWest)   = 0;

ap          = -(an + as + aw + ae);


% Cauchy BC: q = alpha*(T-Tinf) => alpha*T = alpha*Tinf + q (right side of eq. in
% S, left side of eq. in A)
ap(indCauchy) = ap(indCauchy) - alpha;

% Dirichlet BC:
% Is implementer after A is created

%% Circshift A
% necessary for spdiags syntax
aw = circshift(aw, -n);
ae = circshift(ae, +n);
an = circshift(an, -1);
as = circshift(as, +1);

%% Create A with all Elements
A = spdiags ([aw an ap as ae], [-n -1 0 1 n], n^2, n^2);
% Dirichlet BC. If center element has a Dirichlet BC, all entries are 0
% except for ap = 1.
A([indDirichlet1 indDirichlet2], :)  = 0;

% Overwrite matrix A to account for dirichlet (T=const) BC
Atemp = (-1).*speye(size(A)); % 
Atemp(~ismember(1:size(A,2),[indDirichlet1 indDirichlet2]), :) = 0; % find all rows which have no dirichlet bc and set entire row = 0
A = A + Atemp; %add A (the actual matrix) to Atemp (matrix with a few 1's for cells with dirichlet bc 

end
