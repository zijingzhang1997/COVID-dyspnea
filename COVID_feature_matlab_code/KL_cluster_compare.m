clear all
close all
feature_tN={'mean(br)','std(br)','mean(ibi)','std(ibi)','mean(pp)','std(pp)','mean(in)','std(in)','mean(ex)','std(ex)',...
    'mean(IEpp)','std(IEpp)','mean(IER)','std(IER)',...
        'covBR','covPP','covIN','covEX','covIBI',... 
        'Cor_br', 'SD_br','Cor_ibi','SD_ibi','Cor_pp','SD_pp','Cor_in','SD_in','Cor_ex','SD_ex','Cor_IEpp','SD_IEpp','Cor_IER','SD_IER',...
        'skew_mean', 'kurt_mean','entro','cycle'};

feature_fN={'signal rr*60','signal hr*60','snr hr','snr br',...
  'p spec(1)','p spec(2)','p spec(3)','p spec(4)','p spec(5)',...
 ' p ratio(1)','p ratio(2)','p ratio(3)','p ratio(4)','p ratio(5)'};  
FeatureName=vertcat(feature_tN', feature_fN');
savePath='D:\COVID\result\all_compare_fig\';
% load data 
close all
foldVer='Feat_NCS';
loadVer='v1_newTh1';
%loadVer='v1_noTh';
loadPath_COVIDAll=['D:\COVID\COVID_HF_spectrum\result\',foldVer,'\featureAll\',loadVer,'\all_p_Feat_covid.mat'];
load(loadPath_COVIDAll);
feat_acc_covid=EpochFeat_sel_acc_all_p(:,:,1);
feat_ncs_covid=EpochFeat_sel_ncs_all_p;

% dyspnea data 
rNum=1;
loadPath_dyspnea=['D:\COVID\dyspnea\featureAll\','Routine',num2str(rNum),'_all.mat'];
load(loadPath_dyspnea);
feat_ncs_dyspnea_R1=EpochFeat_ncs_all;
feat_bio_dyspnea_R1=EpochFeat_bio_all;
rNum=3;
loadPath_dyspnea=['D:\COVID\dyspnea\featureAll\','Routine',num2str(rNum),'_all.mat'];
load(loadPath_dyspnea);
feat_ncs_dyspnea_R3=EpochFeat_ncs_all;
feat_bio_dyspnea_R3=EpochFeat_bio_all;
%% NEW dyspnea study 
DNewVer='v3_test';
loadPath_dyspneaNew_Normal=['D:\COVID\COVID_HF_spectrum\result\dyspnea_study_new\featureAll\',DNewVer,'\NormalBreath_all_p_LF_feat.mat'];
load(loadPath_dyspneaNew_Normal);
feat_acc_dyspNew_Normal=EpochFeat_sel_acc_all_p; % 3 optimal channels, choose 0 channel first  
feat_ncs_dyspNew_Normal=EpochFeat_sel_ncs_all_p;
p_ncs_dyspNew_Normal=p_num_ncs_all_p;  % number of participant of every sample 
p_acc_dyspNew_Normal=p_num_acc_all_p;
loadPath_dyspneaNew_Exer=['D:\COVID\COVID_HF_spectrum\result\dyspnea_study_new\featureAll\',DNewVer,'\PostExercise_all_p_LF_feat.mat'];
load(loadPath_dyspneaNew_Exer);
feat_acc_dyspNew_Exercise=EpochFeat_sel_acc_all_p; % 3 optimal channels, choose 0 channel first  
feat_ncs_dyspNew_Exercise=EpochFeat_sel_ncs_all_p;
p_ncs_dyspNew_Exercise=p_num_ncs_all_p;  % number of participant of every sample 
p_acc_dyspNew_Exercise=p_num_acc_all_p;


%% cluster scatter plts
feat={};

legN={};
SizeN=[];
% feat{1}=feat_ncs_sleep_0;legN{1}='Sleep Normal';SizeN(1)=4;
% feat{2}=feat_ncs_sleep_1;legN{2}='Sleep Disorder';SizeN(3)=5;

%  datasets to compare COVID with 
% three options: ncs New; acc New; ncs Old 
feat{1}=feat_acc_covid(:,1:51,1);legN{1}='COVID';SizeN(1)=10;
feat{end+1}=feat_ncs_dyspNew_Normal(:,1:51);legN{end+1}='Healthy Normal ncs New';
feat{end+1}=feat_ncs_dyspNew_Exercise(:,1:51);legN{end+1}='Healthy Exercise ncs New';

feat{end+1}=feat_acc_dyspNew_Normal(:,1:51);legN{end+1}='Healthy Normal acc New';
feat{end+1}=feat_acc_dyspNew_Exercise(:,1:51);legN{end+1}='Healthy Exercise acc New';

feat{end+1}=feat_ncs_dyspnea_R1(:,1:51);legN{end+1}='Healthy Normal ncs Old';
feat{end+1}=feat_ncs_dyspnea_R3(:,1:51);legN{end+1}='Healthy Exercise ncs Old';


cN={'g','blue','r'};
status = mkdir([savePath,'fig_SG']);
SaveN='SG_DyspOld_ncs';
SaveN='SG_DyspNew_ncs';
featNum_all=[1,2, 15,19,20,24, 23,22];

KL_all=[];
for i =1: length(featNum_all)
    for j =1: length(feat)-1

KL_all(i,j)=KL_cal(feat{1}(:,featNum_all(i)),feat{j+1}(:,featNum_all(i)));


    end 
end 

for i =1: length(featNum_all)
  

KL_ncs_acc_dyspNew(i,1)=KL_cal(feat{2}(:,featNum_all(i)),feat{4}(:,featNum_all(i)));
KL_ncs_acc_dyspNew(i,2)=KL_cal(feat{3}(:,featNum_all(i)),feat{5}(:,featNum_all(i)));


end 

status = mkdir([savePath,'KL_score']);


KL_all_str = string([KL_all ;mean(KL_all,1)]);
%round to 2 decimal places
for i = 1:numel(KL_all_str)
KL_all_str(i) = sprintf('%.2f',KL_all_str(i));
end
RN = cat(1, FeatureName(featNum_all), {'mean'});
KL_all_T=array2table(KL_all_str,'VariableNames',legN(2:7),'RowNames',RN);
SaveN='dyspNew_v3';




KL_acc_ncs_str = string([KL_ncs_acc_dyspNew',mean(KL_ncs_acc_dyspNew',2)]);
for i = 1:numel(KL_acc_ncs_str)
KL_acc_ncs_str(i) = sprintf('%.2f',KL_acc_ncs_str(i));
end
RN = cat(1, FeatureName(featNum_all), {'mean'});
KL_acc_ncs_T=array2table(KL_acc_ncs_str,'VariableNames',RN,'RowNames',{'Normal','Exercise'});

% 'right X>Y mean 
featNum_all=[1,2, 15,19,20,24, 23,22];
[h,p,ci,stats] = ttest2(feat{3}(:,featNum_all),feat{1}(:,featNum_all),'Alpha',0.001,'Vartype','unequal');
[h2,p2,ci2,stats2] = ttest2(feat{1}(:,featNum_all),feat{3}(:,featNum_all),'Alpha',0.001);

featNum_all=[2];
[h,p,ks2stat] = kstest2(feat{2}(:,featNum_all),feat{1}(:,featNum_all),'Alpha',0.05,'Tail','unequal');

h1 = kstest(feat{1}(:,featNum_all));
% writetable(KL_all_T,[savePath,'KL_score\',SaveN,'all_feat_sel.xlsx'],'WriteRowNames',true);
% writetable(KL_acc_ncs_T,[savePath,'KL_score\',SaveN,'acc_ncs_feat_sel.xlsx'],'WriteRowNames',true);
% 
% 
% save([savePath,'KL_score\',SaveN,'all_feat_sel.mat'],...
%     'loadPath_dyspnea','loadPath_dyspneaNew_Normal',...
%     'feat','legN','KL_all','KL_ncs_acc_dyspNew','loadPath_COVIDAll');





