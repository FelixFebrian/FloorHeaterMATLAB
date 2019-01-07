%% main.m
% This function performs all calculation to solve the stationary &
% instationary problem. 
% The function uses default values if called without any input arguments.
% Alternatively, one can use the GUI (mainGUI.m) to give input.
% Please see the user manual and the report for further information. 
function [] = main(...
    n, gridSize, namePicFloor, namePicHeating, qFloorHeating,...
    mat2_rho, mat2_cp, mat2_lambda,...
    mat1_rho, mat1_cp, mat1_lambda,...
    gamma, deltaT, T_initial,...
    T_inf, alpha, T_dirichlet2, T_dirichlet1,...
    saveStationary, saveInstationary)
addpath('./functions/');
addpath('./matlab2tikz/');
t1 = cputime;
%% Default values if no user input:
if nargin == 0
    clc; clear variables, close all;
    t1 = cputime;
    %% Material Properties
    % Default: mat1 is concrete and mat2 is wood
    mat1_rho    = 2243;                % [kg/m^3]
    mat1_cp     = 880;                 % [J/(kg*K)]
    mat1_lambda = 0.1;                 % [W/(m*K)]

    mat2_rho    = 740;                 % [kg/m^3]
    mat2_cp     = 1300;                % [J/(kg*K)]
    mat2_lambda = 1.17;                % [W/(m*K)]

    %% Room characteristics
    n               = 64;
    lengthRoom      = 4;
    gridSize        = (lengthRoom/n)^2; % m^2 for each finite volume element 
    namePicFloor    = 'floorAnwendungsbeispiel.bmp';
    namePicHeating  = 'sourceAnwendungsbeispiel.bmp';
    %% Heating Power
    qFloorHeating   = 100;          % [W/m^2]
    %% Initial Temperatur profile for instationary
    T_initial       = 273.15+15;    % C
    %% Instationary option
    gamma           = 1;            % [1 0 0.5] - Implicit','Explicit','Crank-Nicolsen
    deltaT          = 5*60;         % s
    %% Boundary Conditions Properties
    % Cauchy (variable heat flux)
    T_inf           = 273.15+7;     % K 
    T_dirichlet1    = 273.15+25;    % Heizungskeller
    T_dirichlet2    = 273.15+18;    % Wand
    %% Settings
    saveStationary  = 0;
    saveInstationary = 0;
    %% BC Properties
    % Cauchy (variable heat flux)
    alpha           = 5; % 
end



qSource = qFloorHeating*gridSize; % [W] -  heating power per finite volume element
%% pre
[M, S]  = fun_createGridMS(n, namePicFloor, namePicHeating);    % scale down to chosen grid size
indMat2 = find(M==0); % blue 
indMat1 = find(M==1); % green 

S       = sparse(reshape(S, [], 1));                            % reshape S to sparse column vector

[bUnique, bAll] = fun_findBorderCells(n);        % Gibt den Rand, den Rand aus Mat1 und den aus Mat2 an.
                                                     
[indCauchy, indDirichlet1, indDirichlet2] = fun_setIndicesForBC(n, bUnique, bAll); % get indices of cauchy & dirichlet bc

[ind_mat2to1_south, ind_mat2to1_north, ind_mat2to1_west, ind_mat2to1_east] ...
= fun_findNeighbouringCells(indMat1, bAll, n);
%% Create A for stationary problem
[A] = fun_calculateMatrixA(n, bUnique, indMat1, mat2_lambda, mat1_lambda, ind_mat2to1_south, ...
ind_mat2to1_north, ind_mat2to1_east, ind_mat2to1_west, indCauchy, alpha, indDirichlet1, indDirichlet2);

%% Create S for stationary problem
[S_stat] = fun_calculateVectorS(S, qSource, alpha, n, T_inf, indCauchy,...
                                indDirichlet1, indDirichlet2, T_dirichlet2, T_dirichlet1);

%% Solve linear System for stationary solution
% If called from GUI, function plots in GUI. If not, function creates
% figure.
[T_stat, ~, CLim] = fun_calculateStationarySolution(A, S_stat, n, saveStationary);
t2 = cputime;
time = t2 - t1;
disp(['Running time for stationary: ' num2str(time) ' s.'])


%% Solve ODE for instationary solution
% If called from GUI, function plots in GUI. If not, function creates
% figure.

fun_calculateInstationarySolution(...
                    indMat2, mat2_rho, mat2_cp,...
                    indMat1, mat1_rho, mat1_cp, ...
                    gridSize, n, A, S_stat, T_stat, ...
                    bUnique, indDirichlet1, T_dirichlet1, indDirichlet2, T_dirichlet2,...
                    gamma, deltaT, CLim, T_initial,...
                    saveInstationary)
end