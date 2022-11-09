foldVer='Feat_NCS';
loadVer='v1_newTh1';
%loadVer='v1_noTh';
loadPath_COVIDAll=['D:\COVID\COVID_HF_spectrum\result\',foldVer,'\featureAll\',loadVer,'\all_p_Feat_covid.mat'];
load(loadPath_COVIDAll);
feat_acc_covid=EpochFeat_sel_acc_all_p(:,:,1);
feat_ncs_covid=EpochFeat_sel_ncs_all_p;

for i=1:12
    seg_num=length(prop_select_all_p{1,i});
    for j= 1: seg_num
        a=prop_select_all_p{1,i}{1, j}.flag_ncs;
acc_num{i}(j)=size(a,1);
acc_num_p_covid(i)=sum(acc_num{i});
true_rate_acc_covid{i}(j)=prop_select_all_p{1,i}{1, j}.trueRate_acc;
true_rate_acc_covid_p(i)=mean(true_rate_acc_covid{i});
    end
end 
acc_num_sum_covid=sum(acc_num_p_covid);
sel_ratio_covid=size(feat_acc_covid,1)/acc_num_sum_covid;
true_rate_acc_covid_all=mean(true_rate_acc_covid_p);


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
acc_num=[];
for i=1:length(prop_select_all_p)
    seg_num=length(prop_select_all_p{1,i});
    for j= 1: seg_num
a=prop_select_all_p{1,i}{1, j}.flag_acc;
acc_num{i}(j)=size(a,1);
acc_num_p_dyspNew_Normal(i)=sum(acc_num{i});


    end
end 

acc_num_all_dyspNew_Normal=sum(acc_num_p_dyspNew_Normal);
acc_ratio_dyspNew_Normal=size(p_acc_dyspNew_Normal,1)/acc_num_all_dyspNew_Normal;
ncs_ratio_dyspNew_Normal=size(p_ncs_dyspNew_Normal,1)/acc_num_all_dyspNew_Normal;

DNewVer='v3_test';
loadPath_dyspneaNew_Exer=['D:\COVID\COVID_HF_spectrum\result\dyspnea_study_new\featureAll\',DNewVer,'\PostExercise_all_p_LF_feat.mat'];
load(loadPath_dyspneaNew_Exer);
feat_acc_dyspNew_Exercise=EpochFeat_sel_acc_all_p; % 3 optimal channels, choose 0 channel first  
feat_ncs_dyspNew_Exercise=EpochFeat_sel_ncs_all_p;
p_ncs_dyspNew_Exercise=p_num_ncs_all_p;  % number of participant of every sample 
p_acc_dyspNew_Exercise=p_num_acc_all_p;
p_num_count=uniqueCount(p_acc_dyspNew_Exercise);
acc_num=[];
for i=1:length(prop_select_all_p)
    seg_num=length(prop_select_all_p{1,i});
    for j= 1: seg_num
a=prop_select_all_p{1,i}{1, j}.flag_ncs;
acc_num{i}(j)=size(a,1);
acc_num_p_dyspNew_Exercise(i)=sum(acc_num{i});
true_rate_acc_dyspNew_Exercise{i}(j)=prop_select_all_p{1,i}{1, j}.trueRate_acc;
true_rate_acc_dyspNew_Exercise_p(i)=mean(true_rate_acc_dyspNew_Exercise{i});
true_rate_ncs_dyspNew_Exercise{i}(j)=prop_select_all_p{1,i}{1, j}.trueRate_ncs;
true_rate_ncs_dyspNew_Exercise_p(i)=mean(true_rate_ncs_dyspNew_Exercise{i});

    end
end 
acc_num_all_dyspNew_Exercise=sum(acc_num_p_dyspNew_Exercise);
acc_ratio_dyspNew_Exercise=size(p_acc_dyspNew_Exercise,1)/acc_num_all_dyspNew_Exercise;
ncs_ratio_dyspNew_Exercise=size(p_ncs_dyspNew_Exercise,1)/acc_num_all_dyspNew_Exercise;
