%%Diameter Estimation
%%Description
%Fully automated retinal vessel diameter estimation using the centreline
%that is caluclated using a gaussian process algorithm created by 
%Masoud Elhami Asl.
%This function uses the accurate centreline to create a normal line at the
%first point of a pair. The pixel intensities along this line are then
%found using improfile. Given that the pixel intensities of the vessels are
%less than the background this information is used to find the edges of the
%vessles using a thresholding method. The diameter is then measured using
%basic gemetry finding the distance between two points in space.
%Author: Chris Wright
%Supervisor Dr Ali Gooya

function [output] = Diameter_Estimation(accurate_centerline, input_image)

%%INPUT
%   -accurate_centerline = array of 52 points on a vessel
%   -input_image = image that the centreline is calculated on
%%OUTPUT
%   -output = 51*5 array containing coordinates of the edges and the
%             distance between the points

%disp(accurate_centerline);     %debugging not required


%creating arrays for the outputs to go into
diameters1 = zeros(1,2);
diameters2 = zeros(1,2);
diameterslength = zeros(1);

%greyscale the image if it isn't already in that colourspace
if size(input_image,3)==3
    input_image = rgb2gray(input_image);
end

%imshow(uint8(input_image));    %show the image if required

%loops through the whole centrline array apart from the last value due to
%alggorithm limitations
for i = 1:length(accurate_centerline)-1
    disp(i);    %index of accurate_centerline that is being calculated
    %disp(accurate_centerline(i,:));
    pos1 = accurate_centerline(i,:);    %first position of the centreline pair
    x1 = pos1(1);
    y1 = pos1(2);
    %disp(accurate_centerline(i+1,:));
    pos2 = accurate_centerline(i+1,:);  %second postion of the centreline pair
    x2 = pos2(1);
    y2 = pos2(2);
    coeffs = polyfit([x1,x2],[y1,y2],1); %coefficents of straight line from consecutive accurate centreline points
    m=coeffs(1);    %gradient of concecutive accurate centreline points
    %c=coeffs(2);   %not required
    
    %Throughout this function the suffix "_opp" is used to denote if the
    %point is below pos1 or not
    
    %check for centreline pair with near 0 gradient and assume that the
    %normal for this line is vertical
    if abs(m) <=1e-3
        m = 0;
        xsToFill = ones([9,1]); %calculating the x values of the vertical line
        xs = (xsToFill)*x1;     %above pos1
        xs_opp = (xsToFill)*x1; %below pos1
        ysToFill = 0:.5:4;      %used to calulate the y values of the vertical line
        ysToFill = ysToFill * .75;  %make the line calculated shorter
        ys = ysToFill + pos1(2);    %calculate the y values above pos1
        ys_opp = pos1(2) - ysToFill;%cacluate the y values below pos1
    else    %non horizontal lines can be dealt with noramlly
        Grad_normal = -1/m;     %gradient of normal line
        xsToFill = 0:.5:4; %arbituary values used to find the x and y coordinates of a the normal line
        xsToFill = xsToFill *.75; %reduce the length of the normal
        xs = (xsToFill)+x1;      %x coordinates of the normal
        ys = (Grad_normal*(xs-x1)) + y1;   %y coordinates of the normal
        xs_opp = (-1*xsToFill)+x1;  %descending x values
        ys_opp = (Grad_normal*(xs_opp-x1)) + y1;    %descending y values
        
    end
    
    coords = ([xs(:),ys(:)]);   %ascending x and y values
    coords_opp = [xs_opp(:),ys_opp(:)]; %descending x and y values
    
    pos1_norm = [coords(length(xsToFill),1),coords(length(xsToFill),2)];    %position of the normal line above pos1
    pos2_norm = [coords_opp(length(xsToFill),1),coords_opp(length(xsToFill),2)];    %position ofthe normal line below pos1

%%uncomment this section if you wish to see the points drawn on the image every cycle
%increases running time significantly
%     figure(1);imshow(uint8(input_image));
%     hold on;
%     scatter(pos1_norm(1),pos1_norm(2),'r.');
%     hold on;
%     scatter(pos2_norm(1),pos2_norm(2),'b.');
%     hold on;
%     plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'b');
    
    %find intensities along the normal line
    I = input_image;
    c = improfile(I,coords(:,1),coords(:,2)); %array of intensities
    c_opp = improfile(I,coords_opp(:,1),coords_opp(:,2)); %array of intensities
    
