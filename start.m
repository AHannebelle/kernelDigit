Xtr=load('data/Xtr.csv');
Xte=load('data/Xte.csv');
Ytr=load('data/Ytr.mat');
Ytr=Ytr.Ytr;
validation = 1;


if (validation>0)
            Xval=Xtr(1001:2000,:);
            Xtr=Xtr(1:1000,:);
            Yval = Ytr(1001:2000,:);
            Ytr = Ytr(1:1000,:);
end

n=length(Xtr);
Xtr = preprocess_training_set(Xtr);
Xval = preprocess_training_set(Xval);
lambda= 0.0001;
sigma = 60;
for u = 1:1
    sigma = 22
    for v = 1:6
        sigma  = sigma - 3
        %problem parameters
        validation = 1;
        K = compute_k(Xtr, sigma);
        validation
        
        %compute alpha
        for num=1:10  %on regarde si l'image correspond au chiffre num-1
            label=single(Ytr(:,2) == num-1)-single(Ytr(:,2)~=num-1);
            alpha{num}=(K+lambda*n*eye(n))\label;
        end

        %compute scores for the validation set
        score=compute_score(n,alpha,Xval,Xtr,sigma,1); %set last parameter to 1 to track progress
        [~,attrib] = max(score, [], 2);
        attrib = (attrib-1);
        diff=(attrib-Yval(:,2)) == 0;
        scorefinal(u,v) = norm(single(diff),1)/1000
%         csvwrite('Yte',attrib);
    end
    lambda = lambda /10;
end


% =======
% l=length(Xtr);
% %compute alpha
% for num=1:10  %on regarde si l'image correspond au chiffre num-1
%     label=100*(single(Ytr(1:l,2)==num-1)-single(Ytr(1:l,2)~=num-1));
%     alpha{num}=(K+lambda*l*eye(l))\label;
% end
% 
% %compute scores for the validation set
% numval=500;
% score=compute_score(numval,alpha,Xval(1:numval,:),Xtr,sigma,1); %set last parameter to 1 to track progress
% [~,attrib]=max(score,[],2);
% diff=(attrib-Yval(1:numval,2)-1) == 0;
% scorefinal = norm(single(diff),1)/numval

%compute scores for the test set
% score=compute_score(n,alpha,Xte,Xtr,sigma,1); %set last parameter to 1 to track progress
% [~,attrib]=max(score);
% >>>>>>> 24ae6bd3a33bc16b6c4a5aac2a07f96ab0ba8bb5
