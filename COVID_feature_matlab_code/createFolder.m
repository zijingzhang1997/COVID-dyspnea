SavePath='D:\COVID\COVID_HF_spectrum\result\';
FolderName='Feat_NCS_healthy';  % since we haven't usde PSG 
%FolderName='Feat_pred_v4';
FolderName='Feat_NCS';
creatFolder1=[SavePath,'\',FolderName];

Ver='v1';
creatFolder2=[SavePath,'\',FolderName,'\','featureAll'];

creatFolder3=[SavePath,'\',FolderName,'\','per_feat\',Ver,'\fig_seg\tiff'];
creatFolder4=[SavePath,'\',FolderName,'\','per_feat\',Ver,'\fig_seg\fig'];
creatFolder5=[SavePath,'\',FolderName,'\','fig'];
% creatFolder6=[SavePath,'\',FolderName,'\','per_mat','\','v1'];
% creatFolder7=[SavePath,'\',FolderName,'\','per_mat','\','v2'];


status = mkdir(creatFolder1);
status = mkdir(creatFolder2);
status = mkdir(creatFolder3);
status = mkdir(creatFolder4);
status = mkdir(creatFolder5);


for subj=3:14
subjName=[num2str(subj,'%02d')];
creatFolder3=[SavePath,'\',FolderName,'\','per_feat\',Ver,'\fig_seg\tiff\',subjName];
creatFolder4=[SavePath,'\',FolderName,'\','per_feat\',Ver,'\fig_seg\fig\',subjName];
status = mkdir(creatFolder3);
status = mkdir(creatFolder4);
end
