% amp=10; 
% fs=44100;  % sampling frequency
% duration=5;
% freq=100;
% values=0:1/fs:duration;
% a=amp*cellVel; %sin(2*pi* freq*values);
% plot(a)
% sound(a,fs)

%Do a finer sampling of the data 

%Increase amplitude of input
amp = 100;

input = strainEnergiesDensities;
plot(input)
t = linspace(1,numel(input),200);
interptime = linspace(1,200,50000);
interpx = interp1(t,input,interptime);
soundsc(interpx)
% vq1 = interp1(frames,Veldata,xq);
% fs = 96;
% 
% %plot(frames,SEDdata,xq,vq1)
% sound(vq1)
% for i = 1:100
%    sound(NCMdata,3000)
%    disp(i)
% end

