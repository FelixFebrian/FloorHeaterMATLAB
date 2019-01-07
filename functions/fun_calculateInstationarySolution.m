function [] = fun_calculateInstationarySolution(...
                    indMat2, mat2_rho, mat2_cp,...
                    indMat1, mat1_rho, mat1_cp, ...
                    gridSize, n, A, S_stat, ~, ...
                    bUnique, indDirichlet1, T_dirichlet1, indDirichlet2, T_dirichlet2,...
                    gamma, deltaT, ~, T_initial,...
                    saveInstationary)
% This function is used to calculate the instationary solution.
global h
disp('Running calculation for instationary solution...')
t1 = cputime;

% Find indices of material 2 except the border for break criteria 
indTcounter = ~ismember(indMat2, bUnique);
indTcounter = indMat2(indTcounter);

% factors for material 1 & 2
a_mat2 = ((1)/(mat2_rho*mat2_cp*gridSize));
a_mat1 = ((1)/(mat1_rho*mat1_cp*gridSize));

% fak is a constant factor
fak         = sparse(n^2,1);
fak(indMat1)= a_mat1;
fak(indMat2)= a_mat2;
fak         = spdiags(fak, 0, n^2, n^2); % create matrix with fak on main diagonale

% Modify matrix A according to rearranged equation (see report)
A_inst = sparse(speye(n^2) - (deltaT .* gamma .* fak * A));  

% Overwrite matrix A to account for dirichlet BC (T = const) 
A_inst([indDirichlet1 indDirichlet2], :)  = 0;  % clear entire rows where dirichlet bc applies                                  
AInstTemp = (-1).*speye(size(A));               % sets up temp matrix for Dirichlet BC
AInstTemp(~ismember(1:size(A,2),[indDirichlet1 indDirichlet2]), :) = 0; % clear rows of temp matrix where dirichlet DOES NOT apply
A_inst = A_inst + AInstTemp;                    % add both matrices together

% Set initial temperature 
T1 = ones(n^2,1).* T_initial; % initial temperature 
T1(indDirichlet1) = T_dirichlet1; % set bc
T1(indDirichlet2) = T_dirichlet2;

try % Pick axes where to plot
    axes(h.AxesInstat)
    % beep % for debugging
catch
    figure()
end

% Plot initial conditions (t = 0)
CLim = [min(T1) 300]; % If CLim is not changed, it has the same scaling across plots
imagesc(reshape(T1,n,n), CLim); colorbar;


%% Options for while loop
% Set target temperature for selected FV-Cells
T_setMat2 = 273.15+20; % K

% Set variables for while loop
counterMax = 1*10^3;
counter = 1; % To break out of while loop
counterTemperature = 0; % to start while loop

% % for additional temperature profile analysis
% Tall = zeros(n*n,5*10^3); % preallocating
% x     = zeros(1,5000); % preallocating

%% testing
% t = 0; for plots in report
switch saveInstationary
    case 0 % no video output
%         while t < 60 * 60 *24 % for plots in report
         while counterTemperature < 0.35*length(indTcounter)&& counter < counterMax
           % Set T for iteration
           T0 = T1;
           % Calculate S_inst-Vector
           S_inst = (speye(n^2) + deltaT .* (1 - gamma) .* fak * A) * T0 ...
                    - deltaT .* fak * S_stat;
           % Set boundary conditions in S
           S_inst(indDirichlet1) = -T_dirichlet1;   
           S_inst(indDirichlet2) = -T_dirichlet2;

           % Solve for new temperature
           T1 = A_inst\S_inst; 

           % check for break-criteria 
           counterTemperature = length(find(T1(indTcounter)>=T_setMat2));

           % plot 
           T_plot = reshape(T1, [n,n]);   
           imagesc('XData', 1, 'YData', 1, 'CData', T_plot, CLim)
           drawnow
           
           
%            t = t+deltaT       % for plots in report              
           counter = counter+1;
        end
        
    case 1 % video output
        %% Set up video options
        videoFileName = ['./export/Instationary (n = ' num2str(n) ')'];
        writerObj = VideoWriter(videoFileName,'MPEG-4');
        writerObj.FrameRate = 60; % How many frames per second.
        open(writerObj);
        rect = [540 210 330 330];%[left bottom width height], needed for video
        
        %% actual calculation & plotting here   
        while counterTemperature < 0.3*length(indTcounter)&& counter < counterMax
           % Set T for iteration
           T0 = T1;
           % Calculate S_inst-Vector
           S_inst = (speye(n^2) + deltaT .* (1 - gamma) .* fak * A) * T0 ...
                    - deltaT .* fak * S_stat;
           % Set boundary conditions in S
           S_inst(indDirichlet1) = -T_dirichlet1;   
           S_inst(indDirichlet2) = -T_dirichlet2;

           % Solve for new temperature
           T1 = A_inst\S_inst; 

           % check for break-criteria 
           counterTemperature = length(find(T1(indTcounter)>T_setMat2));

           % plot 
           T_plot = reshape(T1, [n,n]);   
           imagesc('XData', 1, 'YData', 1, 'CData', T_plot, CLim)
           drawnow
                      
           % if mod(i,4)==0, % Uncomment to take 1 out of every 4 frames.
           try 
               frame = getframe(gcf); % some weird error when using h.AxesInstat
           catch
               frame = getframe(gcf);
           end
            writeVideo(writerObj, frame);
           % end 
            
           counter = counter+1;
        end
        
        %% Save video     
        close(writerObj); % Saves the movie.
        disp('Instationary solution saved to folder ./export/')  
end
% For plots in report
%{
            CLim = [280 300]
            figure1 = figure('color', 'w', 'visible', 'on');
            filename = ['./export/Instationary 24h CN (n = ' num2str(n) ').png'];
            %     surf(T_stat_re, 'EdgeColor', 'none');
            imagesc(T_plot, CLim);
            colorbar('TickLabelInterpreter', 'latex')
            %     set(gca, 'XLim', [0;n])
            %     set(gca, 'YLim', [0;n])
            set(gca, 'XTick', [1;n])
            set(gca, 'YTick', [1;n])
            set(gca, 'TickLabelInterpreter', 'latex')
            saveas(figure1, filename)
            close(figure1)
%}


%% Display meta info
t2 = cputime;
time = t2 - t1;

if counter == counterMax
    disp('End of calculation for instationary solution.')
    disp(['' num2str(counter*deltaT/3600) ' hours to have passed.'])
    disp('Maximum number of iterations reached.')
    disp(['Running time for instationary: ' num2str(time) ' s.'])
else
    disp('End of calculation for instationary solution.')
    disp(['It took ' num2str(counter*deltaT/3600) ' hours to reach the set temperature.'])
    disp(['It took ' num2str(counter) ' iterations to reach the set temperature.'])
    disp(['Running time for instationary: ' num2str(time) ' s.'])
end

end