%Script to save a movie with a line at certain frames

for i = 1:numel(frames)
   %make line in plot
  disp(i)
  hold on 
  y = ylim;
  h1 = plot([frames(i), frames(i)],[y(1), y(2)],'b');
  
  
  saveas(gcf,strcat('C:\Users\Max\Desktop\Image Folder','\',num2str(i),'.png'))
  delete(h1)
  hold off
end