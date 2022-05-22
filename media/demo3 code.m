% Load two recordings of one signal source recorded in room to demonstrate
% effectiveness of fastICA and strical at removing noise.

% Signal in this demonstration has a 440Hz tone.

clc
close all
clear all

% read the two files
a = wavread('demo3_mix1.wav'); % mixed signal 1
b = wavread('demo3_mix2.wav'); % mixed signal 2

% truncate both signals to equal lengths
if(length(a)>length(b))
    a = a(1:length(b),1);
else
    b = b(1:length(a),1);
end

y = [a';b']; % mixed signal matrix

% perform fastICA to demonstrate failure of noise removal
% fastICA takes in the mixed signal matrix y and
% returns the original signals f that is estimation of x
% A is estimated mixing matrix and W is estimated unmixing matrix
% v is a prewhitened version of y that normalizes the frequency spectrum

[f,A,W,v] = fastica(y,'g','gauss','verbose','off');

% perform stfical to demonstrate better success of noise removal
% stfical does not prewhiten the signal beforehand so this must be done
[E, D]=pcamat(y,1,2,'off','off');
[whitesig, whiteningMatrix, dewhiteningMatrix] = whitenv(y,E,D,'off');
[s, W] = stfical(whitesig,1,1);
f2 = dewhiteningMatrix*W*s;

subplot(321)
specgram(v(1,:));
title('Mixed Signal 1','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(322)
specgram(v(2,:));
title('Mixed Signal 2','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(323)
specgram(f(1,:));
title('fastICA Component 1','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(324)
specgram(f(2,:));
title('fastICA Component 2','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(325)
specgram(f2(1,:));
title('STFICAL Component 1','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(326)
specgram(f2(2,:));
title('STFICAL Component 2','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');


% Normalize f to [-1,1] to avoid clipping in source output files. 

g = f(1,:)/max(abs(f(1,:)));
wavwrite(g,44100,'demo3_srICA1.wav');
g = f(2,:)/max(abs(f(2,:)));
wavwrite(g,44100,'demo3_srICA2.wav');
g = f2(1,:)/max(abs(f2(1,:)));
wavwrite(g,44100,'demo3_srSTFICA1.wav');
g = f2(2,:)/max(abs(f2(2,:)));
wavwrite(g,44100,'demo3_srSTFICA2.wav');

