close all;
clear all;

local_dir = pwd;
tempFilepath = fullfile(local_dir,'Synthetic Testing Images\temp_line.tif');
%%Straight line 7 pixels wide
figure(1);plot([1,256],[128,128],'k-','linewidth',7);
xlim([1,256]);
axis off;
saveas(figure(1),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [256, 256]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images\Straight_line.tif'));


%%daigonal line 7 pixels wide
%y = x
x = 1:256;
figure(2);plot(x,'k-','linewidth',7);
axis off;
xlim([1,256]);
saveas(figure(2),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [256, 256]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images\Diag_line.tif'));


%%sine wave 5 pixels wide
%y = sinx
Test_image = ones(256,256);
x= (0:.01:2*pi);
y=sin(x)*256;
figure(3);plot(x*81.4873/2,y,'k-','linewidth',5);
axis off;
xlim([1,256]);
saveas(figure(3),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [256, 256]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images\sine_line.tif'));
%circle 7 pixels wide
circle(128,128,100,tempFilepath,local_dir);

%synthetic 'y' shaped bifurcation

figure(5);
hold on
plot([128,128],[20+20,100+20],'k-','linewidth',7)
plot([128,150],[100+20,160+20],'k-','linewidth',7)
plot([128,106],[100+20,160+20],'k-','linewidth',7)
xlim([1,256]);
ylim([1,256]);
axis off
saveas(figure(5),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [256, 256]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images\bifur_line.tif'));

function circle(x,y,r,fp,ld)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
% fp is the tempFilepath directory
%ld is the local directory for the programme
%0.000001 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.000001:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
figure(4);plot(x+xp,y+yp,'k-','linewidth',7);
axis off;
xlim([1,256]);
ylim([1,256]);
saveas(figure(4),fp);
%figure;imshow(Test_image);
Test_image = imread(fp);
Test_image = imresize(Test_image, [256, 256]);
imwrite(Test_image,fullfile(ld,'Synthetic Testing Images\circle.tif'));
end
