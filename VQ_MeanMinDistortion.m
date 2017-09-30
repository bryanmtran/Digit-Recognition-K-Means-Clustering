function mu = VQ_MeanMinDistortion(ColVecs, Codebook)
% VQ_MeanMinDistortion(ColVecs, Codebook)
%
% Compute the average minimum distortion of all column vectors ColVecs 
% with respect to the given Codebook (column vector codewords).
    
    distances = distortion3(ColVecs, Codebook);
    sum= 0;
    % Iterate through training vector distortions (columns).
    for i=1:size(distances,2)
        min_train = min(distances(:,i));
        sum = sum + min_train;
    end
    % mu is the sum divided by the # of training vectors.
    mu = sum / size(distances,2);
end