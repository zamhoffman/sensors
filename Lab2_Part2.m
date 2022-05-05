%%% ME220, Lab 1
% Chris Osgood and Zach Hoffman, 5/1/22
clc; clear; close all;

%%%%%%%% Part 2 %%%%%%%%

data = readmatrix('Accelerometer_23.csv');
data = readmatrix('Accelerometer_bag.csv');

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

%%% try new centered bandpass
% [max_asd, ind] = max(mag_asd(2:end));
% f_c = f(ind);
% f_pass = [f_c-.3, f_c+.3];

%%% Filter (band pass between 1 and 2 Hz)
f_pass = [1,2];
filt = bandpass(mag, f_pass, freq);
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
           if i > length(filt)
               break
           end
       end
    end
    i = i + 1;
end
msg = "Original Filter: You must have taken " + count + " steps!";
disp(msg)




%%%%%%% Updated Filter %%%%%%%%

%%%% Do a new filter to count high freq jostles. Then we will remove those
%%%% high freq jostles from our total step count to remove overcounting of
%%%% our steps when the original filter mistakes jostles for steps. 
%%% High pass filter, above 4 Hz
f_pass_hf = 40; % Hz
filt_hf = highpass(mag, f_pass_hf, freq);
figure;
plot(t, filt_hf);
title('High Frequency Filtered Magnitude of Acceleration');
xlabel('time (s)'); ylabel('Acceleration (m/s^2)');
grid on; grid minor;

%%% plot ASD of hf fitlered data
[f, filt_asd_hf] = ASD(filt_hf, freq);
figure;
plot(f, filt_asd_hf);
title('Amplitude Spectral Density of High Frequency Filtered Magnitude of Acceleration');
xlabel('freq (Hz)'); ylabel('Amplitude (m/s^2/\surd(Hz)');
grid on; grid minor;


%%% Count high freq jostles threshold as number of peaks over thresh_hf
count_hf = 0;
thresh_hf = (.5) * max(filt_hf);
i = 1;
while i <= length(filt_hf)
    if filt_hf(i) > thresh_hf
       count_hf = count_hf + 1;
       while filt_hf(i) > thresh_hf
           i = i + 10;
           if i > length(filt_hf)
               break
           end
       end
    end
    i = i + 1;
end

% subtract out jostles from original step count to get final count
msg = "Original Filter: You must have taken " + (count - count_hf) + " steps!";
disp(msg)

