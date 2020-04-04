function [long,short] = crossCorrelate(xvals,yvals)
%autoCorrelate Computes autocorrelation of provided x and y vals. 
%   Outputs highest frequency of cross correlation obtained from analysis
%   which corresponds to period of function assuming only one. 
%   Adapted from : https://www.mathworks.com/help/signal/ug/find-periodicity-using-autocorrelation.html
yvalsnorm = yvals - mean(yvals);
xvalsnorm = xvals - mean(xvals);
%divide by the variance to normalize
yvalsnorm = yvalsnorm/var(yvalsnorm);
xvalsnorm = xvalsnorm/var(xvalsnorm);

%nan filter
xvalsnorm(isnan(xvalsnorm)) = 0;
yvalsnorm(isnan(yvalsnorm)) = 0;
%smooth data, makes analysis simpler. Risk of eliminating small scale
%fluctations however on the time scale of measurement it is not appropriate
%to consider these minute length fluctuations; AKA Nyquist frequency. 
yvalsnorm = smoothdata(yvalsnorm);
xvalsnorm = smoothdata(xvalsnorm);

[cor,lags] = xcorr(yvalsnorm,xvalsnorm,'coeff');
[pksh, lcsh] = findpeaks(cor, 'MinPeakheight',0.1);
short = mean(diff(lcsh));
figure
plot(lags,cor)
hold on
if isnan(short)
   short = 0; 
end
[pklg,lclg] = findpeaks(cor, ...
    'MinPeakDistance',(ceil(short)),'MinPeakheight',0.25);
long = mean(diff(lclg));


%plot(lags(lclg)/fs,pklg+0.05,'vk');
pks = plot(lags(lcsh),pksh,'or', ...
    lags(lclg),pklg+0.05,'vk');
xlabel('Lag (Frames)')
ylabel('Normalized Correlation Coefficient')
legend(pks,[repmat('Period: ',[2 1]) num2str([short;long],0)])
ylim([-1,1])
title(strcat(inputname(1),' vs.  ',' ', inputname(2),' Cross Correlation'))
hold off



end

