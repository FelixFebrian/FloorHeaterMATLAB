function [indCauchy, indDirichlet1, indDirichlet2] = fun_setIndicesForBC(n, bUnique, bAll)
% This function sets the indices for the boundary conditions. One may feel
% free to add as much complexity to this as desired. s

indCauchy = bAll(3,:); % 4 is south
indCauchy = indCauchy(2:end-1); % exclude cells in the corner to avoid duplicates

indDirichlet1 = bAll(1,:); % 1 is north
indDirichlet2 = bUnique(~(ismember(bUnique, [indCauchy indDirichlet1]))); % all cells except cauchy & dirichlet1 shall be dirichlet2 bc



%%% OLD
% indCauchy = 2:n-1; % neg. heat flux on western border 
% indDirichlet1 = bUnique(~(ismember(bUnique, indCauchy))); % all cells without cauchy bc shall be dirichlet bc

end