function [h]=HF_plotEpoch(waveformData_all,num,opt,fs,opt_seg,StEpochTime,chName,featShow,featN,flag_ncs,flag_acc)
 % don not feature extraction 
 % inpout is waveform directly 
 % not normalize
 
twin=opt.twin;
idx=[1+StEpochTime(num)*fs:(StEpochTime(num)+twin)*fs];
EpochData(:,:)=waveformData_all(idx,:); 
EpochData=detrend(EpochData);


St=StEpochTime(num);





h(1)=figure;
nfig=size(EpochData,2);
sz=9;

t=(1:length(EpochData))/fs;
cN={'green','red','red','red','blue','blue','blue'};
for i=1:nfig
    subplot(nfig,1,i);
    plot(t,EpochData(:,i),'LineWidth',0.5,'color',cN{i});
  

    xlabel('time (s)','FontSize',sz)
    ylabel(chName{i},'FontSize',sz)
    
    
   

end

txt_flag=['NCS sel:',num2str(flag_ncs(num)),' ACC sel:',num2str(flag_acc(num))];
txt=['subj:', opt_seg.subjName,' seg:',opt_seg.segName,' side:',opt_seg.side,' Start T(min):',St/60];
tle=txt;
sgtitle([join(txt_flag) join(txt)],'fontsize', sz);
set(gcf,'Position',[100,10,800,900]);
set(gca,'fontsize', sz);





end