xvals = 0:100;

yvals = sin(xvals);
offset = 5;
yvalsshift = offset * cos(xvals + offset);
plot(xvals,yvals,xvals,yvalsshift)
%nan filter
crossCorrelate(yvals,yvalsshift)


% strainEnergiesDensities(isnan(strainEnergiesDensities)) = 0;
% yvalsnorm = strainEnergiesDensities - mean(strainEnergiesDensities);
% yvalsnorm = yvalsnorm/var(strainEnergiesDensities);
% 
% fs = 1/300;
% 
% maxlag = length(strainEnergiesDensities);
% [r, lags] = xcorr(strainEnergiesDensities,maxlag,'coeff');
% 
% plot(lags*300,r)
% hold on
% line([offset, offset],[-1, 1])