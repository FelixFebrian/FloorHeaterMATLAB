function [T_stat, T_stat_re, CLim] = fun_calculateStationarySolution_Error(...
    A, S_stat, n, saveStationary)
% This function is used for the error analysis for the grid size. 
% It is a modificatin of fun_calculateStationarySolution.m
global h
T = A\(S_stat);
T_stat = T;
T_stat_re = reshape(T, n, n);
try 
    set(h.AxesStat, 'Visible', 'on')
    axes(h.AxesStat)
 
catch
%    figure()
end
% h.Stat = imagesc(T_stat_re);
CLim = [min(min(T_stat_re)) max(max(T_stat_re))];
% colorbar
% disp('Calculated stationary solution')
if saveStationary == 1
    figure1 = figure('color', 'w', 'visible', 'off');
    axes(gcf); title('Stationary Solution')
    imagesc(T_stat_re); colorbar
    filename = ['./export/Stationary (n = ' num2str(n) ').png'];
    saveas(figure1, filename)
    disp('Stationary solution saved to folder ./export/')  
end

end