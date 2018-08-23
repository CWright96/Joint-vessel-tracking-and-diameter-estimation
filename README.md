# Joint-vessel-tracking-and-diameter-estimation
Author: Christopher Wright
Code for my MSc project based on existing work completed by Masoud Elhami Asl et al and 
presented in the paper Tracking and diameter estimation of retinal vessels using Gaussian 
process and Radon transform." Journal of Medical Imaging 4.3 (2017): 034006.

This project is for academic purposes only and the code it is based on is not my property.

To use the programme run the main.m file and select the fundus image you wish to have the diameters estimated on.
After this step you must choose 2 point on a vessel the first will be the begining of the tracking and the second
will be the second in the tracking step. The direction of tracking will be the direction between these two points.
Once the tracking is complete the diameter estimation will be completed using the "Diameter_estimation.m" function.
Results will be displayed once the estimation is complete.