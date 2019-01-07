function out = fun_doMean(M, B)
% This function calculates the mean of two inputs and chooses either the
% harmonic OR arithmetic mean, depending on the relation of the size of the
% inputs. 
%
% Assign A to the bigger number of the two
sorted = sort([M,B]);
M = sorted(2);
B = sorted(1); 
% Check size of dimension with the chosen condition
if B >= M/2 
    out = 0.5*(M+B); % arithmetic mean
else
    out = 2*M*B/(M+B); % harmonic mean
end

end