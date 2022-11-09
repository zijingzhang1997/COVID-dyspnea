function [h]=spec_plotEpoch(EpochData_all,num,opt,fs,opt_seg,StEpochTime,chName,optIdx,flag_ncs,flag_acc)
 
EpochData=reshape(EpochData_all(num,:,:),size(EpochData_all,2),size(EpochData_all,3));
EpochData=detrend(EpochData);
EpochData=normalize(EpochData,1);

St=StEpochTime(num);





h(1)=figure;

sz=9;

t=(1:length(EpochData))/fs;
cN={'green','red','red','red','blue','blue','blue'};

subplot(1,2,1);
Data=EpochData(:,1);
spectrogram(detrend(Data), kaiser(fs*opt.STwin), fs*(opt.SToverlap), fs*(opt.STnfft), fs, 'yaxis');
title('NCS','FontSize',sz)

subplot(1,2,2);
Data=EpochData(:,optIdx(num,1));
spectrogram(detrend(Data), kaiser(fs*opt.STwin), fs*(opt.SToverlap), fs*(opt.STnfft), fs, 'yaxis');
title(chName{optIdx(num)},'FontSize',sz)



txt_flag=['NCS sel:',num2str(flag_ncs(num)),' ACC sel:',num2str(flag_acc(num))];
txt=['subj:', opt_seg.subjName,' seg:',opt_seg.segName,' side:',opt_seg.side,' Start T(min):',St/60];
tle=txt;
sgtitle([join(txt_flag) join(txt)],'fontsize', sz);
set(gcf,'Position',[100,10,900,700]);
set(gca,'fontsize', sz);





end