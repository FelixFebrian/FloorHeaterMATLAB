function [ind, M] = fun_readImage(picName, opt)
% This function converts a bitmap picture into a matrix. It is used to return the
% indices ('ind') of R/G/B pixels. Red (R=255) indicates a tile of the floor
% heating system. It works likewise for green (R=255) for one material. 
% If no input (char) is given, an error is thrown.

if nargin < 1
    error('Wrong syntax. Please provide a picture name (.bmp) and an option')
end

[A,~] =  imread(picName);
    % A1 = A(:,:,1); 
    % A2 = A(:,:,2); % green = material 1
    % A3 = A(:,:,3); % red = heating  

if strcmp(opt, 'floor') 
    greenMatrix = A(:,:,2);
    ind = find(greenMatrix~=0);
    greenMatrix(ind) = 1;
    notgreenMatrix = ones(size(greenMatrix));
    notgreenMatrix(ind) = 0;
    M(:,:,1) = double(greenMatrix);     % = green
    M(:,:,2) = double(notgreenMatrix);  % = blue
elseif strcmp(opt, 'source') 
    redMatrix = A(:,:,3);
    ind = find(redMatrix==0); % indices of 'master grid' with source term
    redMatrix = zeros(size(redMatrix));
    redMatrix(ind) = 1; 
    M = redMatrix;
else
    error('Please chose a correct option as string var')
end

end



