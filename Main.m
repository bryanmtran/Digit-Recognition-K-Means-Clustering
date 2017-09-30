% Bryan Tran
% CS 682
% Lab 1

clearvars;
close all;

% Relative directory of TIDIGITS corpus 
% (Leonard and Doddington, 1993).
corpusDir = 'tidigits/';
% Somewhat arbitrarily chosen set of k values.
ks = [1,5,10,20,50,100,500,1000];
% Error array to be filled with error values of each k value where
% the first row indicates errors and the second row indicates k values.
all_error = [];
% Iterate through each k value. Run driver function, visualize the
% confusion matrix and calculate the error for each k value.
for i=1:length(ks)
    confusion = tidigitsasr(corpusDir, ks(i));
    
    visConfusion(confusion);
    
    correctly_classified = sum(diag(confusion));
    total_sum = sum(sum(confusion));
    misclassified = total_sum - correctly_classified;
    error_frac = misclassified / total_sum;
    all_error(1,i) = error_frac;
    all_error(2,i) = ks(i);
    fprintf('Error : %f (%d / %d), with k = %d. \n', error_frac, misclassified, total_sum, ks(i));
end

% Plot error values against corresponding k values.
semilogx(all_error(2,:),all_error(1,:),'-x','MarkerSize',10)
title('Fraction of misclassified test vectors by k value');
xlabel('k');
ylabel('Error (Misclassified / Total)');
