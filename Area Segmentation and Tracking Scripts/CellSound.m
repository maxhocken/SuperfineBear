%Do a finer sampling of the data 
xq = 0:10000000;
vq1 = interp1(frames,Veldata,xq);
fs = 96;

%plot(frames,SEDdata,xq,vq1)
sound(vq1)
% for i = 1:100
%    sound(NCMdata,3000)
%    disp(i)
% end

