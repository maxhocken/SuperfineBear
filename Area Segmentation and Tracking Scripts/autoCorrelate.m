function [long,short] = autoCorrelate(xvals,yvals)
%autoCorrelate Computes autocorrelation of provided x and y vals. 
%   Outputs highest frequency of autocorrelation obtained from analysis
%   which corresponds to period of function assuming only one. We can
%   assume xvals will be given in seconds
%   Adapted from : https://www.mathworks.com/help/signal/ug/find-periodicity-using-autocorrelation.html
yvalsnorm = yvals - mean(yvals);

%divide by the variance to normalize
yvalsnorm = yvalsnorm/var(yvalsnorm);


%fs should come from xvals and be 1/spacing of interval
%smooth data, makes analysis simpler. Risk of eliminating small scale
%fluctations however on the time scale of measurement it is not appropriate
%to consider these minute length fluctuations; AKA Nyquist frequency. 
yvalsnorm = smoothdata(yvalsnorm);
fs = 1/(xvals(2) - xvals(1));

[autocor,lags] = xcorr(yvalsnorm,round(xvals(end)*fs),'coeff');
[pksh, lcsh] = findpeaks(autocor);
short = mean(diff(lcsh))/fs;
subplot(2,1,1)
plot(lags/fs,autocor)
hold on
[pklg,lclg] = findpeaks(autocor, ...
    'MinPeakDistance',ceil(short)*fs,'MinPeakheight',0.2);
long = mean(diff(lclg))/fs;


%plot(lags(lclg)/fs,pklg+0.05,'vk');
pks = plot(lags(lcsh)/fs,pksh,'or', ...
    lags(lclg)/fs,pklg+0.05,'vk');
xlabel('Lag (Seconds)')
ylabel('Autocorrelation')
legend(pks,[repmat('Period: ',[2 1]) num2str([short/3600;long/3600],0)])
hold off
subplot(2,1,2)
plot(xvals,yvalsnorm)
xlabel('Time (Seconds)')
ylabel('Magnitude')


end