%   uncomment this section if you wish to see the intensity profiles
%     drawnow;
%     figure(2);plot(c);  %intensity vs index plot.
%     figure(3);plot(c_opp);

    %%length estimation
    %First the range of values over the intensity profile is found
    RangeOfIntensities = range(c);          
    RangeOfIntensities_opp = range(c_opp);
    %the index of the minimum value of the intensity profile is
    %located within the vessel
    [MinIntensity,MinIndex] = min(c);
    [MinIntensity_opp,MinIndex_opp] = min(c_opp);
    %The threshold value is chosen by inspection of pixel intensities
    %across multiple images 60% gives the best results
    Threshold = RangeOfIntensities * .9;
    Threshold_opp = RangeOfIntensities_opp * .9;
    
    %find start of vessel
    StartOfVessel = 0;  %this is used to check that a start has been found
    %loops over the intensity profile above pos1 from the index that
    %minimum value is found at. If the difference between the miniumum
    %value and the intenstiy at the index k is beyond the threshold then it
    %is said that the index k is at the edge of the vessel.
    for j=(MinIndex+1):1:length(c)  
        if abs(c(j)- MinIntensity) >= Threshold
            disp('StartOfVessel');
            disp(j);
            StartOfVessel = j;
            break;
        end
    end
    %find end of vessel
    EndOfVessel = 0;
    %as above but works on coordinates below pos1
    for k = (MinIndex_opp+1):1:length(c_opp)
        if abs((c_opp(k)- MinIntensity_opp)) >= Threshold_opp
            EndOfVessel = k;
            disp('EndOfVessel');
            disp(k);
            break;
        end
    end
    %this is used when a start/end of the vessel is not found along the
    %centreline. Simply put it walks backwarads along the profile instead
    %of forwards and finds the edge in that manner
    if StartOfVessel == 0
        for j=(MinIndex):-1:1
            if abs(c(j)- MinIntensity) >= Threshold
                disp('StartOfVessel');
                disp(j);
                StartOfVessel = j;
                break;
            end
        end
    end
    %as above but to find the end of the vessel below pos1
    if EndOfVessel == 0
        for k = (MinIndex_opp):-1:1
            if abs((c_opp(k)- MinIntensity_opp)) >= Threshold_opp
                EndOfVessel = k;
                disp('EndOfVessel');
                disp(k);
                break;
            end
        end
    end
    
    %this section is used to find the coordinates of the starting edge and
    %ending edge of the vessel using the indexes StartOfVessel and
    %EndOfVessel.
    
    %above pos1
    xs_intensity = linspace(pos1(1), pos1_norm(1), length(c));           %x coords of intensity line
    ys_intensity = linspace(pos1(2), pos1_norm(2), length(c));           %y coords of intensity line
    coords_intensity = [xs_intensity(:),ys_intensity(:)];           %coordinates of the intensity line#
    %below pos1
    xs_intensity_opp = linspace(pos1(1), pos2_norm(1), length(c_opp));           %x coords of intensity line
    ys_intensity_opp = linspace(pos1(2), pos2_norm(2), length(c_opp));           %y coords of intensity line
    coords_intensity_opp = [xs_intensity_opp(:),ys_intensity_opp(:)];
    
    %pos1 and poss2 are replaced with the values of the edges of the vessel
    %and the centreline values are no longer needed
    pos1 = [coords_intensity(StartOfVessel,1),coords_intensity(StartOfVessel,2)];
    
    pos2 = [coords_intensity_opp(EndOfVessel,1),coords_intensity_opp(EndOfVessel,2)];
    
    %diameter is calculated using the distance between 2 points formula
    DiamterOfVessel = (sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2));
    
    %uncomment if you wish to see the diamters in real time per each
    %iteration
%     figure(1);
%     hold on
%     plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'r');
%     
    
    %output creation
    disp(DiamterOfVessel);
    diameters1 = [pos1; diameters1];
    diameters2 = [pos2; diameters2];
    diameterslength = [DiamterOfVessel; diameterslength];
    
    
end
 
    output = [diameters1,diameters2,diameterslength];   %creating the output array
    output = output(1:end-1,:); %removing the 0s from the end of the output
end
