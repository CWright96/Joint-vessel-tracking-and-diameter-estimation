%%Diameter Estimation


function[] = Diameter_Estimation(accurate_centerline, input_image)
disp(accurate_centerline);
imshow(uint8(input_image));

for i = 1:length(accurate_centerline)
    if i ~= length(accurate_centerline)
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
        Grad_normal = -1/m;     %gradient of normal line
        
        xsToFill = [0 1 2 3 4 5]; %arbituary values used to find the x and y coordinates of a the normal line
        xsToFill = xsToFill *.5; %reduce the length of the normal
        xs = (xsToFill)+x1;      %x coordinates of the normal
        ys = (Grad_normal*(xs-x1)) + y1;   %y coordinates of the normal
        xs_opp = (-1*xsToFill)+x1;  %descending x values
        ys_opp = (Grad_normal*(xs_opp-x1)) + y1;    %descending y values
        coords = ([xs(:),ys(:)]);   %ascending x and y values
        coords_opp = [xs_opp(:),ys_opp(:)]; %descending x and y values
        
        
        pos1_norm = [coords(length(xsToFill),1),coords(length(xsToFill),2)];
        pos2_norm = [coords_opp(length(xsToFill),1),coords_opp(length(xsToFill),2)];
        figure(1);imshow(uint8(input_image));
        hold on
        scatter(pos1_norm(1),pos1_norm(2),'b.')
        hold on
        scatter(pos2_norm(1),pos2_norm(2),'b.')
        hold on
        plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'b')
        
        I = input_image;
        coords_norm = cat(1, coords_opp, coords);
        c = improfile(I,coords_norm(:,1),coords_norm(:,2)); %array of intensities
        
        drawnow
        figure(2);plot(c);  %intensity vs index plot.
        
        %         %%length estimation
        %         MeanOfIntensities = mean(c);
        %         SDofIntensities = std(c);
        %         [MinIntensity,MinIndex] = min(c);
        %         Threshold = MeanOfIntensities + 2*SDofIntensities;
        %         %find start of vessel
        %         for j=(MinIndex-1):-1:1
        %             if abs(c(j))>= Threshold
        %                 disp(j);
        %                 StartOfVessel = j;
        %                 break;
        %             end
        %         end
        %         %find end of vessel
        %         for k = (MinIndex+1):1:length(c)
        %             if abs(c(k))>= Threshold
        %                 EndOfVessel = k;
        %                 disp(EndOfVessel);
        %                 break;
        %             end
        %         end
        
        %%length estimation
        RangeOfIntensities = range(c);
        [MinIntensity,MinIndex] = min(c);
        Threshold = RangeOfIntensities * .6;
        %find start of vessel
        for j=(MinIndex-1):-1:1
            if abs(c(j)- MinIntensity) >= Threshold
                disp(j);
                StartOfVessel = j;
                break;
            end
        end
        %find end of vessel
        for k = (MinIndex+1):1:length(c)
            if abs((c(k)- MinIntensity)) >= Threshold
                EndOfVessel = k;
                disp(EndOfVessel);
                break;
            end
        end
        
        xs_intensity = linspace(pos1_norm(1), pos2_norm(1), length(c));           %x coords of intensity line
        ys_intensity = linspace(pos1_norm(2), pos2_norm(2), length(c));           %y coords of intensity line
        coords_intensity = [xs_intensity(:),ys_intensity(:)];           %coordinates of the intensity line
        pos1 = [coords_intensity(StartOfVessel,1),coords_intensity(StartOfVessel,2)];
        pos2 = [coords_intensity(EndOfVessel,1),coords_intensity(EndOfVessel,2)];
        
        DiamterOfVessel = (sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2));
        figure(1);
        hold on
        plot([pos1(1) pos2(1)],[pos1(2),pos2(2)],'r');
        
        
        disp(DiamterOfVessel);
    else
        %disp(accurate_centerline(i,:));
    end
end


end
