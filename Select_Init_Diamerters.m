function[Initial_Diameter] = Select_Init_Diamerters(input_image)

retinal_image = imread(input_image);
figure(1); imshow(uint8(retinal_image))
Init_diameters = (ginput(2));

x1 = Init_diameters(1,1);           %get coordinates for the line
x2 = Init_diameters(2,1);
y1 = Init_diameters(1,2);
y2 = Init_diameters(2,2);
coeffs = polyfit([x1,x2],[y1,y2],1);    %cooficients for plotting straight line
m=coeffs(1);
c=coeffs(2);
Length = (sqrt((x2-x1)^2+(y2-y1)^2));  %length of line between the 2 points
xs = linspace(x1, x2, Length+2);            %x coords of said line
ys = linspace(y1, y2, Length+2);            %y coords of said line
coords = [xs(:),ys(:)];                     %join then into one array
I = rgb2gray(retinal_image);                %make RGB image into B&W for intesity calculation
f = @(x) m*x + c;                           %stright line function
    
figure(1); imshow(uint8(retinal_image))     %display the image


hold on
figure(1);plot(Init_diameters(:,1),Init_diameters(:,2),'ro')
%if the points chosen have a negative difference fplot wont work so they
%are swapped round
if Init_diameters(1)<Init_diameters(2)    
    figure(1);fplot(f,[Init_diameters(1)-1, Init_diameters(2)+1],'y')
elseif Init_diameters(2)<Init_diameters(1)
    figure(1);fplot(f,[Init_diameters(2)-1, Init_diameters(1)+1],'y')
end




