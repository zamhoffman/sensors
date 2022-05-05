%%% ME220, Lab 1
% Chris Osgood and Zach Hoffman, 4/26/22
clc; clear; close all;

%%%%%%%% Part 1 %%%%%%%%

data = readmatrix('Accelerometer1.csv');
% data = readmatrix('Accelerometer2.csv');
% data = readmatrix('Accelerometer3.csv');
% data = readmatrix('Accelerometer4.csv');
% data = readmatrix('Accelerometer5.csv');

t = data(:,1);
accel = data(:,2:4);

%%% plot 3 axis accelerations
figure;
plot(t, accel(:,1));
title('X-Direction Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;
figure;
plot(t, accel(:,2));
title('Y-Direction Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;
figure;
plot(t, accel(:,3));
title('Z-Direction Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;

%%% find and plot magnitude of accelerations
mag = vecnorm(accel, 2, 2);
figure;
plot(t, mag);
title('Magnitude of Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;

%%% find and plot ASD of magnitude of acceleration
freq = 1 / mean(diff(t));
[f, mag_asd] = ASD(mag, freq);
figure();
plot(f,mag_asd);
title('Amplitude Spectral Density of Magnitude of Acceleration');
xlabel('freq (Hz)'); ylabel('Amplitude (m/s^2/\surd(Hz)');
grid on; grid minor;

%%% Filter (band pass between 1 and 2 Hz)
filt = bandpass(mag, [1,2], freq);
figure;
plot(t, filt);
title('Filtered Magnitude of Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;

%%% plot ASD of fitlered data
[f, filt_asd] = ASD(filt, freq);
figure;
plot(f, filt_asd);
title('Amplitude Spectral Density of Filtered Magnitude of Acceleration');
xlabel('freq (Hz)'); ylabel('Amplitude (m/s^2/\surd(Hz)');
grid on; grid minor;

%%% Count step threshold -- number of peaks over 1.5
count = 0;
thresh = 1.5;
i = 1;
while i <= length(filt)
    if filt(i) > thresh
       count = count + 1;
       while filt(i) > thresh
           i = i + 10;
       end
    end
    i = i + 1;
end
msg = "You must have taken " + count + " steps!";
disp(msg)


%%%%%%%% Part 2 %%%%%%%%


