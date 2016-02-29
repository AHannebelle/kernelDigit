Xtr=load('data/Xtr.csv');
Xte=load('data/Xte.csv');
Ytr=load('data/Ytr.mat');
Ytr=Ytr.Ytr;

%problem constants

%problem parameters

validation=1;

%validation set
if (validation>0)
    Xval=Xtr(1001:2000,:);
    Xtr=Xtr(1:1000,:);
    Yval = Ytr(1001:2000,:);
    Ytr = Ytr(1:1000,:);
end

%compute K
tic
lambda= 0.1;
sigma = 100;
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
lambda= 0.00001;
sigma = 10;
for u = 1:5
    sigma = 20
    for v = 1:5
        sigma = sigma - 3;
        %compute alpha
        for num=1:10  %on regarde si l'image correspond au chiffre num-1
            label=single(Ytr(1:1000,2) == num-1)-single(Ytr(1:1000,2)~=num-1);
            alpha{num}=(K+lambda*1000*eye(1000))\label;
        end


        %compute scores for the validation set
        score=compute_score(n,alpha,Xval,Xtr,sigma,1); %set last parameter to 1 to track progress
        [~,attrib] = max(score, [], 2);
        interm = (attrib-1)-Yval(:,2) == 0;
        score_final(u,v) = norm(single(interm), 1)/length(Yval)
    end
    lambda = lambda /10;
end


