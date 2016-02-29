function [X] = preprocess_training_set(Xtr)

    n = length(Xtr);
    for i = 1:n
        X(i,:) = compute_histograms(Xtr(i,:));
    end
end