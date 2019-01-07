function [M, S] = fun_createGridMS(n, namePicFloor, namePicSource)
% This function creates the matrix for A and S for a given resolution size
% by scaling down the "master picture" which is given by the user.
% (S contains the source term and each value is given as a percentage: how
% much of that cell has a source term?)
% Input:    n - number of finite volume elements in one direction (x or y)
%           namePicFloor - name of the bitmap picture for the floor (String) 
%           namePicSource - name of the bitmap picture for the heatings (String)  
% Output:   A - Matrix with indices. (A*T + S = dTdt)
%           S - Matrix with indices.

%% Matrix A
[~, picMatrix] = fun_readImage(namePicFloor, 'floor');
% spy(M(:,:,1)); keyboard
sizeMax = size(picMatrix,1); % determine maximal dimension of grid based on picture
M   = picMatrix;
M   = M(:,:,1); % green 

nn  = sizeMax/n;        % how many pixels of the master gird make up one finite volume-grid element
dim = nn*ones(n,1)';    % needed for mat2cell syntax

% Using mat2cell is probably very inefficient, as reshape & permute would work as well. 
% mat2call is easy to use, though. Explanatory comments assume the master
% grid is of size 512 x 512.
M   = mat2cell(M, dim, dim);        % break down matrix in tiles [n x n] (with one entry being [512/n x 512/n])
M   = cell2mat(reshape(M, [], 1));  % rearrange all tiles in a column vector and then convert back to matrix ([(512/n)*n*n x 512/n])
M   = sum(M, 2);                    % compute the sum of the elements in each row => [(512/n)*n*n x 1]
M   = reshape(M, nn, []);           % rearrange so that one column belongs to one grid element => [512/n x n*n]
M   = sum(M, 1);                    % compute the sum of the elements in each column => [1 x n*n]
idx = find(M>nn/2);                 % if more than half of the finite volume is indicated as 1 (one material), then the entire element is considered as 1 (that material)
M   = zeros(size(M)); 
M(idx) = 1;                         % might want to use logical indexing
M = reshape(M, n, n);               % reshape into n x n grid form => [n x n]
% spy(M);

%% Matrix S
% This part breaks down the master grid (512 x 512 px) into the chosen grid
% size (n x n). It assign a value e[0,1] to each finite volume that
% represents the source term as percentage. A finite volume with value 0
% has no source term while an element with value 1 has "100%" source.

[~, picMatrix] = fun_readImage(namePicSource, 'source'); % returns matrix that has a 1's where source term is
% spy(picMatrix); keyboard
sizeMax = size(picMatrix,1); % determine maximal dimension of grid based on picture

nn  = sizeMax/n;        % how many pixels of the master gird make up one grid element
dim = nn*ones(n,1)';    % needed for mat2cell syntax

S = mat2cell(picMatrix, dim, dim);  % break down matrix in tiles [n x n] (with one entry being [512/n x 512/n])
S = cell2mat(reshape(S, [], 1));    % rearrange all tiles in a column vector and then convert back to matrix ([(512/n)*n*n x 512/n])
S = sum(S, 2);                      % compute the sum of the elements in each row => [(512/n)*n*n x 1]
S = reshape(S, nn, []);             % rearrange so that one column belongs to one grid element => [512/n x n*n]
S = sum(S, 1);                      % compute the sum of the elements in each column => [1 x n*n]
S = S/((sizeMax/n)^2);              % scale down to percentage by dividing it by the maximal # of 1's possible per grid element (that would be 100%)
S = reshape(S, n, n);               % reshape into n x n grid form => [n x n]
% spy(S)


%% old
% % https://stackoverflow.com/questions/20336288/for-loop-to-split-matrix-to-equal-sized-sub-matrices
