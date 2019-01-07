function [S_stat] = fun_calculateVectorS(...
    S, qSource, alpha, n, T_inf, indCauchy,...
    indDirichlet1, indDirichlet2, T_dirichlet2, T_dirichlet1)
% This function calculates the vector S that is used for the stationary
% solution. 
S = sparse(reshape(S, [], 1)); % reshape S to column vector

S_stat = S;
S_stat = -qSource*S_stat; % qSource

% Cauchy 
S_stat(indCauchy) = S_stat(indCauchy) - T_inf * alpha;

% Dirichlet
S_stat(indDirichlet1) = -T_dirichlet1;
S_stat(indDirichlet2) = -T_dirichlet2;

%% old
% SS = fun_bcCauchy(alpha, n, Tinf, indCauchy);
%S_stat = S - fun_bcCauchy(alpha, n, T_inf, indCauchy);

% Dirichlet BC
% S(bAll(1,:)) = T_c;
% S(bAll(3,:)) = T_c;
% S(bAll(2,:)) = T_w;
end