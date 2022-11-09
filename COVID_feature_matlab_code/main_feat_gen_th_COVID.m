%% main function

% need to first choose a 60min waveform  subj, seg num 

SaveVer='v1';  % accroding to the opt , comp parameters selection, feature can be different 

for i=3:14
subj=i;
main_subj_feat_gen(subj,SaveVer);
end
function main_subj_feat_gen(subj,SaveVer)
subjName=[num2str(subj,'%02d')];

FolderVer='Feat_NCS\';
OptOverlap=1;


if OptOverlap==1
Folder='D:\COVID\COVID_HF_spectrum\result\';
fprintf(' overlap 30s');
end
if OptOverlap==0
Folder='D:\COVID\COVID_HF_spectrum\result_no_overlap\';
fprintf(' no overlap');
end
SavePath=[Folder,FolderVer,'per_feat\',SaveVer,'\'];
DataVer='v1'; % 0.01 -2 Hz
DataPath1=['D:\COVID\result\',FolderVer,'per_mat\',DataVer,'\',subjName,'.mat'];
opts1.smfilt=1;  % whehter to add smooth filter
fs_acc=20;fs_NCS=200;  % mat file sample rate 
fs=20;  % final sample rate 

load(DataPath1);
fprintf('case: %s \n',subjName);
%% divide into segments as every cell 
 for i=1:length(acc_gyro_ch_all)

seg=i;

acc_ch_seg=acc_gyro_ch_all{seg}';
NCS_ch_seg=downsample(NCS_ch_all{seg},fs_NCS/fs);

if opts1.smfilt==1
    
    acc_ch_seg=sgolayfilt(acc_ch_seg,4,51);
    NCS_ch_seg=sgolayfilt(NCS_ch_seg,4,51);
end
NCS_acc_ch_seg=cat(2,NCS_ch_seg',acc_ch_seg);



%% 
[prop_select,EpochFeat,opt]=gen_seg_in_subj(subj,seg,NCS_acc_ch_seg,SavePath,opt_all,OptOverlap);



%% save figure and feature result 


%% save figure and feature result 


prop_select_all{i}=prop_select;

EpochFeat_all{i}=single(EpochFeat); % number of epoch; number of feature; channel number ( NCS+ ACC+GRYO)

flag_ncs_all{i}=prop_select.flag_ncs;
flag_acc_all{i}=prop_select.flag_acc; optIdx_acc_all{i}=prop_select.optIdx_acc;

end



save([SavePath,subjName,'_Epochfeat.mat'],'-v7.3','prop_select_all','flag_ncs_all','flag_acc_all','optIdx_acc_all',...
      'EpochFeat_all',...
      'opt');

  
 
end


  function [prop_select,EpochFeat,opt]=gen_seg_in_subj(subj,seg,NCS_acc_ch_seg,SavePath,opt_all,OptOverlap)
%% pre-process data with filter,  transfer into epoch data and extract features
if OptOverlap==1
opt.twin=60;opt.twinMove=30;
end
if OptOverlap==0
opt.twin=60;opt.twinMove=60;
end

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

close all
fs=20;

opt.freq_range=[0,0.4;0.4,1;1,2]; 
opt.freq_range_rr=0.15; 
opt.minInterceptDist = 0.15;  % minimum time (s) between two intercepts (up and down) %paramters in sub function :peakDet3
opt.tWinPk=3; %window for peak detection % paramters in sub function :peakDet3
opt.calib=1; %parameter for peak det. calibrate out peaks < ratio*mean during calibT
opt.calibT=[1 opt.twin];%calibration period  
opt.calibMinPkRatio=0.3;
opt.featNum=51;
all_hr=[94 91 78 74 79 86 64 68 88 57 105 89];
all_rr=[20 25 34 19 22 21 20 26 29 22 20 20];
opt.patient_rr=all_hr(subj-2);opt.patient_hr=all_hr(subj-2);


[EpochFeat,StEpochTime,EpochData]=windowFeat(NCS_acc_ch_seg,fs,opt);







%% compare and choose the good epochs 


%v1
% opt.featTh=[38,9,1.3,0.4,0.7,0.7,0.7,0.7]; opt.featThIdx=[1,2,4,15,16,17,18,19];  
% % feat should < threshold , variation smaller than threshold 
% opt.feat2Th=[12,35,30]; opt.feat2ThIdx=[1,42,43]; 
% % feat2 should > threshold , BR , power spectrom  higher than threshold 
% opt.covThAcc=0.35; opt.covThNcs=0.35; % mean  of cov (5 feature) should < threshold 

opt.featTh=[35,8,1.1,0.4,0.7,0.7,0.7,0.7]; opt.featThIdx=[1,2,4,15,16,17,18,19]; 
opt.feat2Th=[12,35,30]; opt.feat2ThIdx=[1,42,43]; 
opt.covThAcc=0.4; opt.covThNcs=0.4; 


[flag_ncs,flag_acc,optIdx_acc,prop_select] =featComp(EpochFeat,opt);
trueRate_acc=prop_select.trueRate_acc;
trueRate_ncs=prop_select.trueRate_ncs;
fprintf('subj:%d seg:%d NCS sel: %.2f ACC sel: %.2f\n',subj,seg,trueRate_ncs,trueRate_acc);
%% plot figture
chName={'NCS Amp','acc X','acc Y','acc z','gryo X','gryo Y','gryo Z'};
opt_seg=opt_all{seg};
featShow=[1,2,5,6,42,43];

% example number of epoch 

if isempty(find(flag_ncs==0))
    h1_opt=[];
else
h1_opt=1;
num_all=find(flag_ncs==0);num=num_all(1);
[h(1),tle{1}]=plotEpoch(EpochData,num,opt,fs,opt_seg,StEpochTime,chName,featShow,FeatureName,flag_ncs,flag_acc);

end
if isempty(find(flag_ncs==1))
    h2_opt=[];
   
else
h2_opt=1;
num_all=find(flag_ncs==1);num=num_all(1);
[h(2),tle{2}]=plotEpoch(EpochData,num,opt,fs,opt_seg,StEpochTime,chName,featShow,FeatureName,flag_ncs,flag_acc);

end

if isempty(h1_opt)
else
subjName=[num2str(subj,'%02d')];
figName1 = [SavePath,'fig_seg\tiff\',subjName,'\seg',num2str(seg),'_ncs_0'];
print(h(1),[figName1,'.tiff'],'-dtiff','-r300');
figName1 = [SavePath,'fig_seg\fig\',subjName,'\seg',num2str(seg),'_ncs_0'];
savefig(h(1),[figName1,'.fig']);
end

if isempty(h2_opt)
else
subjName=[num2str(subj,'%02d')];
figName2 = [SavePath,'fig_seg\tiff\',subjName,'\seg',num2str(seg),'_ncs_1'];
print(h(2),[figName2,'.tiff'],'-dtiff','-r300');
figName2 = [SavePath,'fig_seg\fig\',subjName,'\seg',num2str(seg),'_ncs_1'];
savefig(h(2),[figName2,'.fig']);
end


end