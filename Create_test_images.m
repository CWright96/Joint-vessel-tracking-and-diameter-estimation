%close all;
clear all;

local_dir = pwd;
tempFilepath = fullfile(local_dir,'Synthetic Testing Images1\temp_line.tif');
%%Straight line 7 pixels wide
figure(1);plot([1,256],[128,128],'k-','linewidth',7);
xlim([1,256]);
axis off;
saveas(figure(1),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\Straight_line7.tif'));
%%straight line 3 pixels wide
%y=const
figure(6);plot([1,256],[128,128],'k-','linewidth',3);
xlim([1,256]);
axis off;
saveas(figure(6),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\Straight_line3.tif'));

%%daigonal line 7 pixels wide
%y = x
x = 1:256;
figure(2);plot(x,'k-','linewidth',7);
axis off;
xlim([1,256]);
saveas(figure(2),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\Diag_line7.tif'));

%%daigonal line 5 pixels wide
%y = x
x = 1:256;
figure(7);plot(x,'k-','linewidth',5);
axis off;
xlim([1,256]);
saveas(figure(7),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\Diag_line5.tif'));


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
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\sine_line.tif'));
%circle 7 pixels wide
circle(128,128,100,tempFilepath,local_dir);

%%sine wave 3 pixels wide
%y = sinx
Test_image = ones(256,256);
x= (0:.01:2*pi);
y=sin(x)*256;
figure(8);plot(x*81.4873/2,y,'k-','linewidth',3);
axis off;
xlim([1,256]);
saveas(figure(8),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\sine_line3.tif'));
%circles 7 and 5 pixels wide
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
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\bifur_line.tif'));

figure(10);
hold on
plot([128,128],[20+20,100+20],'k-','linewidth',3)
plot([128,150],[100+20,160+20],'k-','linewidth',3)
plot([128,106],[100+20,160+20],'k-','linewidth',3)
xlim([1,256]);
ylim([1,256]);
axis off
saveas(figure(10),tempFilepath);
%figure;imshow(Test_image);
Test_image = imread(tempFilepath);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(local_dir,'Synthetic Testing Images1\bifur_line3.tif'));
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
ylim([1,256])
figure(9);plot(x+xp,y+yp,'k-','linewidth',5);
axis off;
xlim([1,256]);
ylim([1,256]);
saveas(figure(4),fp);
%figure;imshow(Test_image);
Test_image = imread(fp);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(ld,'Synthetic Testing Images1\circle7.tif'));
saveas(figure(9),fp);
Test_image = imread(fp);
Test_image = imresize(Test_image, [565, 584]);
imwrite(Test_image,fullfile(ld,'Synthetic Testing Images1\circle5.tif'));
end
