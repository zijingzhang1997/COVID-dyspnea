function [EpochFeat]=windowFeat_HF(data,fs,opt)
%opt.twin  Window on which Breathing features are estimated
%opt.twinMove Window for  window slide 
%High frequency feature=[psd(1) psd(2) psd(3) psd(4)]
      


twinMove=opt.twinMove;
twin=opt.twin;



StEpochTime=0:twinMove:size(data,1)/fs-twin;  %90s epoch number   
StEpochTime=StEpochTime';

EpochData=zeros(length(StEpochTime),twin*fs,size(data,2));% epoch num * epoch samplePoint * channel

for i=1:length(StEpochTime)
     idx=[1+StEpochTime(i)*fs:(StEpochTime(i)+twin)*fs];
     EpochData(i,:,:)=data(idx,:);
     EpochDataTemp=data(idx,:);
     
     EpochFeat(i,:,:,:)=FeatInEpoch_HF(EpochDataTemp,fs,opt);
     
    
end
end

function featAll=FeatInEpoch_HF(EpochData,fs,opt)


for i=1:size(EpochData,2)
    EpochData_row=EpochData(:,i);
    
    featAll(:,:,i)=spec_Extract_HF(EpochData_row,fs,opt);
    
end  

end

    

function spec_plot=spec_Extract_HF(Data,fs,opt)    
    


Data=normalize(Data);


    %% Find features in each cycle 

% window, overlap window, nfft
[spec_plot,f_spec,t_spec] = spectrogram(detrend(Data), kaiser(fs*opt.STwin), fs*(opt.SToverlap), fs*(opt.STnfft), fs, 'yaxis');

% spectrogram  dim:  frequency * time  

% remove frequency lower part 
% spec_plot(f_spec<opt.Lfreq,:)=[];
% figure()
% pcolor(abs(spec_plot));
% figure()
% pcolor(abs(spec_plot(1:25,:)));
    
end