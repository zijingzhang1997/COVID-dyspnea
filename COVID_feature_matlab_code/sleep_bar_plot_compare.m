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

% load data 
close all
foldVer='Feat_NCS';
loadVer='v1_newTh1';
loadPath_COVIDAll=['D:\COVID\result\',foldVer,'\featureAll\',loadVer,'\all_p_Feat.mat'];
load(loadPath_COVIDAll);
feat_acc_covid=EpochFeat_sel_acc_all_p(:,:,1);
feat_ncs_covid=EpochFeat_sel_ncs_all_p;


foldVer='Feat_NCS_healthy';
loadPath_healthAll=['D:\COVID\result\',foldVer,'\featureAll\','v1','\01_allFeat.mat'];
load(loadPath_healthAll);
feat_acc_health=EpochFeat_sel_acc(:,:,1);
feat_ncs_health=EpochFeat_sel_ncs;

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



%% cluster scatter plts
feat{1}=feat_acc_covid(:,1:51);
feat{2}=feat_acc_health(:,1:51);
feat{3}=feat_ncs_dyspnea_R1;
feat{4}=feat_ncs_dyspnea_R3;
for i=1:length(feat)
    feat_t=feat{i};
    feat_mean(i,:)=[mean(feat_t,1)];
    feat_std(i,:)=[std(feat_t,1)];
end

featnum_multi(:,1)=linspace(1,13,7);featnum_multi(:,2)=linspace(2,14,7);
featnumCOV=[15,16,17,18,19];
featnumCor=linspace(20,32,7);
featnumSD=linspace(21,33,7);



sz=13;
%% plot all figures 
h(1)=figure()
for j=1:size(featnum_multi,1)
subplot(1,size(featnum_multi,1),j)
featnum_sel=featnum_multi(j,:);
model_series = feat_mean(:,featnum_sel)'; 
model_error = feat_std(:,featnum_sel)'; 
b = bar(model_series, 'grouped');
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,model_error,'k','linestyle','none');
if j==6
 ylim([-0.2 2])
end
hold off
%legend('COVID all acc','healthy JZ','dyspnea Normal','dyspnea Exercise','FontSize',sz)
xticklabels(FeatureName(featnum_sel));
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');

end
legend('COVID all acc','healthy JZ','dyspnea Normal','dyspnea Exercise','FontSize',sz)
set(gcf,'Position',[200,100,1800,300]);
%%
h(2)=figure()
featnum_sel=featnumCOV;
model_series = feat_mean(:,featnum_sel)'; 
model_error = feat_std(:,featnum_sel)'; 
b = bar(model_series, 'grouped');
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
legend('COVID all acc','healthy JZ','dyspnea Normal','dyspnea Exercise','FontSize',sz)
ylim([0 0.6])
xticklabels(FeatureName(featnum_sel));
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[200,500,800,300]);


h(3)=figure()
featnum_sel=featnumCor;
model_series = feat_mean(:,featnum_sel)'; 
model_error = feat_std(:,featnum_sel)'; 
b = bar(model_series, 'grouped');
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
legend('COVID all acc','healthy JZ','dyspnea Normal','dyspnea Exercise','FontSize',sz)
ylim([0.7 1])
xticklabels(FeatureName(featnum_sel));
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[200,500,800,300]);

h(4)=figure()
featnum_sel=featnumSD;
model_series = feat_mean(:,featnum_sel)'; 
model_error = feat_std(:,featnum_sel)'; 
b = bar(model_series, 'grouped');
hold on
[ngroups,nbars] = size(model_series);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
errorbar(x',model_series,model_error,'k','linestyle','none');
hold off
legend('COVID all acc','healthy JZ','dyspnea Normal','dyspnea Exercise','FontSize',sz)
ylim([0 0.6])
xticklabels(FeatureName(featnum_sel));
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[200,500,800,300]);
%%
savePath='D:\COVID\result\all_compare\';
SaveN='error_bar_all_comp_std_mean';
figName = [savePath,'fig\',SaveN];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);

SaveN='error_bar_all_comp_cov';
figName = [savePath,'fig\',SaveN];
print(h(2),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(2),[figName,'.fig']);

SaveN='error_bar_all_comp_cor';
figName = [savePath,'fig\',SaveN];
print(h(3),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(3),[figName,'.fig']);


SaveN='error_bar_all_comp_sd';
figName = [savePath,'fig\',SaveN];
print(h(4),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(4),[figName,'.fig']);