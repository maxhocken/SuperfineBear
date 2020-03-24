function [] = makeVerticalFrameLine(frames, outputfolder)
%makeVerticalFrameLine Draws vertical line for each frame of current fig
%   Given frame number n and an output folder, will make a new directory
%   and place n images containing a moving animation line to correspond
%   with the current frame of the cell movie with the provided current
%   figure. 

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

end

