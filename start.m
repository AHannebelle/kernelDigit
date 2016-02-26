Xtr=load('data/Xtr.csv');
Xte=load('data/Xte.csv');
Ytr=load('data/Ytr.mat');
Ytr=Ytr.Ytr;

%problem constants
n=length(Xtr);

%problem parameters
lambda= 1;
sigma = 1;
validation=1;

%validation set
if (validation>0)
    Xtr=Xtr(1:4000,:);
    Xval=Xtr(4001:end,:);
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

tic
K = compute_k(Xtr, sigma);
save('K.mat','K');
toc



%compute alpha
for num=1:10  %on regarde si l'image correspond au chiffre num-1
    alpha{num}=(K+lambda*n*eye(n))\Ytr(:,2);
end


%compute scores for the validation set
score=compute_score(n,alpha,Xval,Xtr,sigma,1); %set last parameter to 1 to track progress
[~,attrib]=max(score);

%compute scores for the test set
% score=compute_score(n,alpha,Xte,Xtr,sigma,1); %set last parameter to 1 to track progress
% [~,attrib]=max(score);


%to plot an imgae
%show(Xtr(2,:))
score=zeros(length(Xte),10);  %proba que le ie test� est le chifre j
for digit=1:10 %for each digit 'digit-1'
    %compute probability vector
    for i=1:n
        a = alpha{digit}; %vector alpha
        x = Xte(i,:); %test image
        output = 0;
        for j = 1:n
            output = output + a(j) * gaussian_dist(x,Xtr(j,:), sigma);
        end
    end
    score(i,digit)=output;
end

%compute scores
score=compute_score(n,alpha,Xte,Xtr,sigma,1); %set last parameter to 1 to track progress
attrib=max(score);