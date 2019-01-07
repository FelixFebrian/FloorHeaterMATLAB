function [T_stat, T_stat_re, CLim] = fun_calculateStationarySolution(...
    A, S_stat, n, saveStationary)
% This function calculates the stationary solution. (A*T = S)
global h
T = A\(S_stat);
T_stat = T;
T_stat_re = reshape(T, n, n);
try 
    set(h.AxesStat, 'Visible', 'on')
    axes(h.AxesStat)
 
catch
    figure()
end
h.Stat = imagesc(T_stat_re);
CLim = [min(min(T_stat_re)) max(max(T_stat_re))];
colorbar
disp('Calculated stationary solution')
if saveStationary == 1
    CLim = [280 310];
    figure1 = figure('color', 'w', 'visible', 'on');
    filename = ['./export/Stationary (n = ' num2str(n) ').png'];

    
%     surf(T_stat_re, 'EdgeColor', 'none');
    imagesc(T_stat_re, CLim);
    colorbar('TickLabelInterpreter', 'latex')
%     set(gca, 'XLim', [0;n])
%     set(gca, 'YLim', [0;n])
    set(gca, 'XTick', [1;n])
    set(gca, 'YTick', [1;n])
    set(gca, 'TickLabelInterpreter', 'latex')
    
    
    saveas(figure1, filename)

   
    close(figure1)
    return
end

end