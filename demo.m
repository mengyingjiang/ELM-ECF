clear all
load Indian;
load Indian_gt;
Data =image; 
n_class = max(GT(:));
[nr ,nc ,nDim] = size(Data);  nAll = nr*nc;
gt2 = reshape(GT, nAll, 1);
tmp = unique(gt2);  classLabel = tmp(tmp~=0); nClass = length(classLabel);
% clear DataClass;
data2 = reshape(Data, nAll, nDim);
% clear X Data DataClass Class Am;
data2 = data2 ./ max(data2(:));
n_times = 10;

sigma=[2^(-4),2^(-3),2^(-2),2^(-1),2^(0),2^(1),2^(2),2^(3),2^(4)];
lamada = [-17 -16 -15,-14,-13,-12, -11, -10,-9,-8];
L=180;
nsec=0.05;
mu=0.99;
wopt=3:2:15;
c=length(wopt);
classLabel=1:16;
classLabel=classLabel';
OA1=zeros(n_times,n_times);
% KAPPA1=zeros(10,1);
% AA1=zeros(10,1);

% CA1=zeros(9,10);
spatialfeature=zeros(nr*nc,nDim,c);
% nsec=5;
tstart = tic;
for i=1:c
    wide=wopt(i);
    spatialfeature(:,:,i)=neighborhood(wide,nr,nDim,nAll,data2,GT);  %ȡѵ���Ͳ��������Ŀռ���Ϣ
end
% swmftime=toc(tstart)

for j=1:n_times
    tstart = tic;
    [images, labels, indexs] = loadtrain1(data2,GT,nsec);                                          %ȡѵ������
    [testImages, testLabels, testIndexs] = loadtest(data2,GT,indexs);          %ȡ��������
    p=size(testLabels,1);
    pred1=zeros(c,p);
    pred2=zeros(1,p);
    for i=1:c
        tstart = tic;
        [~,ntrn]=size(images);
        [~,ntst]=size(testImages);
        XTrnm=spatialfeature(indexs,:,i);
        XTstm=spatialfeature(testIndexs,:,i);
        XTrn=images';
        XTst=testImages';
        YTrn=labels;
        [pred1(i,:)]=sselm(XTrn,XTst,XTrnm, XTstm,YTrn,L,mu);  %belm-cf
    end
    for k = 1 : ntst
        tmp  = pred1(:,k);
        itmp = unique(tmp);
        count = histc(tmp, itmp);
        [fc,ic] = max(count);           %fc is the number of max value and ic is the index of the max value.
        pred2(k) = itmp(ic);
    end
%     train_accuracy(j)=sum(pred2 == YTrn)/length(YTrn)
    pred=zeros(nr,nc);
    pred(testIndexs)=pred2;
    pred(indexs)=labels;
    [OA,kappa,CA,AA]=calcError(testLabels,pred(testIndexs), 1:n_class);
    OA1(j)=OA
    AA1(j)=AA
    KAPPA1(j)=kappa
%     CA1(:,j)=CA
    totaltime(j)=toc(tstart);
    
end

oa=mean(OA1)
%stdoa=std(OA1)
aa=mean(AA1)
%stdaa=std(AA1)
KAPPA=mean( KAPPA1)
%stdKAPPA=std( KAPPA1)
%stdca=std(CA1')
% ca=mean(CA1')
time=mean(totaltime)
stdtime=std(totaltime)
% tranacc=mean(train_accuracy)
% Totaltime= mean(totaltime)
% oa=mean(OA1)
% aa=mean(AA1)
% KAPPA=mean(KAPPA1)
% ca=mean(CA1')
% ca=mean(CA1')
% bcftraintime=mean(bcftraintime,1)
% bcftestime=mean(bcftestime,1)
% Kbcksearchtime=mean(kbcksearchtime,1)
% Kbcktraintime=mean(kbcktraintime,1)
% % Kbcktestime=mean(kbcktestime,1)
% figure,
% imagesc(pred)
% axis off
