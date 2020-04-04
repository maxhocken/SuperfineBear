function [lags,ck,cc,td] = xcorrTD(x,y)
%
%   TIME-DOMAIN CROSS-CORRELATION FUNCTION
%
%   Description: xcorrTD takes two discrete time signals as input and
%   calculates cross-correlation values, cross-correlation correlation
%   coefficients and delay between two signals. The computation is
%   performed in the time domain. The results of xcorrTD is validated
%   against the MatLAB's xcorr function.
%
%   For cross-correlation in frequency domain see xcorrFD. 
%
%   Syntax:    
%         [lags,ck,cc,td] = xcorrTD(x,y)
%
%   Input: 
%         x = input signal 1 (must be a Nx1 or 1xN vector)
%
%         y = input signal 2 (must be a Nx1 or 1xN vector)
%
%   Output: 
%
%         lags = a vector of lags with a length of 2xN-1 (N = number of
%         data points in signal x or y)
%
%           ck = cross-correlation values (MatLAB xcorr gives them as
%           output)
%
%           cc = correlation coefficients
%
%           td = delay (i.e., number of lags) between two signals  
%
%   Reference: Gubbins, D. (2004). Time Series Analysis and Inverse Theory
%   for Geophysicists, Cambridge University Press, 255 p.
%
%   Example: Input acceleration signals are base and roof motions from a
%   building during earthquake shaking. Let us compute the delay between
%   two signals, which can be used to compute average shear-wave velocity
%   in the building.
%
%       data = importdata('input.txt');
%       x = data(:,2); y = data(:,3);
%       [lag,ck,cc,td] = xcorrTD(x,y);
%       plot(lag,ck,'r'); grid on; 
%       xlabel('Lag'); ylabel('Cross correlation values');
%       title('Cross-correlation in time domain by xcorrTD');
%       print('-dpng','-painters','-r600','xcorrTD.png')
%
%   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
%   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
%   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
%   NO EVENT SHALL THE COPYRIGHT OWNER BE LIABLE FOR ANY DIRECT, INDIRECT,
%   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
%   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
%   OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
%   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
%   TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
%   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
%   DAMAGE.
%
%   Written by Dr. Erol Kalkan, P.E. (ekalkan@usgs.gov)
%   $Revision: 1.0 $  $Date: 2017/06/14 14:03:00 $
ndata = length(x);
sx = sum(x.^2); sy = sum(y.^2);

maxlag = ndata-1;
cnt = 0;
for lag = -maxlag:maxlag
    cnt = cnt + 1;
    sxy = 0;
    for i=1:ndata
        j = i + lag;
        if j>0 && j<=ndata
            sxy = sxy + x(i) * y(j);
        end
    end
    cc(cnt) = sxy / sqrt(sx*sy);  % correlation coefficient 
    ck(cnt) = sxy;                % cross-correlation value 
    lags(cnt) = lag;
end
[~,i] = max(cc);
td = i - ndata;