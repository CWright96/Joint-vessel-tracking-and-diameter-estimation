%%Diameter Estimation


function [output] = Diameter_Estimation(accurate_centerline, input_image)
%load('acc_cent.mat');
%load('input_image.mat');
disp(accurate_centerline);

diameters1 = zeros(1,2);
diameters2 = zeros(1,2);
diameterslength = zeros(1);


%input_image = rgb2gray(input_image);
imshow(uint8(input_image));


for i = 1:length(accurate_centerline)-1
    disp(i);
    %disp(accurate_centerline(i,:));
    pos1 = accurate_centerline(i,:);
    x1 = pos1(1);
    y1 = pos1(2);
    %disp(accurate_centerline(i+1,:));
    pos2 = accurate_centerline(i+1,:);
    x2 = pos2(1);
    y2 = pos2(2);
    coeffs = polyfit([x1,x2],[y1,y2],1); %coefficents of straight line from consecutive accurate centreline points
    m=coeffs(1);    %gradient of concecutive accurate centreline points
    %c=coeffs(2);   %not required
    
    %horizontal line issues plz fix tomrrow xoxo
    
    if m <=1e-8
        m = 0;
        xsToFill = ones([8,1]);
        xs = (xsToFill)*x1;
    else
        Grad_normal = -1/m;     %gradient of normal line
        
        xsToFill = 0:.5:4; %arbituary values used to find the x and y coordinates of a the normal line
        xsToFill = xsToFill *.75; %reduce the length of the normal
        xs = (xsToFill)+x1;      %x coordinates of the normal
        ys = (Grad_normal*(xs-x1)) + y1;   %y coordinates of the normal
        xs_opp = (-1*xsToFill)+x1;  %descending x values
        ys_opp = (Grad_normal*(xs_opp-x1)) + y1;    %descending y values
        coords = ([xs(:),ys(:)]);   %ascending x and y values
        coords_opp = [xs_opp(:),ys_opp(:)]; %descending x and y values
    end
    
    pos1_norm = [coords(length(xsToFill),1),coords(length(xsToFill),2)];
    pos2_norm = [coords_opp(length(xsToFill),1),coords_opp(length(xsToFill),2)];
    figure(1);imshow(uint8(input_image));
    hold on;
    scatter(pos1_norm(1),pos1_norm(2),'r.');
    hold on;
    scatter(pos2_norm(1),pos2_norm(2),'b.');
    hold on;
    plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'b');
    
    I = input_image;
    coords_norm = cat(1, coords_opp, coords);
    c = improfile(I,coords(:,1),coords(:,2)); %array of intensities
    c_opp = improfile(I,coords_opp(:,1),coords_opp(:,2)); %array of intensities
    
    drawnow;
    figure(2);plot(c);  %intensity vs index plot.
    figure(3);plot(c_opp);

    %%length estimation
    RangeOfIntensities = range(c);
    RangeOfIntensities_opp = range(c_opp);
    [MinIntensity,MinIndex] = min(c);
    [MinIntensity_opp,MinIndex_opp] = min(c_opp);
    Threshold = RangeOfIntensities * .6;
    Threshold_opp = RangeOfIntensities_opp * .6;
    
    %find start of vessel
    for j=(MinIndex+1):1:length(c)
        if abs(c(j)- MinIntensity) >= Threshold
            disp('StartOfVessel');
            disp(j);
            StartOfVessel = j;
            break;
        end
    end
    %find end of vessel
    for k = (MinIndex_opp+1):1:length(c_opp)
        if abs((c_opp(k)- MinIntensity_opp)) >= Threshold_opp
            EndOfVessel = k;
            disp('EndOfVessel');
            disp(k);
            break;
        end
    end
    
    xs_intensity = linspace(pos1(1), pos1_norm(1), length(c));           %x coords of intensity line
    ys_intensity = linspace(pos1(2), pos1_norm(2), length(c));           %y coords of intensity line
    coords_intensity = [xs_intensity(:),ys_intensity(:)];           %coordinates of the intensity line#
    
    xs_intensity_opp = linspace(pos1(1), pos2_norm(1), length(c_opp));           %x coords of intensity line
    ys_intensity_opp = linspace(pos1(2), pos2_norm(2), length(c_opp));           %y coords of intensity line
    coords_intensity_opp = [xs_intensity_opp(:),ys_intensity_opp(:)];
    
    pos1 = [coords_intensity(StartOfVessel,1),coords_intensity(StartOfVessel,2)];
    
    pos2 = [coords_intensity_opp(EndOfVessel,1),coords_intensity_opp(EndOfVessel,2)];
    
    
    DiamterOfVessel = (sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2));
%     figure(1);
%     hold on
%     plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'r');
    
    
    disp(DiamterOfVessel);
    diameters1 = [pos1; diameters1];
    diameters2 = [pos2; diameters2];
    diameterslength = [DiamterOfVessel; diameterslength];
    
    
end
 
    output = [diameters1,diameters2,diameterslength];
    output = output(1:end-1,:);
end
