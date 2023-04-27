% clear all
% close all

%% I/O
data = csvread("log_couloir_2.csv");
np = 128;
nd = 128;
nb_frame = (length(data(:,1))) / (128*128);
frames = reshape(data(:,2:end),128,128,4,nb_frame);


%% INIT

% Resolution en distance
freq = 24e9;
B = 0.25e9;
c = 3e8;
dd= c/(2*B);
d=(0:127)*dd;
% Resolution en vitesse
lambda = c/freq;
PRT = 1500e-6;
dv = lambda/(128*2)/PRT; 
v = (-128/2:128/2-1)*dv;


% For selecting range of interest (saturation at short range ?)
d_min = 0;
d_max = 20;
[~,i_d_min] = min(abs(d-d_min));
[~,i_d_max] = min(abs(d-d_max));

%% PROCESSING

figure(1);
for i=1:nb_frame
    % RD on 1 frame
    Range = fft(frames(:,:,:,i), [], 1);
    % mean_range = mean(Range,3);
    RD = fftshift( fft(Range(i_d_min:i_d_max,:,:), [], 2), 2);
    mean_RD = mean(RD,3);
    subplot 211
    imagesc(d(i_d_min: i_d_max), v*3.6, 20*log10(squeeze(abs(mean_RD'))))
    colormap("jet")

    % RD on j frames
    j = 5;
    if(i<nb_frame-j)
        Range = fft(frames(:,:,:,i:(i+j)), [], 1);
        % mean_range = mean(Range,3);
        RD = fftshift( fft(Range(i_d_min:i_d_max,:,:), [], 2), 2);
        mean_RD = mean(RD,3);

        subplot 212
        imagesc(d(i_d_min: i_d_max), v*3.6, 20*log10(squeeze(abs(RD(:,:,1)'))))
    end
    drawnow;
    pause(0.1)
end