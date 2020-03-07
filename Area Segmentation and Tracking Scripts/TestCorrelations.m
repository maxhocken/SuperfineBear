%test correlations code which shows an approach to do fourier analysis on
%acquired data sets. Outdated but again might be useful. 
%-- Max Hockenberry 2020
frames = 5 * Fouriertest.VarName1;
[rho, pval] = corr(Fouriertest.VarName2, NCMtest.VarName1);

%Create somerandom points to compare

randomnums = rand(numel(frames),1);

[rho2, pval2] = corr(NCMtest.VarName1, randomnums);

[rho3, pval3] = corr(Fouriertest.VarName2, randomnums);


%Do some Fourier Transforms to take a look at frequencies.
Fs = 1/300;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = numel(frames);             % Length of signal
t = (0:L-1)*T;        % Time vector

figure
transform1 = fft(Fouriertest.VarName2);

%Compute two sided spectrum and return single sided spectrum for analysis
P2 = abs(transform1/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%Define frequency spacing and plot p1

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


