function [optIdx_acc,optIdx_gyro] =optIdx_for_acc_gyro_featComp(EpochFeat,opt)

% seperately select good epochs 

EpochFeat_ncs=EpochFeat(:,:,1);
EpochFeat_acc=EpochFeat(:,:,2:4);
EpochFeat_gyro=EpochFeat(:,:,5:7);


flag_ncs_feat=zeros(size(EpochFeat_ncs,1),length(opt.featThIdx)+length(opt.feat2ThIdx)); 
flag_ncs=zeros(size(EpochFeat_ncs,1),1); 
flag_acc=zeros(size(EpochFeat_ncs,1),1);
flag_acc_feat=zeros(size(EpochFeat_ncs,1),length(opt.featThIdx)+length(opt.feat2ThIdx)); 
%% select the best 3 channels of ACC +GRYO   use all COV: br,ibi,pp,in,ex 
% seperately acc +gyro
for n=1:size(EpochFeat_ncs,1)
    for m=1:size(EpochFeat_acc,3)
        feat_comp_acc_ind=15:19;  % cov 5
    
    covTemp(m)=mean(EpochFeat_acc(n,feat_comp_acc_ind,m),'all');
    end
    
    covTemp(covTemp==0)=100;   %% important!! if no more than 2 cycles detected, then cov =0, should delete ! 
    [temp_cov,temp] = sort (covTemp, 'ascend'); 
     n_temp = temp (1);
    
    
    optIdx_acc(n)=n_temp;
   
end

for n=1:size(EpochFeat_ncs,1)
    for m=1:size(EpochFeat_acc,3)
        feat_comp_acc_ind=15:19;  % cov 5
    
    covTemp(m)=mean(EpochFeat_gyro(n,feat_comp_acc_ind,m),'all');
    end
    
    covTemp(covTemp==0)=100;   %% important!! if no more than 2 cycles detected, then cov =0, should delete ! 
    [temp_cov,temp] = sort (covTemp, 'ascend'); 
     n_temp = temp (1);
    
    
    optIdx_gyro(n)=n_temp;
   
end




end