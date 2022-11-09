function [flag_ncs,flag_acc,optIdx_acc,property] =featComp(EpochFeat,opt)

% seperately select good epochs 

EpochFeat_ncs=EpochFeat(:,:,1);EpochFeat_acc=EpochFeat(:,:,2:7);


flag_ncs_feat=zeros(size(EpochFeat_ncs,1),length(opt.featThIdx)+length(opt.feat2ThIdx)); 
flag_ncs=zeros(size(EpochFeat_ncs,1),1); 
flag_acc=zeros(size(EpochFeat_ncs,1),1);
flag_acc_feat=zeros(size(EpochFeat_ncs,1),length(opt.featThIdx)+length(opt.feat2ThIdx)); 
%% select the best 3 channels of ACC +GRYO   use all COV: br,ibi,pp,in,ex 
for n=1:size(EpochFeat_ncs,1)
    for m=1:size(EpochFeat_acc,3)
        feat_comp_acc_ind=15:19;  % cov 5
    
    covTemp(m)=mean(EpochFeat_acc(n,feat_comp_acc_ind,m),'all');
    end
    
    covTemp(covTemp==0)=100;   %% important!! if no more than 2 cycles detected, then cov =0, should delete ! 
    [temp_cov,temp] = sort (covTemp, 'ascend'); 
     n_temp = temp (1:3); n_temp_cov = temp_cov (1:3);
    
    
    optIdx_acc(n,:)=n_temp;
    optIdx_acc_cov(n,:)=n_temp_cov;
    
    
    cov_ncs(n,1)=mean(EpochFeat_ncs(n,feat_comp_acc_ind),'all');
end


%% select good epoch in NCS and ACC   result store in 'flag_ncs' 
flag_ncs(:)=1;flag_ncs_feat(:,:)=1;flag_acc(:)=1;flag_acc_feat(:,:)=1;
flag_ncs_cov=flag_ncs;flag_acc_cov=flag_acc;
% feat should < threshold , variation smaller than threshold 
for n=1:size(EpochFeat_ncs,1)
   for i=1:length(opt.featThIdx)
       EpochFeat_ncs_t=EpochFeat_ncs(n,opt.featThIdx(i));
       EpochFeat_acc_t=EpochFeat_acc(n,opt.featThIdx(i),optIdx_acc(n,1));  % the optimal channel from ACC+GRYO
       th=opt.featTh(i);
       
       if EpochFeat_ncs_t> th 
          flag_ncs_feat(n,i)=0;
          flag_ncs(n)=0;
       end
       
       if EpochFeat_acc_t> th 
          flag_acc_feat(n,i)=0;
          flag_acc(n)=0;
       end
       
 
   end
end
% FEAT 2 % feat2 should > threshold , BR , power spectrom  higher than threshold 
n_feat1=length(opt.featThIdx);
for n=1:size(EpochFeat_ncs,1)
   for i=1:length(opt.feat2ThIdx)
       EpochFeat_ncs_t=EpochFeat_ncs(n,opt.feat2ThIdx(i));
       EpochFeat_acc_t=EpochFeat_acc(n,opt.feat2ThIdx(i),optIdx_acc(n,1));  % the optimal channel 
       th=opt.feat2Th(i);
       
       if EpochFeat_ncs_t< th 
          flag_ncs_feat(n,i+n_feat1)=0;
          flag_ncs(n)=0;
       end
       
       if EpochFeat_acc_t< th 
          flag_acc_feat(n,i+n_feat1)=0;
          flag_acc(n)=0;
       end
 
   end
end
% cov mean threshold 

for n=1:size(EpochFeat_ncs,1)
    
       if cov_ncs(n)> opt.covThNcs 
          flag_ncs_cov(n)=0;
          flag_ncs(n)=0;
       end
       
       if optIdx_acc_cov(n,1)> opt.covThAcc
          flag_acc_cov(n)=0;
          flag_acc(n)=0;
       end

end


property.optIdx_acc=optIdx_acc;property.flag_acc=flag_acc;property.flag_ncs=flag_ncs;

property.trueRate_ncs=length(flag_ncs(flag_ncs==1))/size(flag_ncs,1);
property.trueRate_acc=length(flag_acc(flag_acc==1))/size(flag_acc,1);
for i=1:length(opt.featThIdx)+length(opt.feat2ThIdx)
    tempncs=flag_acc_feat(:,i);
    tempacc=flag_acc_feat(:,i);
    property.trueRate_acc_feat(i)=length(tempacc(tempacc==1))/size(flag_acc,1);
    property.trueRate_ncs_feat(i)=length(tempncs(tempncs==1))/size(flag_acc,1);
end
property.trueRate_acc_cov=length(flag_acc_cov(flag_acc_cov==1))/size(flag_acc,1);
property.trueRate_ncs_cov=length(flag_ncs_cov(flag_ncs_cov==1))/size(flag_acc,1);

property.flag_acc_feat=flag_acc_feat;property.flag_ncs_feat=flag_ncs_feat;
property.flag_acc_cov=flag_acc_cov;property.flag_ncs_cov=flag_ncs_cov;


property.optIdx_count={};
for i=1:3
property.optIdx_count{i}=uniqueCount(optIdx_acc(:,i));
end

end