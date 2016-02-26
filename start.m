Xtr=load('data/Xtr.csv');
Xte=load('data/Xte.csv');
Ytr=load('data/Ytr.mat');
Ytr=Ytr.Ytr;

%problem constants

%problem parameters

validation=1;

%validation set
if (validation>0)
    Xtr=Xtr(1:4000,:);
    Xval=Xtr(4001:end,:);
    Ytr = Ytr(1:4000,:);
    Yval = Ytr(4001:end,:);
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


%compute K


n=length(Xtr);
lambda= 1;
sigma = 1;

%compute alpha
for num=1:10  %on regarde si l'image correspond au chiffre num-1
    alpha{num}=(K+lambda*n*eye(n))\Ytr(:,2);
end


%compute scores for the validation set
score=compute_score(n,alpha,Xval,Xtr,sigma,1); %set last parameter to 1 to track progress
[~,attrib] = max(score, [], 2);

score = norm((attrib-Yval(:,2)) == 0)/length(Yval);

