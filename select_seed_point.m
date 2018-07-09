% This function plot input image and gives seed-points(2 seed-points)
% require and give back centerlines position and their direction.
function [accurate_centerline direction] = select_seed_point(input_image)

direction = [];
figure(1); imshow(uint8(input_image))
accurate_centerline = ginput(2);    
figure(1); imshow(uint8(input_image))
hold on
figure(1);plot(accurate_centerline(:,1),accurate_centerline(:,2),'ro')
drawnow

dir = atand((-accurate_centerline(2,2)+ accurate_centerline(1,2))/...
(accurate_centerline(2,1) - accurate_centerline(1,1)));
if accurate_centerline(1,1) > accurate_centerline(2,1)
    if accurate_centerline(1,2) < accurate_centerline(2,2)
        dir = dir - 180;
    end
    if accurate_centerline(1,2) > accurate_centerline(2,2)
        dir = dir + 180;
    end
    if dir ==0
        if accurate_centerline(1,1) > accurate_centerline(2,1)
            dir = 180;end

        if accurate_centerline(1,1) < accurate_centerline(2,1)
            dir = 0;end
    end
end
direction = dir;
end


