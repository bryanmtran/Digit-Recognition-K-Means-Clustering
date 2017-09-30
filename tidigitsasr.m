function confusion = tidigitsasr(CorpusDir, k)

% Iterate through digit classes and extract training data. 
% i=10 represents the 'O' and 'zero' class.
all_digits = {};
for i=1:10
    fprintf('Processing training case %d, with k : %d... \n',i,k);
    path = strcat(CorpusDir,'mfc/train/');
    if i==10
        regexp = 'o._01.mfc';
        files = findfiles(path,regexp,'regexp','path');
        regexp = 'z._01.mfc';
        files = [files ; findfiles(path,regexp,'regexp','path')];
    else
        regexp = strcat(int2str(i),'._01.mfc');
        files = findfiles(path,regexp,'regexp','path');
    end
    train = [];
    for j=1:length(files)
        [data,~] = spReadFeatureDataHTK(char(files(j)));
        train = [train data];
    end

    % Run VQ_Train (k-means algorithm) with default StopFraction parameter.
    codebook = VQ_Train(k,train);
    % Add the digit's codebook to all_digits, the codebook "library"
    % for all digit classes.
    all_digits = [all_digits {codebook}];

end

% Initate confusion matrix.
confusion = zeros(10,10);

% Iterate through digit classes and extract testing data.
% Again, i=10 represents the 'O' and 'zero' class.
for i=1:10
    fprintf('Processing testing case %d with k : %d... \n',i,k);
    path = strcat(CorpusDir,'mfc/test/');
    if i==10
        regexp = 'o._01.mfc';
        files = findfiles(path,regexp,'regexp','path');
        regexp = 'z._01.mfc';
        files = [files ; findfiles(path,regexp,'regexp','path')];
    else
        regexp = strcat(int2str(i),'._01.mfc');
        files = findfiles(path,regexp,'regexp','path');
    end
    for j=1:length(files)
        [data,~] = spReadFeatureDataHTK(char(files(j)));
        all_dist = [];
        for d=1:length(all_digits)
            % Compare test vector with each digit class' codebook.
            % Calculate mean, min distortion against each codebook
            % and store in all_dist.
            all_dist = [all_dist VQ_MeanMinDistortion(data,all_digits{d})];
        end
        % Find the minimum distortion, which is the "prediction" of what
        % digit class the testing vector is.
        [~,prediction] = min(all_dist);
        % Update confusion matrix.
        confusion(i,prediction) = confusion(i,prediction) + 1;
    end
    
end


end