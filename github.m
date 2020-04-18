%%  
tic
load('raw_training_data.mat')
load('leaderboard_data.mat')
in=.7*length(train_dg{1});
 traindg1=train_dg{1}(1:in,:)';
 traindg2=train_dg{2}(1:in,:)';
 traindg3=train_dg{3}(1:in,:)';
 trainecog1=train_ecog{1}(1:in,:)';
 trainecog2=train_ecog{2}(1:in,:)';
 trainecog3=train_ecog{3}(1:in,:)';
 testecog1=train_ecog{1}(in+1:end,:)';
 testecog2=train_ecog{2}(in+1:end,:)';
 testecog3=train_ecog{3}(in+1:end,:)';
 testdg1=train_dg{1}(in+1:end,:)';
 testdg2=train_dg{2}(in+1:end,:)';
 testdg3=train_dg{3}(in+1:end,:)';
 Fs = 1000;  % Sampling Frequency
% Fstop1 = .1;             % First Stopband Frequency
% Fpass1 = .2;             % First Passband Frequency
% Fpass2 = 5;               % Second Passband Frequency
% Fstop2 = 7;              % Second Stopband Frequency
% Dstop1 = 0.31622776602;   % First Stopband Attenuation
% Dpass  = 0.057501127785;  % Passband Ripple
% Dstop2 = 0.31622776602;   % Second Stopband Attenuation
% dens   = 20;              % Density Factor
% [N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
%                           0], [Dstop1 Dpass Dstop2]);
% b  = firpm(N, Fo, Ao, W, {dens});
% Hd = dfilt.dffir(b);

Hd=designfilt('bandpassiir','StopbandFrequency1',.05,'PassbandFrequency1',.15,'PassbandFrequency2',190,'StopbandFrequency2',200,'SampleRate',1000);
features1=getWindowedFeats(trainecog1,Fs,100,50,Hd);
features1n=getWindowedFeats(testecog1,Fs,100,50,Hd);
features2=getWindowedFeats(trainecog2,Fs,100,50,Hd);
features3=getWindowedFeats(trainecog3,Fs,100,50,Hd);
features2n=getWindowedFeats(testecog2,Fs,100,50,Hd);
features3n=getWindowedFeats(testecog3,Fs,100,50,Hd);
R1=create_R_matrix(features1,3,6);
R2=create_R_matrix(features2,3,6);
R3=create_R_matrix(features3,3,6);
Y1=NaN(5,length(features1)+1);
Y2=NaN(5,length(features1)+1);
Y3=NaN(5,length(features1)+1);
for i=1:5
Y1(i,:)=decimate(traindg1(i,:)',50);
Y2(i,:)=decimate(traindg2(i,:)',50);
Y3(i,:)=decimate(traindg3(i,:)',50);
end

Y3(:,1)=[];
Y1(:,1)=[];
Y2(:,1)=[];
f1=mldivide(R1.'*R1,R1.'*Y1');
f2=mldivide(R2.'*R2,R2.'*Y2');
f3=mldivide(R3.'*R3,R3.'*Y3');

R1=create_R_matrix(features1n,3,6);
R2=create_R_matrix(features2n,3,6);
R3=create_R_matrix(features3n,3,6);

Yn1=R1*f1;
Yn2=R2*f2;
Yn3=R3*f3;
windowSize =21; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Yn11 = filter(b,a,Yn1);
Yn22 = filter(b,a,Yn2);
Yn33 = filter(b,a,Yn3);
Yfull1=NaN(5,90000);
Yfull2=NaN(5,90000);
Yfull3=NaN(5,90000);
for i=1:5
    Yfull1(i,:)=spline(linspace(1,90000,length(features1n)),Yn11(:,i),1:1:90000);
    Yfull2(i,:)=spline(linspace(1,90000,length(features2n)),Yn22(:,i),1:1:90000);
    Yfull3(i,:)=spline(linspace(1,90000,length(features3n)),Yn33(:,i),1:1:90000);
end
for i=1:5
    m1=mean(Yfull1(i,:));
    log1=Yfull1(i,:)<m1;
    Yfull1(i,log1)=m1;
    m2=mean(Yfull2(i,:));
    log2=Yfull2(i,:)<m2;
    Yfull2(i,log2)=m2;
    m3=mean(Yfull3(i,:));
    log3=Yfull3(i,:)<m3;
    Yfull3(i,log3)=m3;
end
F1_1=corr(testdg1(1,:)',Yfull1(1,:)');
F1_2=corr(testdg1(2,:)',Yfull1(2,:)');
F1_3=corr(testdg1(3,:)',Yfull1(3,:)');
F1_4=corr(testdg1(4,:)',Yfull1(4,:)');
F1_5=corr(testdg1(5,:)',Yfull1(5,:)');

F2_1=corr(testdg2(1,:)',Yfull2(1,:)');
F2_2=corr(testdg2(2,:)',Yfull2(2,:)');
F2_3=corr(testdg2(3,:)',Yfull2(3,:)');
F2_4=corr(testdg2(4,:)',Yfull2(4,:)');

F2_5=corr(testdg2(5,:)',Yfull2(5,:)');

F3_1=corr(testdg3(1,:)',Yfull3(1,:)');
F3_2=corr(testdg3(2,:)',Yfull3(2,:)');
F3_3=corr(testdg3(3,:)',Yfull3(3,:)');
F3_4=corr(testdg3(4,:)',Yfull3(4,:)');
F3_5=corr(testdg3(5,:)',Yfull3(5,:)');

P1_linear=[F1_1,F1_2,F1_3,F1_5];
P2_linear=[F2_1,F2_2,F2_3,F2_5];
P3_linear=[F3_1,F3_2,F3_3,F3_5];
co1=mean(P1_linear);
co2=mean(P2_linear);
co3=mean(P3_linear);
totco=mean([co1,co2,co3])
toc