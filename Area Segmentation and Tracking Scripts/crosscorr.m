function [short, long] = crosscorr(y1,y2)
%crosscorr Performs cross correlation analysis on two data sets
%   Normalizes both sets of data against themselves and then uses xcorr to
%   complete correlation analysis and output any identified peaks. 

%replace nans with 0s?
y1(isnan(y1)) = 0;
y2(isnan(y2)) = 0;

%normalize each data set
y1 = y1 - mean(y1);
y1 = y1./max(y1);
y2 = y2 - mean(y2);
y2 = y2./max(y2);

[r, lags] = xcorr(y1,y2,'coeff');
lags = lags*300;
%disp(lags)
%Normalize r
%r = (r - min(r(:)))./max((r - min(r(:))));
%subtract off slope from each graph
%rspace = linspace(0,1,(numel(r)/2)+1); 
%rspace = [rspace, flip(rspace(1:end-1))].';

%r(201:end) = minus(r(201:end),rspace(201:end));
%r(1:200) = minus(r(1:200),rspace(1:200));

plot(lags,r)
xlabel('Lag')
ylabel('Normalized Cross Correlation')
ylim([-1 1])
end
