function [ind_mat2to1_south, ind_mat2to1_north, ind_mat2to1_west, ind_mat2to1_east] =...
         fun_findNeighbouringCells(indMat1, bAll, n)
% This function returns the indices of those cells of material 2 which have
% material 1 either to their south, north, west or east. This is done by
% "comparing" the sets of indices. See the presentation for a visualisation
% of this. 
%% pre
bNorth  = bAll(1,:);
bEast   = bAll(2,:);
bSouth  = bAll(3,:);
bWest   = bAll(4,:);

%% Bestimme die Beton-Zellen mit einer Holz-Nachbarzelle

% Find cells of material 2, which have a cell of material 1 south to it
ind_mat2to1_south = indMat1(not(ismember(indMat1, bNorth))); % exclude cells on northern border
ind_mat2to1_south = ind_mat2to1_south-1; % minus 1 for south
ind_mat2to1_south = ind_mat2to1_south(not(ismember(ind_mat2to1_south, indMat1))); % only cells on intersection of materials

%Bestimme die Beton-Zellen, die nördlich von sich eine Holz-Zelle haben 
ind_mat2to1_north = indMat1(not(ismember(indMat1, bSouth))); %bb
ind_mat2to1_north = ind_mat2to1_north+1;
ind_mat2to1_north = ind_mat2to1_north(not(ismember(ind_mat2to1_north, indMat1)));

%Bestimme die Beton-Zellen, die westlich von sich eine Holz-Zelle haben 
ind_mat2to1_west = indMat1(not(ismember(indMat1, bEast))); %br
ind_mat2to1_west = ind_mat2to1_west+n;
ind_mat2to1_west = ind_mat2to1_west(not(ismember(ind_mat2to1_west, indMat1)));

%Bestimme die Beton-Zellen, die östlich von sich eine Holz-Zelle haben 
ind_mat2to1_east = indMat1(not(ismember(indMat1, bWest))); %bl
ind_mat2to1_east = ind_mat2to1_east-n;
ind_mat2to1_east = ind_mat2to1_east(not(ismember(ind_mat2to1_east, indMat1)));


end