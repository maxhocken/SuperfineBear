function [long,short] = autoCorrelatev1(xvals,yvals)
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

if isnan(short)
   short = 0; 
end
[pklg,lclg] = findpeaks(autocor, ...
    'MinPeakDistance',(ceil(short)*fs),'MinPeakheight',0.2);
long = mean(diff(lclg))/fs;
end

