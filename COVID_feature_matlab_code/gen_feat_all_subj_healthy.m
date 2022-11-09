%% main function

%healthy version 
% need to first choose a 60min waveform  subj, seg num  
% accroding to the opt , comp parameters selection, feature can be different 
% from 'per_mat'  v1,  
% newTh: but need further more strict threshold to get finalepochs  
SaveVer='v1';
%SaveVer='v1';
foldVer='Feat_NCS_healthy';
status = mkdir(['D:\COVID\result\',foldVer,'\featureAll\',SaveVer]);

% initiate feature for all patients (3-13)
EpochFeat_sel_ncs_all_p=[];
EpochFeat_sel_acc_all_p=[];
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
loadPath=['D:\COVID\result\',foldVer,'\per_feat\',loadVer,'\',subjName,'_Epochfeat.mat'];
savePath=['D:\COVID\result\',foldVer,'\featureAll\',SaveVer,'\',subjName,'_allFeat.mat'];


fs=20;  % final sample rate 

load(loadPath); 

fprintf('case: %s \n',subjName);
EpochFeat_sel_ncs=[];
EpochFeat_sel_acc=[];
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

if new_thres==1
opt.featTh=[38,5,1,0.3,0.3,0.3,0.3,0.3]; opt.featThIdx=[1,2,6,15,16,17,18,19];  
% feat should < threshold , variation smaller than threshold 
opt.feat2Th=[12,35,30,0.75,0.75]; opt.feat2ThIdx=[1,42,43,20,24]; 
% feat2 should > threshold , BR , power spectrom  higher than threshold 
opt.covThAcc=0.2; opt.covThNcs=0.25; % mean  of cov (5 feature) should < threshold 


[flag_ncs,flag_acc,optIdx_acc,prop_select] =featComp(EpochFeat,opt);
trueRate_acc=prop_select.trueRate_acc;
trueRate_ncs=prop_select.trueRate_ncs;
fprintf('subj:%d seg:%d NCS sel: %.2f ACC sel: %.2f\n',subj,seg,trueRate_ncs,trueRate_acc);
%over write selection property 

prop_select_all{i}=prop_select;
end
%% use flag ncs /acc to select the good epochs seperately , the number of epochs are different for ncs acc
EpochFeat_sel_ncs_temp=cat(2,EpochFeat(find(flag_ncs==1),:,1),EpochFeat_HF(find(flag_ncs==1),:,1));
optIdx_sel=optIdx_acc(find(flag_acc==1),:)+1;
idx1=find(flag_acc==1);

%choose the optimal channels : first 3 
for m=1:length(find(flag_acc==1))
    
    EpochFeat_sel_acc_temp(m,:,:)=cat(2,EpochFeat(idx1(m),:,optIdx_sel(m,:)),...
    EpochFeat_HF(idx1(m),:,optIdx_sel(m,:)));

end

EpochFeat_sel_ncs=cat(1,EpochFeat_sel_ncs, EpochFeat_sel_ncs_temp);
EpochFeat_sel_acc=cat(1,EpochFeat_sel_acc, EpochFeat_sel_acc_temp);

sel_acc_ratio(end+1)=prop_select.trueRate_acc;
sel_ncs_ratio(end+1)=prop_select.trueRate_ncs;



seg_num_ncs=cat(1,seg_num_ncs, ones(size(EpochFeat_sel_ncs_temp,1),1)*seg);
seg_num_acc=cat(1,seg_num_acc, ones(size(EpochFeat_sel_acc_temp,1),1)*seg);

end
EpochFeat_sel_ncs_mean=mean(EpochFeat_sel_ncs,1);
EpochFeat_sel_acc_mean=mean(EpochFeat_sel_acc,1);
EpochFeat_sel_ncs_std=std(EpochFeat_sel_ncs,1);
EpochFeat_sel_acc_std=std(EpochFeat_sel_acc,1);



save(savePath,'EpochFeat_sel_ncs','EpochFeat_sel_acc','prop_select_all','opt',...
    'sel_acc_ratio','sel_ncs_ratio','seg_num_ncs','seg_num_acc','prop_select_all',...
    'EpochFeat_sel_ncs_mean','EpochFeat_sel_acc_mean',...
    'EpochFeat_sel_ncs_std','EpochFeat_sel_acc_std');

EpochFeat_sel_ncs_all_p=cat(1,EpochFeat_sel_ncs_all_p, EpochFeat_sel_ncs);
EpochFeat_sel_acc_all_p=cat(1,EpochFeat_sel_acc_all_p, EpochFeat_sel_acc);

seg_num_ncs_all_p=cat(1,seg_num_ncs_all_p,seg_num_ncs);
seg_num_acc_all_p=cat(1,seg_num_acc_all_p,seg_num_acc);
p_num_ncs_all_p=cat(1,p_num_ncs_all_p,ones(size(seg_num_ncs,1),1)*subj);
p_num_acc_all_p=cat(1,p_num_acc_all_p,ones(size(seg_num_acc,1),1)*subj);


prop_select_all_p{end+1}=prop_select_all;


end

EpochFeat_sel_ncs_all_p_mean=mean(EpochFeat_sel_ncs_all_p,1);
EpochFeat_sel_acc_all_p_mean=mean(EpochFeat_sel_acc_all_p,1);
EpochFeat_sel_ncs_all_p_std=std(EpochFeat_sel_ncs_all_p,1);
EpochFeat_sel_acc_all_p_std=std(EpochFeat_sel_acc_all_p,1);


savePathAll=['D:\COVID\result\',foldVer,'\featureAll\',SaveVer,'\all_p_Feat.mat'];
save(savePathAll,'EpochFeat_sel_ncs_all_p','EpochFeat_sel_acc_all_p',...
'seg_num_ncs_all_p','seg_num_acc_all_p','p_num_ncs_all_p','p_num_acc_all_p','prop_select_all_p',...
'opt');




















feature_tN={'mean(br)','std(br)','mean(ibi)','std(ibi)','mean(pp)','std(pp)','mean(in)','std(in)','mean(ex)','std(ex)',...
    'mean(IEpp)','std(IEpp)','mean(IER)','std(IER)',...
        'covBR','covPP','covIN','covEX','covIBI',... 
        'Cor_br', 'SD_br','Cor_ibi','SD_ibi','Cor_pp','SD_pp','Cor_in','SD_in','Cor_ex','SD_ex','Cor_IEpp','SD_IEpp','Cor_IER','SD_IER',...
        'skew_mean', 'kurt_mean','entro','cycle'};
feature_tN= strrep(feature_tN,'_',' ');
feature_fN={'signal rr*60','signal hr*60','snr hr','snr br',...
  'p spec(1)','p spec(2)','p spec(3)','p spec(4)','p spec(5)',...
 ' p ratio(1)','p ratio(2)','p ratio(3)','p ratio(4)','p ratio(5)'};  
FeatureName=vertcat(feature_tN', feature_fN');

 