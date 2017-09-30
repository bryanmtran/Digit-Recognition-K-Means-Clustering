function CodeWords = VQ_Train(NCodeWords, TrainingData, StopFraction)
% CodeWords = lloydvq(NCodeWords, TrainingData, StopFraction)
%
% Given a matrix TrainingData where each column consists of one training
% sample, create a vector quantizer with NCodeWords.
%
% Training is done with the iterative Lloyd algorithm which is said to
% converge when the ratio of the current iteration's distortion to the
% previous one is StopFraction x 100%. StopFraction defaults to .99 % when it is not specified.

% Set StopFraction to default value .99, if it is not specified.
if ~exist('StopFraction','var')
    StopFraction = .99;
end

    % k-means algorithm from class slides.
    CodeWords = kmeansinit(NCodeWords,TrainingData);
    done = 0;
    old_distortion = VQ_MeanMinDistortion(TrainingData,CodeWords);
    while (done == 0)
        partitions = cell(1,NCodeWords);
        distances = distortion3(TrainingData, CodeWords);
        for i=1:size(distances,2)
            [~,min_idx] = min(distances(:,i));
            % Record training vector partition index into partitions{}.
            partitions{min_idx} = [partitions{min_idx} i];
        end
        % Replace indexes of training data in partition with the actual
        % training vectors. This is done for speed optimization.
        for i=1:size(partitions,2);
            partitions{i} = TrainingData(:,partitions{i});
        end
        % Update centers.
        for i=1:size(CodeWords,2)
            new_cw = sum(partitions{i},2) ./ size(partitions{i},2);
            CodeWords(:,i) = new_cw;
        end
        new_distortion = VQ_MeanMinDistortion(TrainingData,CodeWords);
        ratio = new_distortion/old_distortion;
        if ratio >= StopFraction
            done = 1;
        end
        old_distortion = new_distortion;
    end
end

% kmeansinit from Problem Set # 2.
function init_codewords = kmeansinit(k,Matrix)
    % Find dimensions of data matrix.
    matrix_size = size(Matrix);
    % If chosen k is greater than # of data, clamp it to # of data.
    if (k > matrix_size(2))
        k = matrix_size(2);
    end;
    % Randomly generate column indicies of data to be returned.
    random_idxs = randperm(matrix_size(2),k);
    % Return the randomly chosen codewords from the data matrix.
    init_codewords = [];
    for i = 1:length(random_idxs)
        word = [Matrix(1:matrix_size(1),random_idxs(i))];
        init_codewords = horzcat(init_codewords,word);
    end 
end