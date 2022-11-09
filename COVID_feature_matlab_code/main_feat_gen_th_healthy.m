%% main function

% need to first choose a 60min waveform  subj, seg num 

SaveVer='v1';  % accroding to the opt , comp parameters selection, feature can be different 

for i=1  % subject number
subj=i;
main_subj_feat_gen(subj,SaveVer);
end
function main_subj_feat_gen(subj,SaveVer)
subjName=[num2str(subj,'%02d')];

OptOverlap=0;
if OptOverlap==1
Folder='D:\COVID\COVID_HF_spectrum\result\';
fprintf(' overlap 30s');
end
if OptOverlap==0
Folder='D:\COVID\COVID_HF_spectrum\result_no_overlap\';
fprintf(' no overlap');
end

FolderVer='Feat_NCS_healthy\';
DataVer='v1'; % 0.01 -2 Hz
DataPath1=['D:\COVID\result\',FolderVer,'per_mat\',DataVer,'\',subjName,'.mat'];
DataVer='v2'; % 0.01 -10 Hz  v2; no filter v3
DataPath2=['D:\COVID\result\',FolderVer,'per_mat\',DataVer,'\',subjName,'.mat'];

SavePath=[Folder,FolderVer,'per_feat\',SaveVer,'\'];


opts1.smfilt=1;  % whehter to add smooth filter
fs_acc=20;fs_NCS=200;  % mat file sample rate 
fs=20;  % final sample rate 

load(DataPath2); %v2 is high frequency included  data input
NCS_ch_all_HF=NCS_ch_all;
acc_gyro_ch_all_HF=acc_gyro_ch_all;
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

acc_HF_seg=acc_gyro_ch_all_HF{seg}';
NCS_HF_seg=downsample(NCS_ch_all_HF{seg},fs_NCS/fs);
NCS_acc_HF_seg=cat(2,NCS_HF_seg',acc_HF_seg);

% figure()
% Data=NCS_acc_ch_seg(:,5);
% periodogram(Data,hamming(length(Data)),length(Data),fs,'power');
% figure()
% Data=NCS_acc_HF_seg(:,5);
% periodogram(Data,hamming(length(Data)),length(Data),fs,'power');
% 
% figure()
% Data=NCS_acc_ch_seg(1:1000,5);
% plot(Data)
% figure()
% Data=NCS_acc_HF_seg(1:1000,5);
% plot(Data)

%% 
[prop_select,EpochFeat,EpochFeat_HF,opt]=gen_seg_in_subj(subj,seg,NCS_acc_ch_seg,NCS_acc_HF_seg,SavePath,opt_all,OptOverlap);



%% save figure and feature result 


prop_select_all{i}=prop_select;

EpochFeat_all{i}=single(EpochFeat); % number of epoch; number of feature; channel number ( NCS+ ACC+GRYO)
EpochFeat_HF_all{i}=single(EpochFeat_HF); % HF  FROM feat V2 ,
%  0.01 10HZ  dim =47 :   epoch; HF feat (freq*time) ; channel  ( NCS+ ACC+GRYO)

flag_ncs_all{i}=prop_select.flag_ncs;
flag_acc_all{i}=prop_select.flag_acc; optIdx_acc_all{i}=prop_select.optIdx_acc;

end



save([SavePath,subjName,'_Epochfeat.mat'],'-v7.3','prop_select_all','flag_ncs_all','flag_acc_all','optIdx_acc_all',...
      'EpochFeat_all','EpochFeat_HF_all',...
      'opt','OptOverlap');

  
 
end


  function [prop_select,EpochFeat,EpochFeat_HF,opt]=gen_seg_in_subj(subj,seg,NCS_acc_ch_seg,NCS_acc_HF_seg,SavePath,opt_all,OptOverlap)
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

opt.patient_rr=18;opt.patient_hr=80;


[EpochFeat,StEpochTime,EpochData]=windowFeat(NCS_acc_ch_seg,fs,opt);
% [EpochFeat2,~,EpochData2]=windowFeat(NCS_acc_HF_seg,fs,opt);


%% extra high frequency band features 
% pre filter? 


% spectrogram  dim:  frequency * time   can cut lower frequency to make
% shape consistent 
opt.STwin=3;opt.SToverlap=2.5;opt.STnfft=13; opt.Lfreq=1;
[EpochFeat_HF]=windowFeat_HF(NCS_acc_HF_seg,fs,opt);




%% compare and choose the good epochs 
% v1 for healthy, threshold lower !!!!
% you can set higher threshold in further processing by 'newTh'
opt.featTh=[38,10,1.5,0.5,0.7,0.7,0.7,0.7]; opt.featThIdx=[1,2,4,15,16,17,18,19]; 
opt.feat2Th=[10,35,30]; opt.feat2ThIdx=[1,42,43]; 
opt.covThAcc=0.5; opt.covThNcs=0.5; 


% % feat should < threshold , variation smaller than threshold 

% % feat2 should > threshold , BR , power spectrom  higher than threshold 
% % mean  of cov (5 feature) should < threshold 
%v1  for COVID 
% opt.featTh=[35,8,1.1,0.4,0.7,0.7,0.7,0.7]; opt.featThIdx=[1,2,4,15,16,17,18,19]; 
% opt.feat2Th=[12,35,30]; opt.feat2ThIdx=[1,42,43]; 
% opt.covThAcc=0.3; opt.covThNcs=0.3; 


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
k(1)=HF_plotEpoch(NCS_acc_HF_seg,num,opt,fs,opt_seg,StEpochTime,chName,featShow,FeatureName,flag_ncs,flag_acc);
g(1)=spec_plotEpoch(EpochData,num,opt,fs,opt_seg,StEpochTime,chName,optIdx_acc,flag_ncs,flag_acc);
end
if isempty(find(flag_ncs==1))
    h2_opt=[];
   
else
h2_opt=1;
num_all=find(flag_ncs==1);num=num_all(1);
[h(2),tle{2}]=plotEpoch(EpochData,num,opt,fs,opt_seg,StEpochTime,chName,featShow,FeatureName,flag_ncs,flag_acc);
k(2)=HF_plotEpoch(NCS_acc_HF_seg,num,opt,fs,opt_seg,StEpochTime,chName,featShow,FeatureName,flag_ncs,flag_acc);
g(2)=spec_plotEpoch(EpochData,num,opt,fs,opt_seg,StEpochTime,chName,optIdx_acc,flag_ncs,flag_acc);
end

if isempty(h1_opt)
else
subjName=[num2str(subj,'%02d')];
figName1 = [SavePath,'fig_seg\tiff\',subjName,'\seg',num2str(seg),'_ncs_0'];
print(h(1),[figName1,'.tiff'],'-dtiff','-r300');
print(g(1),[figName1,'spec.tiff'],'-dtiff','-r300');
print(k(1),[figName1,'spec_wave.tiff'],'-dtiff','-r300');
end

if isempty(h2_opt)
else
subjName=[num2str(subj,'%02d')];
figName2 = [SavePath,'fig_seg\tiff\',subjName,'\seg',num2str(seg),'_ncs_1'];
print(h(2),[figName2,'.tiff'],'-dtiff','-r300');
print(g(2),[figName2,'spec.tiff'],'-dtiff','-r300');
print(k(2),[figName2,'spec_wave.tiff'],'-dtiff','-r300');
end



end