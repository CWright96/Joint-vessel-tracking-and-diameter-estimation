%%select starting widths
[FileName,PathName] = uigetfile({'*.tif';'*.ppm';'*.png';'*.tiff';'*.jpg'},'Select image');
input_image = imread([PathName FileName]);

figure(1); imshow(uint8(input_image));
Init_diameters = (ginput(2));  %get user to pick points
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
I = rgb2gray(input_image);                %make RGB image into B&W for intesity calculation
f = @(x) m*x + c;                           %stright line function
    

figure(1); imshow(uint8(input_image))     %display the image


hold on
figure(1);plot(Init_diameters(:,1),Init_diameters(:,2),'ro')
%if the points chosen have a negative difference fplot wont work so they
%are swapped round
if Init_diameters(1)<Init_diameters(2)    
    figure(1);fplot(f,[Init_diameters(1)-1, Init_diameters(2)+1],'y')
elseif Init_diameters(2)<Init_diameters(1)
    figure(1);fplot(f,[Init_diameters(2)-1, Init_diameters(1)+1],'y')
end

c = improfile(I,coords(:,1),coords(:,2)); %array of intensities
drawnow
figure(2);plot(c);  %intensity vs index plot.
title({'Graph of pixel intensities over a line', 'between the two manually selected points'},'fontsize',24)
xlabel('Pixel index','fontsize',24) % x-axis label
ylabel('Intensity values','fontsize',24) % y-axis label

%%length estimation
%for i = 1:9
RangeOfIntensities = range(c);
[MinIntensity,MinIndex] = min(c);
Threshold = RangeOfIntensities * .6;
%find start of vessel
for j=(MinIndex-1):-1:1
    if abs(c(j)- MinIntensity) >= Threshold
        %disp(j);
        StartOfVessel = j;
        break;
    end    
end
%find end of vessel
for k = (MinIndex+1):1:length(c)
       if abs((c(k)- MinIntensity)) >= Threshold
        EndOfVessel = k;
        break;
       end
end

pos1 = [coords(StartOfVessel,1),coords(StartOfVessel,2)];
pos2 = [coords(EndOfVessel,1),coords(EndOfVessel,2)];

DiamterOfVessel = (sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2));
if pos1(1)<pos2(1)    
    figure(1);fplot(f,[pos1(1),pos2(1)],'b')
elseif pos2(1)<pos1(1)
    figure(1);fplot(f,[pos2(1),pos1(1)],'b')
end

%disp(i);
disp(DiamterOfVessel);
%

