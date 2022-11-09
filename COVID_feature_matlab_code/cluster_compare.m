clear all
close all
feature_tN={'\it{\mu}_{BR}','\it{\mu}_{BR}','\it{\mu}_{IBI}','\it{\sigma}_{IBI}','\it{\mu}_{PP}','\it{\sigma}_{PP}',...
    '\it{\mu}_{IN}','\it{\sigma}_{IN}','\it{\mu}_{EX}','\it{\sigma}_{EX}',...
    '\it{\mu}_{IEPP}','\it{\sigma}_{IEPP}','\it{\mu}_{IER}','\it{\sigma}_{IER}',...
       '\it{COV}_{BR}','\it{COV}_{PP}','\it{COV}_{IN}','\it{COV}_{EX}','\it{COV}_{IBI}',... 
        '\it{\Re}_{BR}', '\it{\varsigma}_{BR}','\it{\Re}_{IBI}', '\it{\varsigma}_{IBI}',...
        '\it{\Re}_{PP}', '\it{\varsigma}_{PP}','\it{\Re}_{IN}', '\it{\varsigma}_{IN}',...
        '\it{\Re}_{EX}', '\it{\varsigma}_{EX}','\it{\Re}_{IEPP}', '\it{\varsigma}_{IEPP}',...
        '\it{\Re}_{IER}', '\it{\varsigma}_{IER}',...
        '\it{\mu}_{SKEW}', '\it{\mu}_{KURT}','entro','cycle'};

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

%% sleep data  divide into normal and disorder epochs 

loadPath_sleep=['D:\COVID\sleep study\dataSet\featureAll\','feature_data.mat'];
load(loadPath_sleep);
feat_ncs_sleep_0=featureNCS_0;
feat_ncs_sleep_1=featureNCS_1;
feat_psg_sleep_0=featurePSG_0;
feat_psg_sleep_1=featurePSG_1;


%% cluster scatter plts
feat={};

legN={};
SizeN=[];
% feat{1}=feat_ncs_sleep_0;legN{1}='Sleep Normal';SizeN(1)=4;
% feat{2}=feat_ncs_sleep_1;legN{2}='Sleep Disorder';SizeN(3)=5;

feat{1}=feat_acc_covid(:,1:51,1);legN{1}='COVID';SizeN(1)=10;
feat{end+1}=feat_ncs_dyspNew_Normal(:,1:51);legN{end+1}='Healthy Normal';
feat{end+1}=feat_ncs_dyspNew_Exercise(:,1:51);legN{end+1}='Healthy Exertion';
% feat{end+1}=feat_acc_dyspNew_Normal(:,1:51);legN{end+1}='Healthy Normal';
% feat{end+1}=feat_acc_dyspNew_Exercise(:,1:51);legN{end+1}='Healthy Exercise';
% feat{end+1}=feat_ncs_dyspnea_R1(:,1:51);legN{end+1}='Healthy Normal';
% feat{end+1}=feat_ncs_dyspnea_R3(:,1:51);legN{end+1}='Healthy Exercise';


cN={'g','blue','r'};
status = mkdir([savePath,'fig_SG']);
SaveN='SG_covid_acc_v1_newTh1_DyspOld_ncs';
SaveN='SG_covid_acc_v1_newTh1_DyspNew_acc_v3_test';
SaveN='SG_covid_acc_v1_newTh1_DyspNew_ncs_v3_test';
featNum_all=[1,2; 17,18;20,24; 26,28; 27,29];
featNum_all=[1,2; 15,19;20,24; 23,22];
for i=1: size(featNum_all,1)
    featNum=featNum_all(i,:);
    h=GaussianPlot(feat{1}(:,featNum),feat{2}(:,featNum),feat{3}(:,featNum),cN,legN,FeatureName(featNum));

    figName = [savePath,'fig_SG\',SaveN,'_feat',num2str(featNum(1)),'_',num2str(featNum(2))];
    print(h,[figName,'.tiff'],'-dtiff','-r300');
    savefig(h,[figName,'.fig']);
end 

save([savePath,'fig_SG\',SaveN,'all_feat.mat'],'feat','legN');


%%
% 
% n=3;
% sz=14;
% 
% legprop=['Location',"eastoutside"];
% h(1)=figure()
% subplot(1,n,1)
% featnum=[1,2];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% ylim([0 15])
% 
% subplot(1,n,2)
% featnum=[26,28];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% 
% xlim([0.5 1])
% ylim([0.5 1])
% 
% 
% subplot(1,n,3)
% featnum=[20,24];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% legend(legN,'FontSize',sz,'Location','eastoutside')
% xlim([0.5 1])
% ylim([0.5 1])
% set(gcf,'Position',[100,10,1500,400]);
% %%
% h(2)=figure()
% subplot(1,n,1)
% featnum=[17,18];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% xlim([0 1.2])
% ylim([0 2])
% 
% subplot(1,n,2)
% featnum=[25,23];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% % 
% xlim([0 1])
% ylim([0 1])
% 
% 
% subplot(1,n,3)
% featnum=[27,29];
% for i=1:length(feat)
% plot(feat{i}(:,featnum(1),1),feat{i}(:,featnum(2),1),'.','MarkerSize',SizeN(i),'color',cN{i});
% hold on
% end
% hold off
% xlabel(FeatureName{featnum(1)},'FontSize',sz)
% ylabel(FeatureName{featnum(2)},'FontSize',sz)
% legend(legN,'FontSize',sz,'Location','eastoutside')
% xlim([0 1])
% ylim([0 1])
% set(gcf,'Position',[100,10,1500,400]);
% %%

% SaveN='cluster_all6_comp1';
% figName = [savePath,'fig\',SaveN];
% print(h(1),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(1),[figName,'.fig']);
% 
% savePath='D:\COVID\result\all_compare\';
% SaveN='cluster_all6_comp2';
% figName = [savePath,'fig\',SaveN];
% print(h(2),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(2),[figName,'.fig']);