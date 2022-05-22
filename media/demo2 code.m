% Load two recordings of two signal sources mixed in air to demonstrate
% effectiveness of fastICA.

% Signals in this demonstration have voice and a 440Hz tone.

clc
close all
clear all

% read the two files
a = wavread('demo2_mix1.wav'); % mixed signal 1
b = wavread('demo2_mix2.wav'); % mixed signal 2

% truncate both signals to equal lengths
if(length(a)>length(b))
    a = a(1:length(b),1);
else
    b = b(1:length(a),1);
end

y = [a';b']; % mixed signal matrix

% perform fastICA to demonstrate relative success of separation
% fastICA takes in the mixed signal matrix y and
% returns the original signals f that is estimation of x
% A is estimated mixing matrix and W is estimated unmixing matrix
% v is a prewhitened version of y that normalizes the frequency spectrum

[f,A,W,v] = fastica(y,'g','gauss','verbose','off');

subplot(221)
specgram(v(1,:));
title('Mixed Signal 1','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(222)
specgram(v(2,:));
title('Mixed Signal 2','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(223)
specgram(f(1,:));
title('Independent Component 1','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');
subplot(224)
specgram(f(2,:));
title('Independent Component 2','FontSize',20,'FontWeight','bold');
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Normalized Frequency','FontSize',16,'FontWeight','bold');


% Normalize f to [-1,1] to avoid clipping in source output files. 

g = f(1,:)/max(abs(f(1,:)));
wavwrite(g,44100,'demo2_sr1.wav');
g = f(2,:)/max(abs(f(2,:)));
wavwrite(g,44100,'demo2_sr2.wav');


