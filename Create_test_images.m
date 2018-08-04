%%Straight line 7 pixels wide
Test_image = ones(256,256);
for i = 125:1:131	
    Test_image(i,:) = 0;
end

figure;imshow(Test_image);
imwrite(Test_image,'C:\Users\chris\Documents\GitHub\Joint-vessel-tracking-and-diameter-estimation\Synthetic Testing Images\Straight_line.tif');


%%daigonal line 7 pixels wide
%y = mx+c
m = 1;
c = 256;
Test_image = ones(256,256);
for x = 1:1:256
    Test_image((m*x),x) = 0;    
end
for x = 1:1:255
    Test_image((m*x),x+1) = 0;    
end
for x = 1:1:255
    Test_image((m*x)+1,x) = 0;    
end
for x = 1:1:254
    Test_image((m*x)+2,x) = 0;    
end
for x = 1:1:254
    Test_image((m*x),x+2) = 0;    
end
for x = 1:1:253
    Test_image((m*x),x+3) = 0;    
end
for x = 1:1:253
    Test_image((m*x)+3,x) = 0;    
end
figure;imshow(Test_image);
imwrite(Test_image,'C:\Users\chris\Documents\GitHub\Joint-vessel-tracking-and-diameter-estimation\Synthetic Testing Images\Diag_line.tif');

%%sine wave 5 pixels wide
%y = sinx
Test_image = ones(256,256);
x= (0:.01:2*pi);
y=sin(x)*256;
plot(x*81.4873/2,y,'k-');
figure;imshow(Test_image);
imwrite(Test_image,'C:\Users\chris\Documents\GitHub\Joint-vessel-tracking-and-diameter-estimation\Synthetic Testing Images\sine1_line.tif');



