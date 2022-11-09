%% main function

clear all
% need to first choose a 60min waveform  subj, seg num  
% accroding to the opt , comp parameters selection, feature can be different 
% from 'per_mat'  v1,  
% newTh: but need further more strict threshold to get finalepochs  

SaveVer='v1';
% SaveVer='acc_gyro_seperate_v1_newTh1';
OptOverlap=0;
if OptOverlap==1
Path='D:\COVID\COVID_HF_spectrum\result\';
fprintf(' overlap true');
end
if OptOverlap==0
Path='D:\COVID\COVID_HF_spectrum\result_no_overlap\';
fprintf(' no overlap');
end

foldVer='Feat_NCS_healthy';
status = mkdir([Path,foldVer,'\featureAll\',SaveVer]);

% initiate feature for all patients (3-13)
EpochFeat_sel_ncs_all_p=[];
EpochFeat_sel_acc_all_p=[];
EpochFeat_HF_sel_ncs_all_p=[];
EpochFeat_HF_sel_acc_all_p=[];
EpochFeat_HF_sel_gyro_all_p=[];

seg_num_ncs_all_p=[];
seg_num_acc_all_p=[];
p_num_ncs_all_p=[];
p_num_acc_all_p=[];
prop_select_all_p=[];
for subj=1

subjName=[num2str(subj,'%02d')];
loadVer='v1';


new_thres=0;  % whether to add new threshold ? 

%foldVer='Feat_NCS_healthy';
loadPath=[Path,foldVer,'\per_feat\',loadVer,'\',subjName,'_Epochfeat.mat'];


savePath=[Path,foldVer,'\featureAll\',SaveVer,'\',subjName,'_allFeat_HFspec_healthy.mat'];
saveFeatPath=[Path,foldVer,'\featureAll\',SaveVer,'\',subjName,'_allFeat_healthy.mat'];

fs=20;  % final sample rate 

load(loadPath); 

fprintf('case: %s \n',subjName);
EpochFeat_sel_ncs=[];
EpochFeat_sel_acc=[];
EpochFeat_HF_sel_ncs=[];
EpochFeat_HF_sel_acc=[];
EpochFeat_HF_sel_gyro=[];
sel_ncs_ratio=[];
sel_acc_ratio=[];
seg_num_ncs=[];
seg_num_acc=[];
%% divide into segments as every cell 
for i=1:length(EpochFeat_all)

seg=i;

prop_select=prop_select_all{i};

EpochFeat=EpochFeat_all{i}; % number of epoch; number of feature; channel number ( NCS+ ACC+GRYO)
EpochFeat_HF=EpochFeat_HF_all{i};  % HF  FROM feat V2 , 0.01 10HZ  epoch; HF feat ; channel  ( NCS+ ACC+GRYO)

flag_ncs=prop_select.flag_ncs;
flag_acc=prop_select.flag_acc;
optIdx_acc=prop_select.optIdx_acc;
%% before generate all datasets, further set strict threshold to change flag NCS. 
trueRate_acc=prop_select.trueRate_acc;
trueRate_ncs=prop_select.trueRate_ncs;

if new_thres==1
%  
% % feat should < threshold , variation smaller than threshold 
% % feat2 should > threshold , BR , power spectrom  higher than threshold 
% % mean  of cov (5 feature) should < threshold 


% v1_newth2
% opt.featTh=[38,5,1,0.3,0.3,0.3,0.3,0.3]; opt.featThIdx=[1,2,6,15,16,17,18,19];  
% opt.feat2Th=[12,35,30,0.75,0.75]; opt.feat2ThIdx=[1,42,43,20,24]; 
% opt.covThAcc=0.2; opt.covThNcs=0.25;
opt.featTh=[38,8,1.2,0.5,0.5,0.7,0.7,0.7]; opt.featThIdx=[1,2,6,15,16,17,18,19];  
opt.feat2Th=[12,35,30,0.75,0.75]; opt.feat2ThIdx=[1,42,43,20,24]; 
opt.covThAcc=0.35; opt.covThNcs=0.35;



[flag_ncs,flag_acc,optIdx_acc,prop_select] =featComp(EpochFeat,opt);

fprintf('new thres subj:%d seg:%d NCS sel: %.2f ACC sel: %.2f\n',subj,seg,trueRate_ncs,trueRate_acc);
%over write selection property 

prop_select_all{i}=prop_select;
else 
    fprintf('no new thres subj:%d seg:%d NCS sel: %.2f ACC sel: %.2f\n',subj,seg,trueRate_ncs,trueRate_acc);
end
%% use flag ncs /acc to select the good epochs seperately , the number of epochs are different for ncs acc
% for NCS , use the first channel 


optIdx_acc_gyro=optIdx_acc;
[optIdx_acc,optIdx_gyro] =optIdx_for_acc_gyro_featComp(EpochFeat,opt);

EpochFeat_sel_ncs_temp=EpochFeat(find(flag_ncs==1),:,1);  
EpochFeat_HF_sel_ncs_temp=EpochFeat_HF(find(flag_ncs==1),:,:,1);

% all togethre of acc and gryo 
optIdx_sel_acc_gyro=optIdx_acc_gyro(find(flag_acc==1),:)+1;

optIdx_sel_acc=optIdx_acc(find(flag_acc==1))+1;
optIdx_sel_gyro=optIdx_gyro(find(flag_acc==1))+4;

idx1=find(flag_acc==1);

%choose the optimal channels : first 3 
for m=1:length(find(flag_acc==1))
    
    EpochFeat_sel_acc_temp(m,:,:)=EpochFeat(idx1(m),:,optIdx_sel_acc_gyro(m,:));
    EpochFeat_HF_sel_acc_temp(m,:,:)=EpochFeat_HF(idx1(m),:,:,optIdx_sel_acc(m));
    EpochFeat_HF_sel_gyro_temp(m,:,:)=EpochFeat_HF(idx1(m),:,:,optIdx_sel_gyro(m));
end

EpochFeat_sel_ncs=single(cat(1,EpochFeat_sel_ncs, EpochFeat_sel_ncs_temp));
EpochFeat_sel_acc=single(cat(1,EpochFeat_sel_acc, EpochFeat_sel_acc_temp));

EpochFeat_HF_sel_ncs=single(cat(1,EpochFeat_HF_sel_ncs, EpochFeat_HF_sel_ncs_temp));
EpochFeat_HF_sel_acc=single(cat(1,EpochFeat_HF_sel_acc, EpochFeat_HF_sel_acc_temp));
EpochFeat_HF_sel_gyro=single(cat(1,EpochFeat_HF_sel_gyro, EpochFeat_HF_sel_gyro_temp));



sel_acc_ratio(end+1)=prop_select.trueRate_acc;
sel_ncs_ratio(end+1)=prop_select.trueRate_ncs;



seg_num_ncs=cat(1,seg_num_ncs, ones(size(EpochFeat_sel_ncs_temp,1),1)*seg);
seg_num_acc=cat(1,seg_num_acc, ones(size(EpochFeat_sel_acc_temp,1),1)*seg);

end
EpochFeat_sel_ncs_mean=mean(EpochFeat_sel_ncs,1);
EpochFeat_sel_acc_mean=mean(EpochFeat_sel_acc,1);
EpochFeat_sel_ncs_std=std(EpochFeat_sel_ncs,1);
EpochFeat_sel_acc_std=std(EpochFeat_sel_acc,1);



save(savePath,'-v7.3','EpochFeat_sel_ncs','EpochFeat_sel_acc',...
    'EpochFeat_HF_sel_ncs','EpochFeat_HF_sel_acc','EpochFeat_HF_sel_gyro',...
    'prop_select_all','opt',...
    'sel_acc_ratio','sel_ncs_ratio','seg_num_ncs','seg_num_acc','prop_select_all',...
    'EpochFeat_sel_ncs_mean','EpochFeat_sel_acc_mean',...
    'EpochFeat_sel_ncs_std','EpochFeat_sel_acc_std');

save(saveFeatPath,'-v7.3','EpochFeat_sel_ncs','EpochFeat_sel_acc',...
    'prop_select_all','opt',...
    'sel_acc_ratio','sel_ncs_ratio','seg_num_ncs','seg_num_acc','prop_select_all',...
    'EpochFeat_sel_ncs_mean','EpochFeat_sel_acc_mean',...
    'EpochFeat_sel_ncs_std','EpochFeat_sel_acc_std');



EpochFeat_sel_ncs_all_p=cat(1,EpochFeat_sel_ncs_all_p, EpochFeat_sel_ncs);
EpochFeat_sel_acc_all_p=cat(1,EpochFeat_sel_acc_all_p, EpochFeat_sel_acc);

EpochFeat_HF_sel_ncs_all_p=cat(1,EpochFeat_HF_sel_ncs_all_p, EpochFeat_HF_sel_ncs);
EpochFeat_HF_sel_acc_all_p=cat(1,EpochFeat_HF_sel_acc_all_p, EpochFeat_HF_sel_acc);
EpochFeat_HF_sel_gyro_all_p=cat(1,EpochFeat_HF_sel_gyro_all_p, EpochFeat_HF_sel_gyro);


seg_num_ncs_all_p=cat(1,seg_num_ncs_all_p,seg_num_ncs);
seg_num_acc_all_p=cat(1,seg_num_acc_all_p,seg_num_acc);
p_num_ncs_all_p=cat(1,p_num_ncs_all_p,ones(size(seg_num_ncs,1),1)*subj);
p_num_acc_all_p=cat(1,p_num_acc_all_p,ones(size(seg_num_acc,1),1)*subj);


prop_select_all_p{end+1}=prop_select_all;
%%
% delete data with nan values or inf 
rowstoremove = (sum(isnan(EpochFeat_sel_ncs_all_p),2) ~= 0) | (sum(isinf(EpochFeat_sel_ncs_all_p),2) ~= 0);
EpochFeat_sel_ncs_all_p(rowstoremove,:)=[];
EpochFeat_HF_sel_ncs_all_p(rowstoremove,:,:)=[];
seg_num_ncs_all_p(rowstoremove) = [];
p_num_ncs_all_p(rowstoremove)=[];


% only see at first channel with is the optimal channel of ACC
rowstoremove = (sum(isnan(EpochFeat_sel_acc_all_p(:,:,1)),2) ~= 0) | (sum(isinf(EpochFeat_sel_acc_all_p(:,:,1)),2) ~= 0);
EpochFeat_sel_acc_all_p(rowstoremove,:,:)=[];
EpochFeat_HF_sel_acc_all_p(rowstoremove,:,:)=[];
EpochFeat_HF_sel_gyro_all_p(rowstoremove,:,:)=[];

seg_num_acc_all_p(rowstoremove) = [];
p_num_acc_all_p(rowstoremove)=[];




end

EpochFeat_sel_ncs_all_p_mean=mean(EpochFeat_sel_ncs_all_p,1);
EpochFeat_sel_acc_all_p_mean=mean(EpochFeat_sel_acc_all_p,1);
EpochFeat_sel_ncs_all_p_std=std(EpochFeat_sel_ncs_all_p,1);
EpochFeat_sel_acc_all_p_std=std(EpochFeat_sel_acc_all_p,1);


% savePathAll=[Path,foldVer,'\featureAll\',SaveVer,'\all_p_Feat.mat'];
% save(savePathAll,'-v7.3','EpochFeat_sel_ncs_all_p','EpochFeat_sel_acc_all_p',...
%     'EpochFeat_HF_sel_ncs_all_p','EpochFeat_HF_sel_acc_all_p','EpochFeat_HF_sel_gyro_all_p',...
% 'seg_num_ncs_all_p','seg_num_acc_all_p','p_num_ncs_all_p','p_num_acc_all_p','prop_select_all_p',...
% 'opt');

% 
% %save in 'all_compare' folder 
% savePathAll=['D:\COVID\result\all_compare\mat','\COVID_feat_noNewth.mat'];
% save(savePathAll,'EpochFeat_sel_ncs_all_p','EpochFeat_sel_acc_all_p',...
% 'seg_num_ncs_all_p','seg_num_acc_all_p','p_num_ncs_all_p','p_num_acc_all_p','prop_select_all_p',...
% 'opt');


















 