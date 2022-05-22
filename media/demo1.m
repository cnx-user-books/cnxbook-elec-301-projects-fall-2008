% Simulate a linear mixing matrix for two already separated signal sources
% Basically perform y = Hx, then use fastICA to find unmixing matrix so
% that y = W*H*x = x (approximately)

clc
close all
clear all

% read the two files
a = wavread('demo1_sr1.wav'); % siren component
b = wavread('demo1_sr2.wav'); % voice component

x = [a';b']; % separated signal matrix

% H is some arbitrary mixing matrix
H = [1.0 0.5;0.2 0.8];

y = H*x; % mixed signal matrix

% perform fastICA to demonstrate success of separation
% fastICA takes in the mixed signal matrix y and
% returns the original signals f that is estimation of x
% A is estimated mixing matrix and W is estimated unmixing matrix
% v is a prewhitened version of y that normalizes the frequency spectrum

[f,A,W,v] = fastica(y,'g','gauss','verbose','off');

W*H % display to show how undoing mixing matrix H 
    % will create a nearly diagonal matrix

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

% Normalize y to [-1,1] to avoid clipping in mixed output file. 
% Do only one of the two mixed signals.

g = y(1,:)/max(abs(y(1,:)));
wavwrite(g,8000,'demo1_mix.wav');





