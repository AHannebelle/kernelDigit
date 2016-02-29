Xtr=load('data/Xtr.csv');
Xte=load('data/Xte.csv');
Ytr=load('data/Ytr.mat');
Ytr=Ytr.Ytr;

%problem constants
n=length(Xtr);

%problem parameters
lambda= 10;
sigma = 10;
validation=1;

%validation set
if (validation>0)
    Xval=Xtr(4001:end,:);
    Xtr=Xtr(1:4000,:);
    Yval=Ytr(4001:end,:);
    Ytr=Ytr(1:4000,:);
end

%compute K
tic
K = compute_k(Xtr, sigma);
if (validation>0)
    save('K_val.mat','K');
else
    save('K_full.mat','K');
end

save('K.mat','K');
toc

%show(Xtr(2,:))

l=length(Xtr);
%compute alpha
for num=1:10  %on regarde si l'image correspond au chiffre num-1
    label=100*(single(Ytr(1:l,2)==num-1)-single(Ytr(1:l,2)~=num-1));
    alpha{num}=(K+lambda*l*eye(l))\label;
end

%compute scores for the validation set
numval=500;
score=compute_score(numval,alpha,Xval(1:numval,:),Xtr,sigma,1); %set last parameter to 1 to track progress
[~,attrib]=max(score,[],2);
diff=(attrib-Yval(1:numval,2)-1) == 0;
scorefinal = norm(single(diff),1)/numval

%compute scores for the test set
% score=compute_score(n,alpha,Xte,Xtr,sigma,1); %set last parameter to 1 to track progress
% [~,attrib]=max(score);