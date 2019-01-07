function [bUnique, bAll] = fun_findBorderCells(n)
% This function returns the various arrays with the indices for certain
% boundary elements.
% Input:    - n: n (integer) indicates the grid size (n x n = resolution)
%           

% Calculate indices of north, east, south and west border of system based
% on grid size n
bNorth  = 1:n:n*n;          % obere Zellen mit Au�engrenze
bSouth  = n:n:n*n;          % untere Zellen mit Au�engrenze
bWest   = 1:1:n;            % linke Zellen mit Au�engrenze
bEast   = n*n-n+1:1:n*n;    % rechte Zellen mit Au�engrenze

bAll    = [bNorth; bEast; bSouth; bWest];

bUnique = unique([bNorth bSouth bWest bEast]);      % eliminate corner cells that appear twice

                           
% bMat2   = bUnique(not(ismember(bUnique, indMat1))); % indicates border cells of material 2
% bMat1   = bUnique(not(ismember(bUnique, bMat2)));   % indicates border cells of material 1
end
