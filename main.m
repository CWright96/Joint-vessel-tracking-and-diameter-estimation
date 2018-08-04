% Simple blood vessel tracking code without diameter estimation.
% Version: 1.0
% Masoud Elhami Asl
% 25 February

clear all
close all
clc

%% read image and load training data
load input.mat   
load target.mat
direction_variation = target;
[FileName,PathName] = uigetfile({'*.tif';'*.ppm';'*.png';'*.tiff';'*.jpg'},'Select image');

% for phantom
% input_image = double(imread([PathName FileName]));

% to get G kannel of retinal image:
retinal_image = imread([PathName FileName]);
input_image = 255-double(retinal_image(:,:,1));

% add noise to image
%input_image = (imnoise(uint8(input_image),'gaussian',0,1));
%input_image = double(input_image);

%% initial parameter
step_size = 1; % distance between each centerline points
mask_size = 10; %for mask center
theta_initial = 1/10; %for kernel matrix
eta = 0.000001; % for parameter estimation and gradient desent
IVP = 179; % input vector size
vessel_edge = [];

%% select seed point and initial diameter

[accurate_centerline, direction] = select_seed_point(input_image);
disp(accurate_centerline);
disp(direction);

%% this part grnerate a 3D matrix that will used to generate kernel matrix without 'for' loop
% for direction
[a,b]=size(input);
z1(1,:,:) = input;
repeated_input = repmat(z1, a,1);
% repeated_input =     [input1 input2 input3 ...]
%                       input1 input2 input3 ...
%                       input1 input2 input3 ...
%                         .      .      .

clear input input_diameter z1 z2 target

for j=1:50
    j
%% New Direction Estimation
% Parameter Estimation for Direction
    kernel_matrix = exp(-theta_initial(1) * sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3)))+.0001;
    kernel_matrix_gradient = -(sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3))).*kernel_matrix;
    gradient_func = (-1/2)*trace(kernel_matrix\kernel_matrix_gradient) + (1/2)*(direction_variation'/kernel_matrix)...
        *kernel_matrix_gradient*(kernel_matrix\direction_variation);

% Estimate Theta
    while abs(gradient_func) > 5
        kernel_matrix = exp(-theta_initial(1) * sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3)))+.0001;
        kernel_matrix_gradient = -(sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3))).*...
            exp(-theta_initial(1) * sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3)));
        gradient_func = (-1/2)*trace(kernel_matrix\kernel_matrix_gradient) + (1/2)*(direction_variation'/kernel_matrix)...
            *kernel_matrix_gradient*(kernel_matrix\direction_variation);
        if abs(gradient_func) > 5
            theta_new = theta_initial + eta*gradient_func;
            theta_initial = theta_new;
        end
    end
    
% Kernel matrix for direction estimation
    kernel_matrix = exp(-theta_initial(1) * sqrt(sum((permute(repeated_input,[2 1 3]) - repeated_input).^2,3)))+.0001;

% Generate new input based on last centerline    
    new_input = create_input(input_image, accurate_centerline(end,:),mask_size, direction(end));

    [a,b,c]=size(repeated_input);
    z1(1,1,:) = new_input;
    repeated_new_input = repmat(z1, 1,a);
    
    diff_new_input_with_other_input = (repeated_input(1,:,:) - repeated_new_input).^2;
    norm_diff_new_other(:,:,1) = -theta_initial(1)*sqrt(sum(diff_new_input_with_other_input(:,:,1:IVP),3));

% Gaussian Process Calculation
    kernel_kxsx = exp(sum(norm_diff_new_other,3))';
    kernel_kxsxs= 1.0001;

    repeated_input(:,end+1,:) = permute(repeated_new_input,[2 1 3]);
    repeated_input(end+1,:,:) = repeated_input(1,:,:);
    
    mx_xnew= kernel_kxsx' /kernel_matrix * direction_variation;
    direction_variation(end+1) = mx_xnew;
    direction(end+1) = direction(end) + direction_variation(end);
    %disp(direction);

% Adapt Step size based on direction variation
    step_size = 2*(90-abs(mx_xnew))/90;
    
% Find New Centerline Based on New Direction
    accurate_centerline(end+1,1)= accurate_centerline(end,1) + (step_size*cosd(direction(end)));
    accurate_centerline(end,2)= accurate_centerline(end-1,2) - (step_size*sind(direction(end)));
   
    clear norm_diff_input norm_diff_new_other z1 z2
end
%%Diameter estimation
Estimation_output = Diameter_Estimation(accurate_centerline, input_image);
Diameters_coordinates = Estimation_output(:,1:4);
Diameters = Estimation_output(:,5);
figure(1); imshow(uint8(retinal_image));
hold on
plot(Diameters_coordinates(:,1),Diameters_coordinates(:,2),'y.');
plot(Diameters_coordinates(:,3),Diameters_coordinates(:,4),'y.');
plot(accurate_centerline(:,1),accurate_centerline(:,2),'g.');