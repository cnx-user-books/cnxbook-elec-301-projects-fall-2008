load t.mat; load x.mat;


% Inout: signal must be a N by 2 matrix, first column is time index, second
% column is ECG signal.
% 
% Output: heart_rate is the average heart rate of the inout signal, TI_flg
% inidicate the detection of T_wave inversion.
[heart_rate, TI_flg] = ECGSigProcFB([t, x]);

